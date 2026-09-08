import Terminal
import Testing

@Suite
struct `Unsupported terminal errors identify their operations` {
    @Test
    func `unsupported errors identify their operation`() {
        let error = Terminal.Error(operation: .querySize, underlying: .unsupported)
        #expect(error.description == "Terminal.querySize: not supported on this platform")
    }
}
