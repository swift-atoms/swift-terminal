extension Terminal.Stream {

    public var interactive: Interactive {
        Interactive(stream: self)
    }

    public struct Interactive: Sendable {

        public let stream: Terminal.Stream

        public init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}
