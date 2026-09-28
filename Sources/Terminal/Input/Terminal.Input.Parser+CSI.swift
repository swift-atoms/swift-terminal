#if Input
public import ASCII
public import Byte
public import Cursor

extension Terminal.Input.Parser {

    static func parseCSI(
        _ input: inout ArraySlice<Byte>
    ) throws(Self.Error) -> Terminal.Input.Event
    {

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
    )
    {
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
    ) throws(Self.Error) -> Terminal.Input.Event
    {
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
