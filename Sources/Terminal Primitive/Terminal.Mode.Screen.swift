extension Terminal.Mode {

    public enum Screen {}
}

extension Terminal.Mode.Screen {

    public static let enable: Swift.String = "\u{1B}[?1049h"

    public static let disable: Swift.String = "\u{1B}[?1049l"
}
