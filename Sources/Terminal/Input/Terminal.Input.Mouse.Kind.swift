#if Input
extension Terminal.Input.Mouse {

    public enum Kind: Sendable, Equatable {

        case press(Button)

        case release(Button)

        case move

        case drag(Button)

        case scrollUp

        case scrollDown

        case scrollLeft

        case scrollRight
    }
}
#endif
