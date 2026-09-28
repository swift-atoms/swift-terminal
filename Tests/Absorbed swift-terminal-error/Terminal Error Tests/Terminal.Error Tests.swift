#if Error
import Error
import Terminal
import Testing

@Suite
struct `Terminal diagnostics preserve their operation and cause` {

    @Test
    func `A terminal diagnostic preserves its typed kernel cause`() {
        let cause = Error(code: .posix(25))
        let failure = Terminal.Error(
            operation: .querySize,
            underlying: .kernel(cause)
        )

        #expect(failure.operation == .querySize)
        guard case .kernel(let storedCause) = failure.underlying else {
            Issue.record("Expected a kernel error")
            return
        }
        #expect(storedCause == cause)
        #expect(failure.description == "Terminal.querySize: posix(25)")
    }

    @Test
    func `A terminal diagnostic preserves its typed platform cause`() {
        let cause = Error(code: .win32(6))
        let failure = Terminal.Error(
            operation: .enableVT,
            underlying: .platform(cause)
        )

        #expect(failure.operation == .enableVT)
        guard case .platform(let storedCause) = failure.underlying else {
            Issue.record("Expected a platform error")
            return
        }
        #expect(storedCause == cause)
        #expect(failure.description == "Terminal.enableVT: win32(6)")
    }

    @Test(arguments: [
        (Terminal.Error.Operation.querySize, "Terminal.querySize: not supported on this platform"),
        (Terminal.Error.Operation.enterRaw, "Terminal.enterRaw: not supported on this platform"),
        (Terminal.Error.Operation.exitRaw, "Terminal.exitRaw: not supported on this platform"),
        (Terminal.Error.Operation.enableVT, "Terminal.enableVT: not supported on this platform"),
    ])
    func `Unsupported diagnostics describe each operation`(
        operation: Terminal.Error.Operation,
        expected: String
    ) {
        let failure = Terminal.Error(operation: operation, underlying: .unsupported)
        #expect(failure.description == expected)
    }
}


extension `Terminal diagnostics preserve their operation and cause` {
    @Test(
        arguments: [
            Error::Error.Code.posix(.min),
            .posix(.max),
            .win32(0),
            .win32(.max),
        ],
        [true, false]
    )
    func `Both provenance cases preserve every code width and diagnostic field`(
        code: Error::Error.Code,
        isKernel: Bool
    ) {
        let context = Error::Error.Context(
            operation: "ioctl",
            function: "query()",
            file: .init(id: "Probe/Terminal.swift"),
            line: .max
        )
        let cause = Error::Error(code: code, context: context)
        let underlying: Terminal.Error.Underlying = isKernel ? .kernel(cause) : .platform(cause)
        let failure = Terminal.Error(operation: .querySize, underlying: underlying)

        switch failure.underlying {
        case .kernel(let stored):
            #expect(isKernel)
            #expect(stored.code == code)
            #expect(stored.context == context)
        case .platform(let stored):
            #expect(!isKernel)
            #expect(stored.code == code)
            #expect(stored.context == context)
        case .unsupported:
            Issue.record("The typed diagnostic cause was lost")
        }
        #expect(failure.description == "Terminal.querySize: ioctl: \(code) at query() (Probe/Terminal.swift:4294967295)")
    }

    @Test
    func `Typed throws preserve the operation and provenance of the nested error`() {
        let cause = Error::Error(code: .posix(-25))
        let failure = Terminal.Error(operation: .exitRaw, underlying: .platform(cause))

        do throws(Terminal.Error) {
            try Self.fail(failure)
            Issue.record("Expected the typed terminal diagnostic")
        } catch {
            #expect(error.operation == .exitRaw)
            guard case .platform(let stored) = error.underlying else {
                Issue.record("The diagnostic provenance changed")
                return
            }
            #expect(stored == cause)
            #expect(error.description == "Terminal.exitRaw: posix(-25)")
        }
    }

    private static func fail(_ error: Terminal.Error) throws(Terminal.Error) {
        throw error
    }
}

#endif
