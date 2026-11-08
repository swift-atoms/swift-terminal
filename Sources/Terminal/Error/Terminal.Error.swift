#if Error
    extension Terminal {

        public struct Error: Swift::Error, Sendable {

            public let operation: Operation

            public let underlying: Underlying

            public init(operation: Operation, underlying: Underlying) {
                self.operation = operation
                self.underlying = underlying
            }
        }
    }
#endif

#if Error
    extension Terminal.Error: Swift::CustomStringConvertible {

        public var description: Swift::String {
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
#endif
