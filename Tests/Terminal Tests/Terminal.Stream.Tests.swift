import Testing

@testable import Terminal_Primitive

@Suite struct `Terminal.Stream Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Terminal.Stream Tests`.Unit {
    @Test
    func `Stream raw values are correct`() {
        #expect(Terminal.Stream.stdin.rawValue == 0)
        #expect(Terminal.Stream.stdout.rawValue == 1)
        #expect(Terminal.Stream.stderr.rawValue == 2)
    }

    @Test
    func `All streams can be iterated`() {
        let streams = Terminal.Stream.allCases
        #expect(streams.count == 3)
        #expect(streams.contains(.stdin))
        #expect(streams.contains(.stdout))
        #expect(streams.contains(.stderr))
    }
}

@Suite struct `Terminal.Size Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Terminal.Size Tests`.Unit {
    @Test
    func `Size can be created`() {
        let size = Terminal.Size(rows: 24, columns: 80)
        #expect(size.rows == 24)
        #expect(size.columns == 80)
    }

    @Test
    func `Size is hashable`() {
        let size1 = Terminal.Size(rows: 24, columns: 80)
        let size2 = Terminal.Size(rows: 24, columns: 80)
        let size3 = Terminal.Size(rows: 25, columns: 80)
        #expect(size1 == size2)
        #expect(size1 != size3)
    }
}
