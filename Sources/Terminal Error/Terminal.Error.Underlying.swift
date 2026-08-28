public import Error
public import Terminal

extension Terminal.Error {

    public enum Underlying: Sendable {

        case kernel(Error::Error)

        case platform(Error::Error)

        case unsupported
    }
}
