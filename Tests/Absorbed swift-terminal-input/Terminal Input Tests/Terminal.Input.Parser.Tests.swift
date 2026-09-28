#if Input
import Terminal
import Testing

typealias Key = Terminal.Input.Key
typealias Mouse = Terminal.Input.Mouse
typealias Event = Terminal.Input.Event
typealias Parser = Terminal.Input.Parser
typealias ParseError = Terminal.Input.Parser.Error

func parse(_ bytes: [UInt8]) throws(ParseError) -> Event {
    var buffer = bytes.map(Byte.init(bitPattern:))[...]
    return try Parser.parse(&buffer)
}

@Suite("Parser — Single Bytes")
struct SingleByteTests {

    @Test
    func `Printable ASCII characters`() throws {
        let event = try parse([0x61])
        #expect(event == .key(Key(code: .character("a"))))
    }

    @Test
    func `Space character`() throws {
        let event = try parse([0x20])
        #expect(event == .key(Key(code: .character(" "))))
    }

    @Test
    func `Tilde character`() throws {
        let event = try parse([0x7E])
        #expect(event == .key(Key(code: .character("~"))))
    }

    @Test
    func `DEL produces backspace`() throws {
        let event = try parse([0x7F])
        #expect(event == .key(Key(code: .backspace)))
    }

    @Test
    func `Empty input throws emptyInput`() {
        #expect(throws: ParseError.emptyInput) {
            try parse([])
        }
    }
}

@Suite("Parser — Control Characters")
struct ControlCharacterTests {

    @Test
    func `Enter (CR)`() throws {
        let event = try parse([0x0D])
        #expect(event == .key(Key(code: .enter)))
    }

    @Test
    func `Tab`() throws {
        let event = try parse([0x09])
        #expect(event == .key(Key(code: .tab)))
    }

    @Test
    func `Backspace (BS)`() throws {
        let event = try parse([0x08])
        #expect(event == .key(Key(code: .backspace)))
    }

    @Test
    func `Ctrl+A`() throws {
        let event = try parse([0x01])
        #expect(event == .key(Key(code: .character("a"), modifiers: .control)))
    }

    @Test
    func `Ctrl+C`() throws {
        let event = try parse([0x03])
        #expect(event == .key(Key(code: .character("c"), modifiers: .control)))
    }

    @Test
    func `Ctrl+Z`() throws {
        let event = try parse([0x1A])
        #expect(event == .key(Key(code: .character("z"), modifiers: .control)))
    }

    @Test
    func `Ctrl+Space (NUL)`() throws {
        let event = try parse([0x00])
        #expect(event == .key(Key(code: .character(" "), modifiers: .control)))
    }

    @Test
    func `Ctrl+Backslash (FS)`() throws {
        let event = try parse([0x1C])
        #expect(event == .key(Key(code: .character("\\"), modifiers: .control)))
    }
}

@Suite("Parser — Escape Sequences")
struct EscapeTests {

    @Test
    func `Bare ESC throws incompleteSequence`() {
        #expect(throws: ParseError.incompleteSequence) {
            try parse([0x1B])
        }
    }

    @Test
    func `Bare ESC restores buffer position`() {
        var buffer = ArraySlice([UInt8]([0x1B]).map(Byte.init(bitPattern:)))
        let saved = buffer
        #expect(throws: ParseError.incompleteSequence) {
            try Parser.parse(&buffer)
        }
        #expect(buffer == saved)
    }

    @Test
    func `Alt+a`() throws {
        let event = try parse([0x1B, 0x61])
        #expect(event == .key(Key(code: .character("a"), modifiers: .alt)))
    }

    @Test
    func `Alt+Z`() throws {
        let event = try parse([0x1B, 0x5A])
        #expect(event == .key(Key(code: .character("Z"), modifiers: .alt)))
    }
}

@Suite("Parser — UTF-8")
struct UTF8Tests {

    @Test
    func `2-byte UTF-8 (é)`() throws {

        let event = try parse([0xC3, 0xA9])
        #expect(event == .key(Key(code: .character("\u{00E9}"))))
    }

    @Test
    func `3-byte UTF-8 (€)`() throws {

        let event = try parse([0xE2, 0x82, 0xAC])
        #expect(event == .key(Key(code: .character("\u{20AC}"))))
    }

    @Test
    func `4-byte UTF-8 (😀)`() throws {

        let event = try parse([0xF0, 0x9F, 0x98, 0x80])
        #expect(event == .key(Key(code: .character("\u{1F600}"))))
    }

    @Test
    func `Incomplete UTF-8 throws incompleteSequence`() {

        #expect(throws: ParseError.incompleteSequence) {
            try parse([0xC3])
        }
    }

    @Test
    func `Invalid continuation byte throws invalidUTF8`() {

        #expect(throws: ParseError.invalidUTF8) {
            try parse([0xC3, 0x41])
        }
    }

    @Test
    func `Incomplete UTF-8 restores buffer position`() {
        var buffer = ArraySlice([UInt8]([0xC3]).map(Byte.init(bitPattern:)))
        let saved = buffer
        #expect(throws: ParseError.incompleteSequence) {
            try Parser.parse(&buffer)
        }
        #expect(buffer == saved)
    }
}

@Suite("Parser — Sequential Events")
struct SequentialTests {

    @Test
    func `Parse multiple events from one buffer`() throws {

        var buffer = ArraySlice([UInt8]([0x61, 0x62]).map(Byte.init(bitPattern:)))
        let first = try Parser.parse(&buffer)
        let second = try Parser.parse(&buffer)
        #expect(first == .key(Key(code: .character("a"))))
        #expect(second == .key(Key(code: .character("b"))))
    }

    @Test
    func `Buffer is empty after consuming all bytes`() throws {
        var buffer = ArraySlice([UInt8]([0x61]).map(Byte.init(bitPattern:)))
        _ = try Parser.parse(&buffer)
        let empty = buffer.isEmpty
        #expect(empty)
    }
}

@Suite
struct `Byte parsing preserves the selected slice and its remaining input` {
    @Test(arguments: [
        ([UInt8]([0x00]), Event.key(Key(code: .character(" "), modifiers: .control))),
        ([UInt8]([0x1C]), Event.key(Key(code: .character("\\"), modifiers: .control))),
        ([UInt8]([0x7E]), Event.key(Key(code: .character("~")))),
        ([UInt8]([0xC2, 0x80]), Event.key(Key(code: .character("\u{0080}")))),
        ([UInt8]([0xF4, 0x8F, 0xBF, 0xBF]), Event.key(Key(code: .character("\u{10FFFF}")))),
        ([UInt8]([0x1B, 0x5B, 0x31, 0x3B, 0x35, 0x41]), Event.key(Key(code: .up, modifiers: .control))),
    ])
    func `Parsing consumes one event and leaves the following byte untouched`(
        payload: [UInt8],
        expected: Event
    ) throws {
        let bytes = ([0xAA] + payload + [0xFF]).map(Byte.init(bitPattern:))
        var input = bytes[1...]

        let event = try Parser.parse(&input)

        #expect(event == expected)
        #expect(input.startIndex == payload.count + 1)
        #expect(input.count == 1)
        #expect(input.first?.bitPattern == 0xFF)
    }

    @Test(arguments: [
        [UInt8]([0x1B]),
        [UInt8]([0x1B, 0x5B]),
        [UInt8]([0xC2]),
        [UInt8]([0xF4, 0x8F, 0xBF]),
    ])
    func `Incomplete sequences restore the original slice and byte values`(payload: [UInt8]) {
        let bytes = ([0xAA] + payload).map(Byte.init(bitPattern:))
        var input = bytes[1...]
        let saved = input

        #expect(throws: ParseError.incompleteSequence) {
            try Parser.parse(&input)
        }

        #expect(input == saved)
        #expect(input.startIndex == 1)
        #expect(input.map(\.bitPattern) == payload)
    }
}

#endif
