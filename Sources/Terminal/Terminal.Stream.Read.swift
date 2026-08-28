extension Terminal.Stream {

    public var read: Read {
        Read(stream: self)
    }

    public struct Read: Sendable {

        public let stream: Terminal.Stream

        public init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}
