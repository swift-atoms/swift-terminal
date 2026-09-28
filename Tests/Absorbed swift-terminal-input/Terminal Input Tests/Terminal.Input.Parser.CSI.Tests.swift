#if Input
import Terminal
import Testing

@Suite("Parser — CSI Arrow Keys")
struct CSIArrowTests {

    @Test
    func `Arrow up: ESC [ A`() throws {
        let event = try parse([0x1B, 0x5B, 0x41])
        #expect(event == .key(Key(code: .up)))
    }

    @Test
    func `Arrow down: ESC [ B`() throws {
        let event = try parse([0x1B, 0x5B, 0x42])
        #expect(event == .key(Key(code: .down)))
    }

    @Test
    func `Arrow right: ESC [ C`() throws {
        let event = try parse([0x1B, 0x5B, 0x43])
        #expect(event == .key(Key(code: .right)))
    }

    @Test
    func `Arrow left: ESC [ D`() throws {
        let event = try parse([0x1B, 0x5B, 0x44])
        #expect(event == .key(Key(code: .left)))
    }
}

@Suite("Parser — CSI Modified Keys")
struct CSIModifiedKeyTests {

    @Test
    func `Ctrl+Up: ESC [ 1 ; 5 A`() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x3B, 0x35, 0x41])
        #expect(event == .key(Key(code: .up, modifiers: .control)))
    }

    @Test
    func `Shift+Right: ESC [ 1 ; 2 C`() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x3B, 0x32, 0x43])
        #expect(event == .key(Key(code: .right, modifiers: .shift)))
    }

    @Test
    func `Alt+Down: ESC [ 1 ; 3 B`() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x3B, 0x33, 0x42])
        #expect(event == .key(Key(code: .down, modifiers: .alt)))
    }

    @Test
    func `Ctrl+Shift+Left: ESC [ 1 ; 6 D`() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x3B, 0x36, 0x44])
        #expect(event == .key(Key(code: .left, modifiers: [.shift, .control])))
    }
}

@Suite("Parser — CSI Navigation Keys")
struct CSINavigationTests {

    @Test
    func `Home: ESC [ H`() throws {
        let event = try parse([0x1B, 0x5B, 0x48])
        #expect(event == .key(Key(code: .home)))
    }

    @Test
    func `End: ESC [ F`() throws {
        let event = try parse([0x1B, 0x5B, 0x46])
        #expect(event == .key(Key(code: .end)))
    }

    @Test
    func `Backtab: ESC [ Z`() throws {
        let event = try parse([0x1B, 0x5B, 0x5A])
        #expect(event == .key(Key(code: .backtab)))
    }
}

@Suite("Parser — CSI Tilde Keys")
struct CSITildeTests {

    @Test
    func `Insert: ESC [ 2 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x32, 0x7E])
        #expect(event == .key(Key(code: .insert)))
    }

    @Test
    func `Delete: ESC [ 3 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x33, 0x7E])
        #expect(event == .key(Key(code: .delete)))
    }

    @Test
    func `Page Up: ESC [ 5 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x35, 0x7E])
        #expect(event == .key(Key(code: .pageUp)))
    }

    @Test
    func `Page Down: ESC [ 6 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x36, 0x7E])
        #expect(event == .key(Key(code: .pageDown)))
    }

    @Test
    func `Home (tilde): ESC [ 1 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x7E])
        #expect(event == .key(Key(code: .home)))
    }

    @Test
    func `End (tilde): ESC [ 4 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x34, 0x7E])
        #expect(event == .key(Key(code: .end)))
    }
}

@Suite("Parser — CSI Function Keys")
struct CSIFunctionKeyTests {

    @Test
    func `F5: ESC [ 15 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x35, 0x7E])
        #expect(event == .key(Key(code: .function(5))))
    }

    @Test
    func `F6: ESC [ 17 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x37, 0x7E])
        #expect(event == .key(Key(code: .function(6))))
    }

    @Test
    func `F10: ESC [ 21 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x32, 0x31, 0x7E])
        #expect(event == .key(Key(code: .function(10))))
    }

    @Test
    func `F12: ESC [ 24 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x32, 0x34, 0x7E])
        #expect(event == .key(Key(code: .function(12))))
    }

    @Test
    func `Ctrl+F5: ESC [ 15 ; 5 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x31, 0x35, 0x3B, 0x35, 0x7E])
        #expect(event == .key(Key(code: .function(5), modifiers: .control)))
    }
}

@Suite("Parser — SS3 Function Keys")
struct SS3Tests {

    @Test
    func `F1: ESC O P`() throws {
        let event = try parse([0x1B, 0x4F, 0x50])
        #expect(event == .key(Key(code: .function(1))))
    }

    @Test
    func `F2: ESC O Q`() throws {
        let event = try parse([0x1B, 0x4F, 0x51])
        #expect(event == .key(Key(code: .function(2))))
    }

    @Test
    func `F3: ESC O R`() throws {
        let event = try parse([0x1B, 0x4F, 0x52])
        #expect(event == .key(Key(code: .function(3))))
    }

    @Test
    func `F4: ESC O S`() throws {
        let event = try parse([0x1B, 0x4F, 0x53])
        #expect(event == .key(Key(code: .function(4))))
    }

    @Test
    func `Home (SS3): ESC O H`() throws {
        let event = try parse([0x1B, 0x4F, 0x48])
        #expect(event == .key(Key(code: .home)))
    }

    @Test
    func `End (SS3): ESC O F`() throws {
        let event = try parse([0x1B, 0x4F, 0x46])
        #expect(event == .key(Key(code: .end)))
    }
}

@Suite("Parser — Bracketed Paste")
struct BracketedPasteTests {

    @Test
    func `Paste start: ESC [ 200 ~`() throws {
        let event = try parse([0x1B, 0x5B, 0x32, 0x30, 0x30, 0x7E])
        #expect(event == .paste(""))
    }
}

@Suite("Parser — Incomplete Sequences")
struct IncompleteCSITests {

    @Test
    func `Incomplete CSI restores position: ESC [`() {
        var buffer = ArraySlice([UInt8]([0x1B, 0x5B]).map(Byte.init(bitPattern:)))
        let saved = buffer
        #expect(throws: ParseError.incompleteSequence) {
            try Parser.parse(&buffer)
        }
        #expect(buffer == saved)
    }

    @Test
    func `Incomplete arrow restores position: ESC [ 1 ;`() {
        var buffer = ArraySlice([UInt8]([0x1B, 0x5B, 0x31, 0x3B]).map(Byte.init(bitPattern:)))
        let saved = buffer
        #expect(throws: ParseError.incompleteSequence) {
            try Parser.parse(&buffer)
        }
        #expect(buffer == saved)
    }
}

#endif
