#if Input
    import ASCII
    public import Byte
    import Cursor

    extension Terminal.Input {

        public struct Parser: Sendable {

            public init() {}
        }
    }

    extension Terminal.Input.Parser {

        public static func parse(
            _ input: inout ArraySlice<Byte>
        ) throws(Self.Error) -> Terminal.Input.Event {
            guard let byte = input.first else {
                throw .emptyInput
            }

            let code: ASCII.Code
            do {
                code = try ASCII.Code(byte)
            } catch {

                let saved = input
                do {
                    return try parseUTF8(&input)
                } catch let utf8Err {
                    if utf8Err == .incompleteSequence {
                        input = saved
                    }
                    throw utf8Err
                }
            }

            switch code {
            case .esc:
                let saved = input
                do {
                    return try parseEscapeSequence(&input)
                } catch {
                    if error == .incompleteSequence {
                        input = saved
                    }
                    throw error
                }

            case .del:
                consumeUnchecked(&input)
                return .key(Terminal.Input.Key(code: .backspace))

            case .nul...ASCII.Code.us:
                return parseControlCharacter(&input)

            case .space...ASCII.Code.tilde:
                let b = consumeUnchecked(&input)
                return .key(Terminal.Input.Key(code: .character(Unicode.Scalar(b.bitPattern))))

            default:

                throw .unrecognizedSequence
            }
        }
    }

    extension Terminal.Input.Parser {

        static func parseEscapeSequence(
            _ input: inout ArraySlice<Byte>
        ) throws(Self.Error) -> Terminal.Input.Event {

            consumeUnchecked(&input)

            guard let next = input.first else {
                throw .incompleteSequence
            }

            let code: ASCII.Code
            do {
                code = try ASCII.Code(next)
            } catch {
                throw .unrecognizedSequence
            }

            switch code {
            case .leftBracket:
                consumeUnchecked(&input)
                return try parseCSI(&input)

            case .O:
                consumeUnchecked(&input)
                return try parseSS3(&input)

            case .space...ASCII.Code.tilde:
                consumeUnchecked(&input)
                return .key(
                    Terminal.Input.Key(
                        code: .character(Unicode.Scalar(next.bitPattern)),
                        modifiers: .alt
                    )
                )

            default:
                throw .unrecognizedSequence
            }
        }
    }

    extension Terminal.Input.Parser {

        @inline(always)
        static func consume(
            _ input: inout ArraySlice<Byte>
        ) throws(Self.Error) -> Byte {
            guard let byte = input.next() else {
                throw .incompleteSequence
            }
            return byte
        }

        @inline(always)
        @discardableResult
        static func consumeUnchecked(
            _ input: inout ArraySlice<Byte>
        ) -> Byte {
            guard let byte = input.next() else {
                preconditionFailure(
                    "consumeUnchecked requires a non-empty buffer; the caller violated the !input.isEmpty precondition"
                )
            }
            return byte
        }
    }
#endif

#if Input
    import ASCII
    import Cursor

    extension Terminal.Input.Parser {

        static func parseCSI(
            _ input: inout ArraySlice<Byte>
        ) throws(Self.Error) -> Terminal.Input.Event {

            var isSGRMouse = false
            if let prefix = input.first, prefix == ASCII.Code.lessThan.byte {
                isSGRMouse = true
                consumeUnchecked(&input)
            }

            var p0: UInt32 = 0
            var p1: UInt32 = 0
            var p2: UInt32 = 0
            var paramCount: Int = 0
            var eventType: UInt32? = nil

            collectParameters(
                from: &input,
                p0: &p0,
                p1: &p1,
                p2: &p2,
                count: &paramCount,
                eventType: &eventType
            )

            let finalByte = try consume(&input)

            if isSGRMouse {
                return try parseSGRMouse(
                    buttonBits: p0,
                    column: p1,
                    row: p2,
                    paramCount: paramCount,
                    finalByte: finalByte
                )
            }

            let finalCode: ASCII.Code
            do {
                finalCode = try ASCII.Code(finalByte)
            } catch {
                throw .unrecognizedSequence
            }
            switch finalCode {
            case .A:
                return .key(
                    Terminal.Input.Key(code: .up, modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0))
                )

            case .B:
                return .key(
                    Terminal.Input.Key(
                        code: .down,
                        modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)
                    )
                )

            case .C:
                return .key(
                    Terminal.Input.Key(
                        code: .right,
                        modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)
                    )
                )

            case .D:
                return .key(
                    Terminal.Input.Key(
                        code: .left,
                        modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)
                    )
                )

            case .H:
                return .key(
                    Terminal.Input.Key(
                        code: .home,
                        modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)
                    )
                )

            case .F:
                return .key(
                    Terminal.Input.Key(
                        code: .end,
                        modifiers: modifiersFromCSI(paramCount >= 2 ? p1 : 0)
                    )
                )

            case .Z:
                return .key(Terminal.Input.Key(code: .backtab))

            case .tilde:
                return try parseTildeKey(
                    keyNumber: p0,
                    modifierParam: paramCount >= 2 ? p1 : 0,
                    paramCount: paramCount
                )

            case .u:
                return try parseKittyKeyboard(
                    codepoint: p0,
                    modifierParam: paramCount >= 2 ? p1 : 0,
                    eventType: eventType ?? 0,
                    hasEventType: eventType != nil
                )

            default:
                throw .unrecognizedSequence
            }
        }
    }

    extension Terminal.Input.Parser {

        static func collectParameters(
            from input: inout ArraySlice<Byte>,
            p0: inout UInt32,
            p1: inout UInt32,
            p2: inout UInt32,
            count: inout Int,
            eventType: inout UInt32?
        ) {
            var current: UInt32 = 0
            var needsPush = false

            while let byte = input.first {

                if byte.bitPattern >= ASCII.Code.`0`.underlying && byte.bitPattern <= ASCII.Code.`9`.underlying {
                    current = current &* 10 &+ UInt32(byte.bitPattern &- 0x30)
                    needsPush = true
                    consumeUnchecked(&input)
                } else if byte == ASCII.Code.semicolon.byte {
                    pushParam(current, p0: &p0, p1: &p1, p2: &p2, count: &count)
                    current = 0
                    needsPush = true
                    consumeUnchecked(&input)
                } else if byte == ASCII.Code.colon.byte {

                    pushParam(current, p0: &p0, p1: &p1, p2: &p2, count: &count)
                    current = 0
                    needsPush = false
                    consumeUnchecked(&input)

                    while let b = input.first {
                        guard b.bitPattern >= ASCII.Code.`0`.underlying && b.bitPattern <= ASCII.Code.`9`.underlying else { break }
                        current = current &* 10 &+ UInt32(b.bitPattern &- 0x30)
                        consumeUnchecked(&input)
                    }
                    eventType = current
                    current = 0
                } else {
                    break
                }
            }

            if needsPush {
                pushParam(current, p0: &p0, p1: &p1, p2: &p2, count: &count)
            }
        }

        @inline(always)
        private static func pushParam(
            _ value: UInt32,
            p0: inout UInt32,
            p1: inout UInt32,
            p2: inout UInt32,
            count: inout Int
        ) {
            switch count {
            case 0: p0 = value
            case 1: p1 = value
            case 2: p2 = value
            default: break
            }
            count += 1
        }
    }

    extension Terminal.Input.Parser {

        @inline(always)
        static func modifiersFromCSI(_ param: UInt32) -> Terminal.Input.Key.Modifiers {
            guard param > 1 else { return [] }
            return Terminal.Input.Key.Modifiers(rawValue: UInt8(truncatingIfNeeded: param &- 1))
        }
    }

    extension Terminal.Input.Parser {

        static func parseTildeKey(
            keyNumber: UInt32,
            modifierParam: UInt32,
            paramCount: Int
        ) throws(Self.Error) -> Terminal.Input.Event {
            guard paramCount >= 1 else { throw .unrecognizedSequence }

            let modifiers = modifiersFromCSI(modifierParam)

            let code: Terminal.Input.Key.Code
            switch keyNumber {
            case 1: code = .home
            case 2: code = .insert
            case 3: code = .delete
            case 4: code = .end
            case 5: code = .pageUp
            case 6: code = .pageDown
            case 11: code = .function(1)
            case 12: code = .function(2)
            case 13: code = .function(3)
            case 14: code = .function(4)
            case 15: code = .function(5)
            case 17: code = .function(6)
            case 18: code = .function(7)
            case 19: code = .function(8)
            case 20: code = .function(9)
            case 21: code = .function(10)
            case 23: code = .function(11)
            case 24: code = .function(12)

            case 200:
                return .paste("")

            case 201:
                throw .unrecognizedSequence

            default:
                throw .unrecognizedSequence
            }

            return .key(Terminal.Input.Key(code: code, modifiers: modifiers))
        }
    }

    extension Terminal.Input.Parser {

        static func parseSS3(
            _ input: inout ArraySlice<Byte>
        ) throws(Self.Error) -> Terminal.Input.Event {
            let byte = try consume(&input)

            let asciiCode: ASCII.Code
            do {
                asciiCode = try ASCII.Code(byte)
            } catch {
                throw .unrecognizedSequence
            }
            let code: Terminal.Input.Key.Code
            switch asciiCode {
            case .P: code = .function(1)
            case .Q: code = .function(2)
            case .R: code = .function(3)
            case .S: code = .function(4)
            case .H: code = .home
            case .F: code = .end
            default: throw .unrecognizedSequence
            }

            return .key(Terminal.Input.Key(code: code))
        }
    }
#endif

#if Input
    import ASCII
    import Cursor

    extension Terminal.Input.Parser {

        static func parseControlCharacter(
            _ input: inout ArraySlice<Byte>
        ) -> Terminal.Input.Event {
            let byte = consumeUnchecked(&input)

            let code = ASCII.Code(unchecked: byte)
            switch code {
            case .cr:
                return .key(Terminal.Input.Key(code: .enter))

            case .tab:
                return .key(Terminal.Input.Key(code: .tab))

            case .bs:
                return .key(Terminal.Input.Key(code: .backspace))

            case .nul:
                return .key(
                    Terminal.Input.Key(
                        code: .character(Unicode.Scalar(ASCII.Code.space.underlying)),
                        modifiers: .control
                    )
                )

            default:

                guard code <= .sub else {

                    return .key(
                        Terminal.Input.Key(
                            code: .character(Unicode.Scalar(byte.bitPattern &+ 0x40)),
                            modifiers: .control
                        )
                    )
                }

                return .key(
                    Terminal.Input.Key(
                        code: .character(Unicode.Scalar(byte.bitPattern &+ 0x60)),
                        modifiers: .control
                    )
                )
            }
        }
    }
#endif

#if Input
    import ASCII
    import Cursor

    extension Terminal.Input.Parser {

        static func parseKittyKeyboard(
            codepoint: UInt32,
            modifierParam: UInt32,
            eventType: UInt32,
            hasEventType: Bool
        ) throws(Self.Error) -> Terminal.Input.Event {
            let modifiers = modifiersFromCSI(modifierParam)

            let kind: Terminal.Input.Key.Kind? =
                if hasEventType {
                    switch eventType {
                    case 1: .press
                    case 2: .repeat
                    case 3: .release
                    default: nil
                    }
                } else {
                    nil
                }

            let code = mapCodepointToKeyCode(codepoint)

            let text: Swift::String?
            if let scalar = Unicode.Scalar(codepoint),
                codepoint >= 0x20 && codepoint != 0x7F && codepoint < 0xE000
            {
                text = Swift::String(scalar)
            } else {
                text = nil
            }

            return .key(Terminal.Input.Key(code: code, modifiers: modifiers, text: text, kind: kind))
        }

        private static func mapCodepointToKeyCode(_ codepoint: UInt32) -> Terminal.Input.Key.Code {
            switch codepoint {
            case 9: .tab
            case 13: .enter
            case 27: .escape
            case 127: .backspace
            case 57344...57503: .kitty(codepoint)

            default:
                if let scalar = Unicode.Scalar(codepoint) {
                    .character(scalar)
                } else {
                    .kitty(codepoint)
                }
            }
        }
    }
#endif

#if Input
    import ASCII
    import Cursor

    extension Terminal.Input.Parser {

        static func parseSGRMouse(
            buttonBits: UInt32,
            column: UInt32,
            row: UInt32,
            paramCount: Int,
            finalByte: Byte
        ) throws(Self.Error) -> Terminal.Input.Event {
            guard paramCount >= 3 else { throw .unrecognizedSequence }

            let isRelease = finalByte == ASCII.Code.m.byte
            let isMotion = buttonBits & 32 != 0

            var modifiers = Terminal.Input.Key.Modifiers()
            if buttonBits & 4 != 0 { modifiers.insert(.shift) }
            if buttonBits & 8 != 0 { modifiers.insert(.alt) }
            if buttonBits & 16 != 0 { modifiers.insert(.control) }

            let buttonValue = buttonBits & ~UInt32(4 | 8 | 16 | 32)

            let kind: Terminal.Input.Mouse.Kind
            switch buttonValue {
            case 0:
                kind = isRelease ? .release(.left) : (isMotion ? .drag(.left) : .press(.left))

            case 1:
                kind = isRelease ? .release(.middle) : (isMotion ? .drag(.middle) : .press(.middle))

            case 2:
                kind = isRelease ? .release(.right) : (isMotion ? .drag(.right) : .press(.right))

            case 3:
                kind = .move

            case 64:
                kind = .scrollUp

            case 65:
                kind = .scrollDown

            case 66:
                kind = .scrollLeft

            case 67:
                kind = .scrollRight

            case 128:
                kind =
                    isRelease ? .release(.backward) : (isMotion ? .drag(.backward) : .press(.backward))

            case 129:
                kind = isRelease ? .release(.forward) : (isMotion ? .drag(.forward) : .press(.forward))

            default:
                throw .unrecognizedSequence
            }

            return .mouse(
                Terminal.Input.Mouse(
                    kind: kind,
                    column: UInt16(truncatingIfNeeded: column),
                    row: UInt16(truncatingIfNeeded: row),
                    modifiers: modifiers
                )
            )
        }
    }
#endif

#if Input
    import ASCII
    import Cursor

    extension Terminal.Input.Parser {

        static func parseUTF8(
            _ input: inout ArraySlice<Byte>
        ) throws(Self.Error) -> Terminal.Input.Event {
            let first = consumeUnchecked(&input)

            let length: Int
            let initial: UInt32

            switch first.bitPattern {
            case 0xC0...0xDF:
                length = 2
                initial = UInt32(first.bitPattern & 0x1F)

            case 0xE0...0xEF:
                length = 3
                initial = UInt32(first.bitPattern & 0x0F)

            case 0xF0...0xF7:
                length = 4
                initial = UInt32(first.bitPattern & 0x07)

            default:
                throw .invalidUTF8
            }

            var codepoint = initial
            for _ in 1..<length {
                guard let byte = input.first else {
                    throw .incompleteSequence
                }
                guard byte.bitPattern & 0xC0 == 0x80 else {
                    throw .invalidUTF8
                }
                consumeUnchecked(&input)
                codepoint = (codepoint << 6) | UInt32(byte.bitPattern & 0x3F)
            }

            guard let scalar = Unicode.Scalar(codepoint) else {
                throw .invalidUTF8
            }

            return .key(Terminal.Input.Key(code: .character(scalar)))
        }
    }
#endif
