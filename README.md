# Terminal

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Typed terminal-control vocabulary for Swift — standard streams, window size, mode accessors, and named ANSI/DEC escape sequences for the alternate screen, bracketed paste, mouse tracking, and the Kitty keyboard protocol, with zero platform dependencies.

---

## Quick Start

The `Terminal.Mode` sequences are ready-to-write `String` constants — named, typed DEC/ANSI escapes instead of hand-written `"\u{1B}[?1049h"` magic strings scattered through your render loop:

```swift
import Terminal

// Drive a full-screen, mouse-aware session, restoring every mode on exit.
func withFullScreenMouseSession(_ body: () -> Void) {
    print(Terminal.Mode.Screen.enable, terminator: "")     // alternate screen buffer (1049)
    print(Terminal.Mode.Mouse.Any.enable, terminator: "")  // motion + button events (1003)
    print(Terminal.Mode.Mouse.SGR.enable, terminator: "")  // SGR extended coordinates (1006)
    defer {
        print(Terminal.Mode.Mouse.SGR.disable, terminator: "")
        print(Terminal.Mode.Mouse.Any.disable, terminator: "")
        print(Terminal.Mode.Screen.disable, terminator: "")
    }
    body()
}
```

Each escape sequence is paired (`enable` / `disable`) so cleanup is symmetric and a missing reset becomes a visible omission rather than a stray byte string. `Screen`, `Paste`, `Keyboard`, and the four `Mouse` tracking modes (`Normal`, `Button`, `Any`, `SGR`) cover the common interactive-terminal toggles.

Alongside the sequences, `Terminal` is a typed vocabulary for the rest of the terminal surface: `Terminal.Stream` (`stdin` / `stdout` / `stderr`, each carrying its file descriptor) exposes `.read`, `.write`, `.mode`, and `.interactive` accessors; `Terminal.Size` is a `rows × columns` value. The *runtime* operations behind those accessors — querying the window size, entering raw mode, testing interactivity — are added by downstream platform packages (`swift-iso-9945` for POSIX, `swift-windows-primitives` for Windows). This package holds the platform-independent types and sequences they operate on, so the same vocabulary travels unchanged across platforms.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-terminal.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Terminal", package: "swift-terminal"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Two library products. Depends only on the canonical `Error` package.

| Product | Target | Purpose |
|---------|--------|---------|
| `Terminal` | `Sources/Terminal/` | The `Terminal` namespace: `Stream` (stdin/stdout/stderr) with `.read` / `.write` / `.mode` / `.interactive` accessors; `Size` (rows × columns); and the `Mode` escape-sequence constants — `Screen`, `Paste`, `Keyboard`, and `Mouse` (`Normal` / `Button` / `Any` / `SGR`). |
| `Terminal Error` | `Sources/Terminal Error/` | `Terminal.Error` — an `Operation` (which call failed) paired with an `Underlying` cause (`kernel` / `platform` / `unsupported`), wrapping the canonical `Error` carrier. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |
| Swift Embedded | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
