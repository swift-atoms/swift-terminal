import Terminal
import Testing

enum `Terminal.Stream.Write Tests` {}

extension `Terminal.Stream.Write Tests` {
    @Suite
    struct `Write accessors preserve stream identities across isolation boundaries` {
    }
}

extension `Terminal.Stream.Write Tests`.`Write accessors preserve stream identities across isolation boundaries` {
    @Suite struct `Write accessors retain standard stream identities and support task transfer` {}
}

extension `Terminal.Stream.Write Tests`.`Write accessors preserve stream identities across isolation boundaries`.`Write accessors retain standard stream identities and support task transfer` {
    @Test
    func `write accessor preserves stream identity`() {
        let stream = Terminal.Stream.stdout
        let write = stream.write
        #expect(write.stream == .stdout)
    }

    @Test
    func `The stderr write accessor preserves the stderr stream identity`() {
        let stream = Terminal.Stream.stderr
        let write = stream.write
        #expect(write.stream == .stderr)
    }

    @Test
    func `The stdin write accessor preserves the stdin stream identity`() {

        let stream = Terminal.Stream.stdin
        let write = stream.write
        #expect(write.stream == .stdin)
    }

    @Test
    func `Write is Sendable across isolation boundaries`() async {
        let write = Terminal.Stream.stdout.write
        await Task.detached {
            #expect(write.stream == .stdout)
        }.value
    }
}
