extension Terminal.Mode {

    public enum Paste {}
}

extension Terminal.Mode.Paste {

    public static let enable: Swift.String = "\u{1B}[?2004h"

    public static let disable: Swift.String = "\u{1B}[?2004l"
}
