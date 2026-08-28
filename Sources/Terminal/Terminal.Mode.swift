extension Terminal {

    public enum Mode {}
}

extension Terminal.Stream {

    public var mode: Terminal.Mode.Access {
        Terminal.Mode.Access(stream: self)
    }
}
