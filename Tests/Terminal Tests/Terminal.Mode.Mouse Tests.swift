import Terminal
import Testing

extension Terminal.Mode.Mouse {
    @Suite
    struct `Mouse mode sequences encode distinct DEC private modes` {
        @Suite struct `Mouse mode enable and disable sequences retain their assigned mode numbers` {}
        @Suite struct `Mouse modes preserve distinct numbers and common control sequence structure` {}
    }
}

extension Terminal.Mode.Mouse.`Mouse mode sequences encode distinct DEC private modes`.`Mouse mode enable and disable sequences retain their assigned mode numbers` {
    @Test
    func `Normal enable is DEC private mode 1000h`() {
        #expect(Terminal.Mode.Mouse.Normal.enable == "\u{1B}[?1000h")
    }

    @Test
    func `Normal disable is DEC private mode 1000l`() {
        #expect(Terminal.Mode.Mouse.Normal.disable == "\u{1B}[?1000l")
    }

    @Test
    func `Button enable is DEC private mode 1002h`() {
        #expect(Terminal.Mode.Mouse.Button.enable == "\u{1B}[?1002h")
    }

    @Test
    func `Button disable is DEC private mode 1002l`() {
        #expect(Terminal.Mode.Mouse.Button.disable == "\u{1B}[?1002l")
    }

    @Test
    func `Any enable is DEC private mode 1003h`() {
        #expect(Terminal.Mode.Mouse.Any.enable == "\u{1B}[?1003h")
    }

    @Test
    func `Any disable is DEC private mode 1003l`() {
        #expect(Terminal.Mode.Mouse.Any.disable == "\u{1B}[?1003l")
    }

    @Test
    func `SGR enable is DEC private mode 1006h`() {
        #expect(Terminal.Mode.Mouse.SGR.enable == "\u{1B}[?1006h")
    }

    @Test
    func `SGR disable is DEC private mode 1006l`() {
        #expect(Terminal.Mode.Mouse.SGR.disable == "\u{1B}[?1006l")
    }
}

extension Terminal.Mode.Mouse.`Mouse mode sequences encode distinct DEC private modes`.`Mouse modes preserve distinct numbers and common control sequence structure` {
    @Test
    func `Enable sequences end with h`() {
        #expect(Terminal.Mode.Mouse.Normal.enable.hasSuffix("h"))
        #expect(Terminal.Mode.Mouse.Button.enable.hasSuffix("h"))
        #expect(Terminal.Mode.Mouse.Any.enable.hasSuffix("h"))
        #expect(Terminal.Mode.Mouse.SGR.enable.hasSuffix("h"))
    }

    @Test
    func `Disable sequences end with l`() {
        #expect(Terminal.Mode.Mouse.Normal.disable.hasSuffix("l"))
        #expect(Terminal.Mode.Mouse.Button.disable.hasSuffix("l"))
        #expect(Terminal.Mode.Mouse.Any.disable.hasSuffix("l"))
        #expect(Terminal.Mode.Mouse.SGR.disable.hasSuffix("l"))
    }

    @Test
    func `Enable and disable differ only in final byte`() {
        #expect(
            Terminal.Mode.Mouse.Normal.enable.dropLast()
                == Terminal.Mode.Mouse.Normal.disable.dropLast()
        )
        #expect(
            Terminal.Mode.Mouse.Button.enable.dropLast()
                == Terminal.Mode.Mouse.Button.disable.dropLast()
        )
        #expect(
            Terminal.Mode.Mouse.Any.enable.dropLast() == Terminal.Mode.Mouse.Any.disable.dropLast()
        )
        #expect(
            Terminal.Mode.Mouse.SGR.enable.dropLast() == Terminal.Mode.Mouse.SGR.disable.dropLast()
        )
    }

    @Test
    func `All sequences start with CSI private mode prefix`() {
        let prefix = "\u{1B}[?"
        #expect(Terminal.Mode.Mouse.Normal.enable.hasPrefix(prefix))
        #expect(Terminal.Mode.Mouse.Button.enable.hasPrefix(prefix))
        #expect(Terminal.Mode.Mouse.Any.enable.hasPrefix(prefix))
        #expect(Terminal.Mode.Mouse.SGR.enable.hasPrefix(prefix))
    }

    @Test
    func `Mode numbers are distinct`() {
        let enables = [
            Terminal.Mode.Mouse.Normal.enable,
            Terminal.Mode.Mouse.Button.enable,
            Terminal.Mode.Mouse.Any.enable,
            Terminal.Mode.Mouse.SGR.enable,
        ]
        #expect(Set(enables).count == 4)
    }
}
