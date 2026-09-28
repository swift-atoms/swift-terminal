#if Input
public import ASCII
public import Byte
public import Cursor

extension Terminal.Input {

    public struct Parser: Sendable {

        public init() {}
    }
}

extension Terminal.Input.Parser {

    public static func parse(
        _ input: inout ArraySlice<Byte>
    ) throws(Self.Error) -> Terminal.Input.Event
    {
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
    ) throws(Self.Error) -> Terminal.Input.Event
    {

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
    ) throws(Self.Error) -> Byte
    {
        guard let byte = input.next() else {
            throw .incompleteSequence
        }
        return byte
    }

    @inline(always)
    @discardableResult
    static func consumeUnchecked(
        _ input: inout ArraySlice<Byte>
    ) -> Byte
    {
        guard let byte = input.next() else {
            preconditionFailure(
                "consumeUnchecked requires a non-empty buffer; the caller violated the !input.isEmpty precondition"
            )
        }
        return byte
    }
}
#endif
