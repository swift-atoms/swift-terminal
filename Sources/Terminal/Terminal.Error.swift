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
