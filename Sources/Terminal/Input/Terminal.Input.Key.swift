#if Input
extension Terminal.Input {

    public struct Key: Sendable, Equatable {

        public var code: Code

        public var modifiers: Modifiers

        public var text: Swift.String?

        public var kind: Kind?

        public init(
            code: Code,
            modifiers: Modifiers = [],
            text: Swift.String? = nil,
            kind: Kind? = nil
        ) {
            self.code = code
            self.modifiers = modifiers
            self.text = text
            self.kind = kind
        }
    }
}
#endif
