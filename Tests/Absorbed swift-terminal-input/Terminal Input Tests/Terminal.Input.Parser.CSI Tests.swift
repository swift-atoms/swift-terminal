#if Input
    import Terminal
    import Testing

    enum `Terminal.Input.Parser.CSI Tests` {}

    extension `Terminal.Input.Parser.CSI Tests` {
        @Suite
        struct `Parser — CSI Arrow Keys` {

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
    }

    extension `Terminal.Input.Parser.CSI Tests` {
        @Suite
        struct `Parser — CSI Modified Keys` {

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
    }

    extension `Terminal.Input.Parser.CSI Tests` {
        @Suite
        struct `Parser — CSI Navigation Keys` {

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
    }

    extension `Terminal.Input.Parser.CSI Tests` {
        @Suite
        struct `Parser — CSI Tilde Keys` {

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
    }

    extension `Terminal.Input.Parser.CSI Tests` {
        @Suite
        struct `Parser — CSI Function Keys` {

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
    }

    extension `Terminal.Input.Parser.CSI Tests` {
        @Suite
        struct `Parser — SS3 Function Keys` {

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
    }

    extension `Terminal.Input.Parser.CSI Tests` {
        @Suite
        struct `Parser — Bracketed Paste` {

            @Test
            func `Paste delivers the text between ESC [ 200 ~ and ESC [ 201 ~`() throws {
                var buffer = ArraySlice(
                    ([0x1B, 0x5B, 0x32, 0x30, 0x30, 0x7E] + Array("hé\u{1B}[A".utf8)
                        + [0x1B, 0x5B, 0x32, 0x30, 0x31, 0x7E, 0x61]).map(Byte.init(bitPattern:))
                )
                let event = try Parser.parse(&buffer)
                #expect(event == .paste("hé\u{1B}[A"))
                #expect(buffer.map(\.bitPattern) == [0x61])
            }

            @Test
            func `Empty paste: ESC [ 200 ~ ESC [ 201 ~`() throws {
                let event = try parse([0x1B, 0x5B, 0x32, 0x30, 0x30, 0x7E, 0x1B, 0x5B, 0x32, 0x30, 0x31, 0x7E])
                #expect(event == .paste(""))
            }

            @Test
            func `Paste without end marker is incomplete and restores position`() {
                var buffer = ArraySlice(
                    ([0x1B, 0x5B, 0x32, 0x30, 0x30, 0x7E, 0x68, 0x69, 0x1B, 0x5B, 0x32, 0x30])
                        .map(Byte.init(bitPattern:))
                )
                let saved = buffer
                #expect(throws: ParseError.incompleteSequence) {
                    try Parser.parse(&buffer)
                }
                #expect(buffer == saved)
            }

            @Test
            func `Lone paste end marker is unrecognized: ESC [ 201 ~`() {
                #expect(throws: ParseError.unrecognizedSequence) {
                    try parse([0x1B, 0x5B, 0x32, 0x30, 0x31, 0x7E])
                }
            }
        }
    }

    extension `Terminal.Input.Parser.CSI Tests` {
        @Suite
        struct `Parser — Incomplete Sequences` {

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
    }

#endif
