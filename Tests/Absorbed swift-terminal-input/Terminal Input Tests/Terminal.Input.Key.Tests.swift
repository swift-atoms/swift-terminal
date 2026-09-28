#if Input
import Terminal
import Testing

@Suite("Terminal.Input.Key")
struct KeyTests {

    @Test
    func `Key equality with same code and modifiers`() {
        let key1 = Key(code: .character("a"), modifiers: .control)
        let key2 = Key(code: .character("a"), modifiers: .control)
        #expect(key1 == key2)
    }

    @Test
    func `Key inequality with different modifiers`() {
        let key1 = Key(code: .character("a"), modifiers: .control)
        let key2 = Key(code: .character("a"), modifiers: .alt)
        #expect(key1 != key2)
    }

    @Test
    func `Key inequality with different codes`() {
        let key1 = Key(code: .character("a"))
        let key2 = Key(code: .character("b"))
        #expect(key1 != key2)
    }

    @Test
    func `Default modifiers are empty`() {
        let key = Key(code: .enter)
        #expect(key.modifiers == [])
        #expect(key.text == nil)
        #expect(key.kind == nil)
    }
}

@Suite("Terminal.Input.Key.Modifiers")
struct ModifiersTests {

    @Test
    func `Single modifier flags`() {
        #expect(Key.Modifiers.shift.rawValue == 1)
        #expect(Key.Modifiers.alt.rawValue == 2)
        #expect(Key.Modifiers.control.rawValue == 4)
        #expect(Key.Modifiers.super.rawValue == 8)
        #expect(Key.Modifiers.hyper.rawValue == 16)
        #expect(Key.Modifiers.meta.rawValue == 32)
        #expect(Key.Modifiers.capsLock.rawValue == 64)
        #expect(Key.Modifiers.numLock.rawValue == 128)
    }

    @Test
    func `Modifier combination`() {
        let mods: Key.Modifiers = [.shift, .control]
        #expect(mods.contains(.shift))
        #expect(mods.contains(.control))
        #expect(!mods.contains(.alt))
        #expect(mods.rawValue == 5)
    }

    @Test
    func `Empty modifiers`() {
        let mods = Key.Modifiers()
        #expect(mods.isEmpty)
        #expect(mods.rawValue == 0)
    }

    @Test
    func `Modifiers are hashable`() {
        let a: Key.Modifiers = [.shift, .control]
        let b: Key.Modifiers = [.shift, .control]
        #expect(a.hashValue == b.hashValue)
    }

    @Test
    func `CSI modifier encoding: value = 1 + bits`() {

        #expect(Key.Modifiers(rawValue: UInt8(2 - 1)) == .shift)
        #expect(Key.Modifiers(rawValue: UInt8(3 - 1)) == .alt)
        #expect(Key.Modifiers(rawValue: UInt8(5 - 1)) == .control)
        #expect(Key.Modifiers(rawValue: UInt8(6 - 1)) == [.shift, .control])
    }
}

@Suite("Terminal.Input.Mouse")
struct MouseTypeTests {

    @Test
    func `Mouse equality`() {
        let m1 = Mouse(kind: .press(.left), column: 10, row: 20)
        let m2 = Mouse(kind: .press(.left), column: 10, row: 20)
        #expect(m1 == m2)
    }

    @Test
    func `Mouse inequality different position`() {
        let m1 = Mouse(kind: .press(.left), column: 10, row: 20)
        let m2 = Mouse(kind: .press(.left), column: 11, row: 20)
        #expect(m1 != m2)
    }

    @Test
    func `Mouse inequality different button`() {
        let m1 = Mouse(kind: .press(.left), column: 10, row: 20)
        let m2 = Mouse(kind: .press(.right), column: 10, row: 20)
        #expect(m1 != m2)
    }

    @Test
    func `Default mouse modifiers are empty`() {
        let mouse = Mouse(kind: .press(.left), column: 1, row: 1)
        #expect(mouse.modifiers == [])
    }
}

@Suite("Terminal.Input.Event")
struct EventTypeTests {

    @Test
    func `Event equality for key events`() {
        let e1: Event = .key(Key(code: .enter))
        let e2: Event = .key(Key(code: .enter))
        #expect(e1 == e2)
    }

    @Test
    func `Event inequality between key and mouse`() {
        let key: Event = .key(Key(code: .enter))
        let mouse: Event = .mouse(Mouse(kind: .press(.left), column: 1, row: 1))
        #expect(key != mouse)
    }

    @Test
    func `Resize event equality`() {
        let e1: Event = .resize(Terminal.Size(rows: 24, columns: 80))
        let e2: Event = .resize(Terminal.Size(rows: 24, columns: 80))
        #expect(e1 == e2)
    }

    @Test
    func `Paste event equality`() {
        let e1: Event = .paste("hello")
        let e2: Event = .paste("hello")
        #expect(e1 == e2)
    }
}

#endif
