import Terminal
import Testing

extension Terminal.Mode.Keyboard {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension Terminal.Mode.Keyboard.Test.Unit {
    @Test
    func `Enable pushes Kitty keyboard mode with flags 1`() {
        #expect(Terminal.Mode.Keyboard.enable == "\u{1B}[>1u")
    }

    @Test
    func `Disable pops Kitty keyboard mode`() {
        #expect(Terminal.Mode.Keyboard.disable == "\u{1B}[<u")
    }
}

extension Terminal.Mode.Keyboard.Test.`Edge Case` {
    @Test
    func `Sequences use CSI prefix without private mode marker`() {

        #expect(Terminal.Mode.Keyboard.enable.hasPrefix("\u{1B}[>"))
        #expect(Terminal.Mode.Keyboard.disable.hasPrefix("\u{1B}[<"))
    }

    @Test
    func `Both sequences end with u`() {
        #expect(Terminal.Mode.Keyboard.enable.hasSuffix("u"))
        #expect(Terminal.Mode.Keyboard.disable.hasSuffix("u"))
    }

    @Test
    func `Enable and disable are distinct`() {
        #expect(Terminal.Mode.Keyboard.enable != Terminal.Mode.Keyboard.disable)
    }
}
