#if Input
import ASCII
import Byte
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

        let text: Swift.String?
        if let scalar = Unicode.Scalar(codepoint),
            codepoint >= 0x20 && codepoint != 0x7F && codepoint < 0xE000
        {
            text = Swift.String(scalar)
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
