public import Error
public import Terminal_Primitive

extension Terminal.Error {

    public enum Underlying: Sendable {

        case kernel(Error.Error)

        case platform(Error.Error)

        case unsupported
    }
}
