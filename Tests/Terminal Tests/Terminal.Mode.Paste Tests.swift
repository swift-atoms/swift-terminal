import Terminal
import Testing

extension Terminal.Mode.Paste {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension Terminal.Mode.Paste.Test.Unit {
    @Test
    func `Enable is DEC private mode 2004h`() {
        #expect(Terminal.Mode.Paste.enable == "\u{1B}[?2004h")
    }

    @Test
    func `Disable is DEC private mode 2004l`() {
        #expect(Terminal.Mode.Paste.disable == "\u{1B}[?2004l")
    }
}

extension Terminal.Mode.Paste.Test.`Edge Case` {
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
