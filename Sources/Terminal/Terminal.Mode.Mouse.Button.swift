extension Terminal.Mode.Mouse {

    public enum Button {}
}

extension Terminal.Mode.Mouse.Button {

    public static let enable: Swift.String = "\u{1B}[?1002h"

    public static let disable: Swift.String = "\u{1B}[?1002l"
}
