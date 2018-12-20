// -----------------------------------------------------------------------------
// The parser takes an array of tokens and returns a parse tree of
// expression objects.
// -----------------------------------------------------------------------------

class Parser {

    let tokens: [Token]
    var current = 0

    init(_ tokens: [Token]) {
        self.tokens = tokens
    }

    func parse() throws -> Expr {
        let expr = try expression()
        if !isAtEnd() {
            let token = next()
            throw CalcLangError.unexpectedToken(
                offset: token.offset,
                lexeme: token.lexeme
            )
        }
        return expr
    }

    // ---------------------------------------------------------------------
    // Expression parsers.
    // ---------------------------------------------------------------------

    private func expression() throws -> Expr {
        return try assignment()
    }

    private func assignment() throws -> Expr {
        let expr = try addition()
        if match(
            .equal, .plusequal, .minusequal, .starequal,
            .slashequal, .moduloequal, .caretequal
        ) {
            let optoken = next()
            let rightexpr = try assignment()
            if let leftexpr = expr as? VariableExpr {
                return AssignExpr(leftexpr.name, optoken, rightexpr)
            } else {
                throw CalcLangError.illegalAssignment(
                    offset: optoken.offset,
                    lexeme: optoken.lexeme
                )
            }
        }
        return expr
    }

    private func addition() throws -> Expr {
        var expr = try multiplication()
        while match(.plus, .minus) {
            let optoken = next()
            let rightexpr = try multiplication()
            expr = BinaryExpr(expr, optoken, rightexpr)
        }
        return expr
    }

    private func multiplication() throws -> Expr {
        var expr = try power()
        while match(.star, .slash, .modulo) {
            let optoken = next()
            let rightexpr = try power()
            expr = BinaryExpr(expr, optoken, rightexpr)
        }
        return expr
    }

    private func power() throws -> Expr {
        var expr = try unary()
        while match(.caret) {
            let optoken = next()
            let rightexpr = try unary()
            expr = BinaryExpr(expr, optoken, rightexpr)
        }
        return expr
    }

    private func unary() throws -> Expr {
        if match(.plus, .minus) {
            let optoken = next()
            let rightexpr = try factorial()
            return UnaryExpr(optoken, rightexpr)
        }
        return try factorial()
    }

    private func factorial() throws -> Expr {
        var expr = try call()
        while match(.bang) {
            let optoken = next()
            expr = FactorialExpr(expr, optoken)
        }
        return expr
    }

    private func call() throws -> Expr {
        let expr = try primary()
        if let variable = expr as? VariableExpr {
            if match(.leftparen) {
                _ = next()
                var arguments = [Expr]()
                if !match(.rightparen) {
                    while true {
                        arguments.append(try expression())
                        if match(.comma) {
                            _ = next()
                        } else {
                            break
                        }
                    }
                }
                try consume(.rightparen, ")")
                return CallExpr(variable, arguments)
            }
        }
        return expr
    }

    private func primary() throws -> Expr {
        if match(.float) {
            let token = next()
            if let value = Double(token.lexeme) {
                return LiteralExpr(value)
            }
            throw CalcLangError.unparsableLiteral(
                offset: token.offset,
                lexeme: token.lexeme
            )
        }
        else if match(.dotfloat) {
            let token = next()
            if let value = Double("0" + token.lexeme) {
                return LiteralExpr(value)
            }
            throw CalcLangError.unparsableLiteral(
                offset: token.offset,
                lexeme: token.lexeme
            )
        } else if match(.integer) {
            let token = next()
            if token.lexeme.starts(with: "0b") {
                let literal = String(token.lexeme.dropFirst(2))
                if let value = Int64(literal, radix: 2) {
                    return LiteralExpr(Double(value))
                }
            } else if token.lexeme.starts(with: "0o") {
                let literal = String(token.lexeme.dropFirst(2))
                if let value = Int64(literal, radix: 8) {
                    return LiteralExpr(Double(value))
                }
            } else if token.lexeme.starts(with: "0d") {
                let literal = String(token.lexeme.dropFirst(2))
                if let value = Int64(literal, radix: 10) {
                    return LiteralExpr(Double(value))
                }
            } else if token.lexeme.starts(with: "0x") {
                let literal = String(token.lexeme.dropFirst(2))
                if let value = Int64(literal, radix: 16) {
                    return LiteralExpr(Double(value))
                }
            } else {
                if let value = Int64(token.lexeme) {
                    return LiteralExpr(Double(value))
                }
            }
            throw CalcLangError.unparsableLiteral(
                offset: token.offset,
                lexeme: token.lexeme
            )
        } else if match(.leftparen) {
            let _ = next()
            let expr = try expression()
            try consume(.rightparen, ")")
            return GroupingExpr(expr)
        } else if match(.identifier) {
            return VariableExpr(next())
        }
        let token = next()
        throw CalcLangError.expectExpression(
            offset: token.offset,
            lexeme: token.lexeme
        )
    }

    // ---------------------------------------------------------------------
    // Helpers.
    // ---------------------------------------------------------------------

    private func match(_ types: TokenType...) -> Bool {
        if isAtEnd() {
            return false
        }
        for type in types {
            if peek().type == type {
                return true
            }
        }
        return false
    }

    private func isAtEnd() -> Bool {
        return tokens[current].type == .eof
    }

    private func peek() -> Token {
        return tokens[current]
    }

    private func next() -> Token {
        if tokens[current].type == .eof {
            return tokens[current]
        } else {
            current += 1
            return tokens[current - 1]
        }
    }

    private func consume(_ type: TokenType, _ literal: String) throws {
        if match(type) {
            _ = next()
        } else {
            let token = next()
            throw CalcLangError.expectToken(
                offset: token.offset,
                lexeme: token.lexeme,
                expected: literal
            )
        }
    }
}
