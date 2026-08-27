extension Terminal.Mode.Mouse {

    public enum SGR {}
}

extension Terminal.Mode.Mouse.SGR {

    public static let enable: Swift.String = "\u{1B}[?1006h"

    public static let disable: Swift.String = "\u{1B}[?1006l"
}
