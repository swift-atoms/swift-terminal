extension Terminal.Mode {

    public struct Raw: Sendable {

        public let stream: Terminal.Stream

        public init(stream: Terminal.Stream) {
            self.stream = stream
        }
    }
}
