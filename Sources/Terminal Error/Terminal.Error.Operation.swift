public import Terminal

extension Terminal.Error {

    public enum Operation: Sendable, Hashable {

        case querySize

        case enterRaw

        case exitRaw

        case enableVT
    }
}
