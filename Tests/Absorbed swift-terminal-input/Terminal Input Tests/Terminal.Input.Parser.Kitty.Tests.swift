#if Input
import Terminal
import Testing

@Suite("Parser — Kitty Keyboard")
struct KittyKeyboardTests {

    @Test
    func `Ctrl+a: ESC [ 97 ; 5 u`() throws {
        let event = try parse([0x1B, 0x5B, 0x39, 0x37, 0x3B, 0x35, 0x75])
        #expect(
            event
                == .key(
                    Key(
                        code: .character("a"),
                        modifiers: .control,
                        text: "a"
                    )
                )
        )
    }

    @Test
    func `Simple 'a' key: ESC [ 97 u`() throws {
        let event = try parse([0x1B, 0x5B, 0x39, 0x37, 0x75])
        #expect(
            event
                == .key(
                    Key(
                        code: .character("a"),
                        text: "a"
                    )
                )
        )
    }

    @Test
    func `Enter in Kitty: ESC [ 13 u`() throws {

        let event = try parse([0x1B, 0x5B, 0x31, 0x33, 0x75])
        #expect(event == .key(Key(code: .enter)))
    }

    @Test
    func `Tab in Kitty: ESC [ 9 u`() throws {
        let event = try parse([0x1B, 0x5B, 0x39, 0x75])
        #expect(event == .key(Key(code: .tab)))
    }

    @Test
    func `Escape in Kitty: ESC [ 27 u`() throws {

        let event = try parse([0x1B, 0x5B, 0x32, 0x37, 0x75])
        #expect(event == .key(Key(code: .escape)))
    }

    @Test
    func `Kitty key release: ESC [ 97 ; 1 : 3 u`() throws {

        let event = try parse([
            0x1B, 0x5B,
            0x39, 0x37, 0x3B,
            0x31, 0x3A,
            0x33,
            0x75,
        ])
        #expect(
            event
                == .key(
                    Key(
                        code: .character("a"),
                        text: "a",
                        kind: .release
                    )
                )
        )
    }

    @Test
    func `Kitty key repeat: ESC [ 97 ; 1 : 2 u`() throws {
        let event = try parse([
            0x1B, 0x5B,
            0x39, 0x37, 0x3B,
            0x31, 0x3A,
            0x32,
            0x75,
        ])
        #expect(
            event
                == .key(
                    Key(
                        code: .character("a"),
                        text: "a",
                        kind: .repeat
                    )
                )
        )
    }

    @Test
    func `Kitty functional key (private use area)`() throws {

        let event = try parse([
            0x1B, 0x5B,
            0x35, 0x37, 0x33, 0x34, 0x34,
            0x75,
        ])
        #expect(event == .key(Key(code: .kitty(57344))))
    }

    @Test
    func `Shift+a: ESC [ 97 ; 2 u`() throws {
        let event = try parse([0x1B, 0x5B, 0x39, 0x37, 0x3B, 0x32, 0x75])
        #expect(
            event
                == .key(
                    Key(
                        code: .character("a"),
                        modifiers: .shift,
                        text: "a"
                    )
                )
        )
    }
}

#endif
