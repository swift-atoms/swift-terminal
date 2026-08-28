extension Terminal.Mode.Mouse {

    public enum Normal {}
}

extension Terminal.Mode.Mouse.Normal {

    public static let enable: Swift.String = "\u{1B}[?1000h"

    public static let disable: Swift.String = "\u{1B}[?1000l"
}
