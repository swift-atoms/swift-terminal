public import Error

extension Terminal.Error {

    public enum Underlying: Sendable {

        case kernel(Error::Error)

        case platform(Error::Error)

        case unsupported
    }
}
