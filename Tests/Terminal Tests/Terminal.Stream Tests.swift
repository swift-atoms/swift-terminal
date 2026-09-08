import Testing

@testable import Terminal

@Suite struct `Terminal streams preserve descriptor values and enumeration` {
    @Suite struct `Standard terminal streams retain their descriptor values and complete enumeration` {}
    @Suite struct `No terminal stream boundary cases are defined` {}
    @Suite struct `No terminal stream integration cases are defined` {}
}

extension `Terminal streams preserve descriptor values and enumeration`.`Standard terminal streams retain their descriptor values and complete enumeration` {
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

@Suite struct `Terminal sizes preserve dimensions and compare stored values` {
    @Suite struct `Terminal size construction retains dimensions and equality distinguishes sizes` {}
    @Suite struct `No terminal size boundary cases are defined` {}
    @Suite struct `No terminal size integration cases are defined` {}
}

extension `Terminal sizes preserve dimensions and compare stored values`.`Terminal size construction retains dimensions and equality distinguishes sizes` {
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
