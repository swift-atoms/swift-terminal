#if Input
extension Terminal.Input {

    public enum Event: Sendable, Equatable {

        case key(Key)

        case mouse(Mouse)

        case resize(Terminal.Size)

        case paste(Swift.String)
    }
}
#endif
