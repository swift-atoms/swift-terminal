#if Input
import Terminal
import Testing

@Suite("Parser — SGR Mouse")
struct SGRMouseTests {

    @Test
    func `Left press at (10, 20): ESC [ < 0 ; 10 ; 20 M`() throws {
        let event = try parse([
            0x1B, 0x5B, 0x3C,
            0x30, 0x3B,
            0x31, 0x30, 0x3B,
            0x32, 0x30,
            0x4D,
        ])
        #expect(event == .mouse(Mouse(kind: .press(.left), column: 10, row: 20)))
    }

    @Test
    func `Left release at (10, 20): ESC [ < 0 ; 10 ; 20 m`() throws {
        let event = try parse([
            0x1B, 0x5B, 0x3C,
            0x30, 0x3B,
            0x31, 0x30, 0x3B,
            0x32, 0x30,
            0x6D,
        ])
        #expect(event == .mouse(Mouse(kind: .release(.left), column: 10, row: 20)))
    }

    @Test
    func `Middle press: ESC [ < 1 ; 5 ; 5 M`() throws {
        let event = try parse([
            0x1B, 0x5B, 0x3C,
            0x31, 0x3B,
            0x35, 0x3B,
            0x35,
            0x4D,
        ])
        #expect(event == .mouse(Mouse(kind: .press(.middle), column: 5, row: 5)))
    }

    @Test
    func `Right press: ESC [ < 2 ; 1 ; 1 M`() throws {
        let event = try parse([
            0x1B, 0x5B, 0x3C,
            0x32, 0x3B,
            0x31, 0x3B,
            0x31,
            0x4D,
        ])
        #expect(event == .mouse(Mouse(kind: .press(.right), column: 1, row: 1)))
    }

    @Test
    func `Scroll up: ESC [ < 64 ; 1 ; 1 M`() throws {
        let event = try parse([
            0x1B, 0x5B, 0x3C,
            0x36, 0x34, 0x3B,
            0x31, 0x3B,
            0x31,
            0x4D,
        ])
        #expect(event == .mouse(Mouse(kind: .scrollUp, column: 1, row: 1)))
    }

    @Test
    func `Scroll down: ESC [ < 65 ; 1 ; 1 M`() throws {
        let event = try parse([
            0x1B, 0x5B, 0x3C,
            0x36, 0x35, 0x3B,
            0x31, 0x3B,
            0x31,
            0x4D,
        ])
        #expect(event == .mouse(Mouse(kind: .scrollDown, column: 1, row: 1)))
    }

    @Test
    func `Left drag: ESC [ < 32 ; 10 ; 20 M`() throws {
        let event = try parse([
            0x1B, 0x5B, 0x3C,
            0x33, 0x32, 0x3B,
            0x31, 0x30, 0x3B,
            0x32, 0x30,
            0x4D,
        ])
        #expect(event == .mouse(Mouse(kind: .drag(.left), column: 10, row: 20)))
    }

    @Test
    func `Mouse move: ESC [ < 35 ; 10 ; 20 M`() throws {
        let event = try parse([
            0x1B, 0x5B, 0x3C,
            0x33, 0x35, 0x3B,
            0x31, 0x30, 0x3B,
            0x32, 0x30,
            0x4D,
        ])
        #expect(event == .mouse(Mouse(kind: .move, column: 10, row: 20)))
    }

    @Test
    func `Shift+Left press: ESC [ < 4 ; 1 ; 1 M`() throws {
        let event = try parse([
            0x1B, 0x5B, 0x3C,
            0x34, 0x3B,
            0x31, 0x3B,
            0x31,
            0x4D,
        ])
        #expect(event == .mouse(Mouse(kind: .press(.left), column: 1, row: 1, modifiers: .shift)))
    }

    @Test
    func `Ctrl+Left press: ESC [ < 16 ; 1 ; 1 M`() throws {
        let event = try parse([
            0x1B, 0x5B, 0x3C,
            0x31, 0x36, 0x3B,
            0x31, 0x3B,
            0x31,
            0x4D,
        ])
        #expect(event == .mouse(Mouse(kind: .press(.left), column: 1, row: 1, modifiers: .control)))
    }
}

#endif
