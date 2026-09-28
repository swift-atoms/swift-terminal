#if Input
extension Terminal.Input.Key {

    public struct Modifiers: OptionSet, Sendable, Equatable, Hashable {

        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public static let shift = Self(rawValue: 1 << 0)

        public static let alt = Self(rawValue: 1 << 1)

        public static let control = Self(rawValue: 1 << 2)

        public static let `super` = Self(rawValue: 1 << 3)

        public static let hyper = Self(rawValue: 1 << 4)

        public static let meta = Self(rawValue: 1 << 5)

        public static let capsLock = Self(rawValue: 1 << 6)

        public static let numLock = Self(rawValue: 1 << 7)
    }
}
#endif
