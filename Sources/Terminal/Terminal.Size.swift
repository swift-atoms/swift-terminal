extension Terminal {

    public struct Size: Sendable, Hashable {

        public let rows: UInt16

        public let columns: UInt16

        public init(rows: UInt16, columns: UInt16) {
            self.rows = rows
            self.columns = columns
        }
    }
}
