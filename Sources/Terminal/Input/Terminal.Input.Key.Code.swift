#if Input
extension Terminal.Input.Key {

    public enum Code: Sendable, Equatable {

        case character(Unicode.Scalar)

        case function(UInt8)

        case up
        case down
        case left
        case right

        case enter
        case escape
        case tab
        case backspace
        case delete

        case home
        case end
        case pageUp
        case pageDown
        case insert

        case backtab

        case kitty(UInt32)
    }
}
#endif
