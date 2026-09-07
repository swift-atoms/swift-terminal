extension Terminal.Error: Swift.CustomStringConvertible {

    public var description: Swift.String {
        switch underlying {
        case .kernel(let error):
            return "Terminal.\(operation): \(error)"

        case .platform(let error):
            return "Terminal.\(operation): \(error)"

        case .unsupported:
            return "Terminal.\(operation): not supported on this platform"
        }
    }
}
