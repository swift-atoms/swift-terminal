public import Terminal_Primitive

extension Terminal {

    public struct Error: Swift.Error, Sendable {

        public let operation: Operation

        public let underlying: Underlying

        public init(operation: Operation, underlying: Underlying) {
            self.operation = operation
            self.underlying = underlying
        }
    }
}

extension Terminal.Error: CustomStringConvertible {

    public var description: Swift.String {
        switch underlying {
        case .kernel(let error):
            return "Terminal.\(operation): \(error)"

        case .platform(let error):
            return "Terminal.\(operation): \(error)"

        case .unsupported:
            return "Terminal.\(operation): not supported on this platform"
        }
    }
}
