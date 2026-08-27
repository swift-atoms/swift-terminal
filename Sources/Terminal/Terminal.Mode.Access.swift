extension Terminal.Mode {

    public struct Access: Sendable {
        internal let stream: Terminal.Stream
    }
}

extension Terminal.Mode.Access {

    public var raw: Terminal.Mode.Raw {
        Terminal.Mode.Raw(stream: stream)
    }
}
