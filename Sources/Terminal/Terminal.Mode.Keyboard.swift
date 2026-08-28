extension Terminal.Mode {

    public enum Keyboard {}
}

extension Terminal.Mode.Keyboard {

    public static let enable: Swift.String = "\u{1B}[>1u"

    public static let disable: Swift.String = "\u{1B}[<u"
}
