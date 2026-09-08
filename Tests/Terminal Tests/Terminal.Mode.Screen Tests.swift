import Terminal
import Testing

extension Terminal.Mode.Screen {
    @Suite
    struct `Screen mode sequences enable and disable the alternate buffer` {
        @Suite struct `Alternate screen enable and disable use private mode 1049` {}
        @Suite struct `Screen mode sequences share the CSI prefix and differ in their final byte` {}
    }
}

extension Terminal.Mode.Screen.`Screen mode sequences enable and disable the alternate buffer`.`Alternate screen enable and disable use private mode 1049` {
    @Test
    func `Enable is DEC private mode 1049h`() {
        #expect(Terminal.Mode.Screen.enable == "\u{1B}[?1049h")
    }

    @Test
    func `Disable is DEC private mode 1049l`() {
        #expect(Terminal.Mode.Screen.disable == "\u{1B}[?1049l")
    }
}

extension Terminal.Mode.Screen.`Screen mode sequences enable and disable the alternate buffer`.`Screen mode sequences share the CSI prefix and differ in their final byte` {
    @Test
    func `Enable and disable differ only in final byte`() {
        #expect(Terminal.Mode.Screen.enable.dropLast() == Terminal.Mode.Screen.disable.dropLast())
    }

    @Test
    func `Sequences use CSI private mode prefix`() {
        #expect(Terminal.Mode.Screen.enable.hasPrefix("\u{1B}[?"))
        #expect(Terminal.Mode.Screen.disable.hasPrefix("\u{1B}[?"))
    }
}
