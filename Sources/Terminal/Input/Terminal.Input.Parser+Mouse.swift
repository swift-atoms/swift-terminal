#if Input
import ASCII
import Byte
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
