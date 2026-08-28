extension Terminal.Mode.Mouse {

    public enum `Any` {}
}

extension Terminal.Mode.Mouse.`Any` {

    public static let enable: Swift.String = "\u{1B}[?1003h"

    public static let disable: Swift.String = "\u{1B}[?1003l"
}
