import Terminal
import Testing

extension Terminal.Mode.Keyboard {
    @Suite
    struct `Keyboard mode sequences encode Kitty enable and disable operations` {
        @Suite struct `Keyboard mode enable pushes flags one and disable pops the mode` {}
        @Suite struct `Keyboard mode sequences retain distinct CSI forms and the u suffix` {}
    }
}

extension Terminal.Mode.Keyboard.`Keyboard mode sequences encode Kitty enable and disable operations`.`Keyboard mode enable pushes flags one and disable pops the mode` {
    @Test
    func `Enable pushes Kitty keyboard mode with flags 1`() {
        #expect(Terminal.Mode.Keyboard.enable == "\u{1B}[>1u")
    }

    @Test
    func `Disable pops Kitty keyboard mode`() {
        #expect(Terminal.Mode.Keyboard.disable == "\u{1B}[<u")
    }
}

extension Terminal.Mode.Keyboard.`Keyboard mode sequences encode Kitty enable and disable operations`.`Keyboard mode sequences retain distinct CSI forms and the u suffix` {
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
