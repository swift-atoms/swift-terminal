#if Input
public import ASCII
public import Byte
public import Cursor

extension Terminal.Input.Parser {

    static func parseUTF8(
        _ input: inout ArraySlice<Byte>
    ) throws(Self.Error) -> Terminal.Input.Event
    {
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
