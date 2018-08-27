
struct Token {
    let type: TokenType
    let lexeme: String
    let offset: Int
}


extension Token: Equatable {
    static func ==(lhs: Token, rhs: Token) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.lexeme == rhs.lexeme &&
            lhs.offset == rhs.offset
    }
}


enum TokenType {
    case leftparen, rightparen, comma
    case plus, minus, star, slash, modulo, caret, equal
    case plusequal, minusequal, starequal, slashequal, moduloequal, caretequal
    case identifier, integer, float
    case setkeyword
    case eof
}


let keywords = [
    "set": TokenType.setkeyword,
]