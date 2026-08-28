extension Terminal.Stream {

    public struct Write: Sendable {

        public let stream: Terminal.Stream

        @inlinable
        public init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}

extension Terminal.Stream {

    @inlinable
    public var write: Write {
        Write(stream: self)
    }
}
