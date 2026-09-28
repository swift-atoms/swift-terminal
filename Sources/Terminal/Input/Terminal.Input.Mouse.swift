#if Input
extension Terminal.Input {

    public struct Mouse: Sendable, Equatable {

        public var kind: Kind

        public var column: UInt16

        public var row: UInt16

        public var modifiers: Key.Modifiers

        public init(
            kind: Kind,
            column: UInt16,
            row: UInt16,
            modifiers: Key.Modifiers = []
        ) {
            self.kind = kind
            self.column = column
            self.row = row
            self.modifiers = modifiers
        }
    }
}
#endif
