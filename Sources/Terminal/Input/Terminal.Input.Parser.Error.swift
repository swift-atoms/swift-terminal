#if Input
import ASCII
import Byte
import Cursor

extension Terminal.Input.Parser {

    public enum Error: Swift.Error, Sendable, Equatable {

        case emptyInput

        case incompleteSequence

        case unrecognizedSequence

        case invalidUTF8
    }
}
#endif
