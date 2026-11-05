# swift-terminal

Use this package when you need the vocabulary of a terminal without its I/O: decoding the bytes a terminal sends into key, mouse and paste events with `Terminal.Input.Parser`, the escape sequences that switch terminal input modes under `Terminal.Mode`, and the standard streams as `Terminal.Stream`. It performs no system calls; `Terminal.Stream.Read`, `Terminal.Stream.Write`, `Terminal.Stream.Interactive` and `Terminal.Mode.Raw` only name a stream for operations that other packages add. To run an input loop with raw mode entered and restored for you, use swift-console instead, which builds on this package.

## Laws

- `Terminal.Input.Parser.parse` consumes exactly one event from the front of the slice and leaves the following bytes untouched, so repeated calls drain a buffer event by event.
- On `incompleteSequence` the slice is restored to where it was, so the caller can append more bytes and parse again. On every other failure the bytes read so far stay consumed.
- A lone ESC byte is `incompleteSequence`, never the Escape key: telling Escape apart from the start of a sequence (for example by a read timeout) is the caller's job. Only the Kitty form `ESC [ 27 u` yields `.escape`. ESC followed by a printable byte is that character with `.alt`.
- Bracketed paste is not assembled: `ESC [ 200 ~` yields `.paste("")`, the pasted bytes then parse as ordinary key events, and the end marker ESC [ 201 ~ fails with `unrecognizedSequence`.
- The parser never produces `.resize`; size changes come from whoever watches the terminal.
- Control bytes: CR is `.enter` (so LF is Ctrl+J), HT is `.tab`, BS and DEL are both `.backspace`, NUL is Ctrl+Space, the other bytes from 0x01 to 0x1A are Ctrl plus the lowercase letter, 0x1C to 0x1F are Ctrl plus backslash, ], ^ and _.
- In CSI sequences the modifier parameter is 1 plus the bit set of `Terminal.Input.Key.Modifiers`; a parameter of 0 or 1 means no modifiers. Parameters after the third are ignored.
- Kitty keys (CSI sequences ending in u): `kind` is `nil` unless the sequence carries an event-type subparameter; `text` is set only for code points from 0x20 below 0xE000, excluding 0x7F; code points 57344 to 57503 become `.kitty`; 9, 13, 27 and 127 become `.tab`, `.enter`, `.escape` and `.backspace` without text.
- Only SGR mouse reports (`ESC [ <`) are decoded, so enable `Terminal.Mode.Mouse.SGR` together with one of `Terminal.Mode.Mouse.Normal`, `Terminal.Mode.Mouse.Button` or `Terminal.Mode.Mouse.Any`. Coordinates are passed through as the terminal reports them (1-based), truncated to `UInt16`, and only shift, alt and control are reported as modifiers.
- Every `enable` sequence has a matching `disable` that differs only in its final byte, except `Terminal.Mode.Keyboard`: its `enable` pushes Kitty keyboard flags 1 onto the terminal's mode stack and its `disable` pops one entry, so the two must be balanced.
