import Terminal
import Testing

extension Terminal.Mode.Paste {
    @Suite
    struct `Paste mode sequences enable and disable bracketed paste` {
        @Suite struct `Bracketed paste enable and disable use private mode 2004` {}
        @Suite struct `Paste mode sequences share the CSI prefix and differ in their final byte` {}
    }
}

extension Terminal.Mode.Paste.`Paste mode sequences enable and disable bracketed paste`.`Bracketed paste enable and disable use private mode 2004` {
    @Test
    func `Enable is DEC private mode 2004h`() {
        #expect(Terminal.Mode.Paste.enable == "\u{1B}[?2004h")
    }

    @Test
    func `Disable is DEC private mode 2004l`() {
        #expect(Terminal.Mode.Paste.disable == "\u{1B}[?2004l")
    }
}

extension Terminal.Mode.Paste.`Paste mode sequences enable and disable bracketed paste`.`Paste mode sequences share the CSI prefix and differ in their final byte` {
    @Test
    func `Enable and disable differ only in final byte`() {
        #expect(Terminal.Mode.Paste.enable.dropLast() == Terminal.Mode.Paste.disable.dropLast())
    }

    @Test
    func `Sequences use CSI private mode prefix`() {
        #expect(Terminal.Mode.Paste.enable.hasPrefix("\u{1B}[?"))
        #expect(Terminal.Mode.Paste.disable.hasPrefix("\u{1B}[?"))
    }
}
