import Terminal
import Testing

extension Terminal.Stream.Write {
    @Suite
    struct Test {
        @Suite struct Unit {}
    }
}

extension Terminal.Stream.Write.Test.Unit {
    @Test
    func `write accessor preserves stream identity`() {
        let stream = Terminal.Stream.stdout
        let write = stream.write
        #expect(write.stream == .stdout)
    }

    @Test
    func `write accessor available for stderr`() {
        let stream = Terminal.Stream.stderr
        let write = stream.write
        #expect(write.stream == .stderr)
    }

    @Test
    func `write accessor available for stdin (FD only; semantics undefined)`() {

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
