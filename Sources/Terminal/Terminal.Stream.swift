extension Terminal {

    public enum Stream: Int32, Sendable, Hashable, CaseIterable {

        case stdin = 0

        case stdout = 1

        case stderr = 2
    }
}
