#if Input
extension Terminal.Input.Key {

    public enum Kind: Sendable, Equatable {

        case press

        case `repeat`

        case release
    }
}
#endif
