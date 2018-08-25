import XCTest
@testable import CalcLang

final class ScannerTests: XCTestCase {

    func testEmptyString() {
        var scanner = Scanner(source: "")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .eof, lexeme: "", offset: 0),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testSingleCharacterString() {
        var scanner = Scanner(source: "=")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .equal, lexeme: "=", offset: 0),
            Token(type: .eof, lexeme: "", offset: 1),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testDoubleCharacterString() {
        var scanner = Scanner(source: "()")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .leftparen, lexeme: "(", offset: 0),
            Token(type: .rightparen, lexeme: ")", offset: 1),
            Token(type: .eof, lexeme: "", offset: 2),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testPlusMinuString() {
        var scanner = Scanner(source: "+-")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .plus, lexeme: "+", offset: 0),
            Token(type: .minus, lexeme: "-", offset: 1),
            Token(type: .eof, lexeme: "", offset: 2),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testPlusEqualsString() {
        var scanner = Scanner(source: "+=")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .plusequal, lexeme: "+=", offset: 0),
            Token(type: .eof, lexeme: "", offset: 2),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testAllWhitespace() {
        var scanner = Scanner(source: " \t")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .eof, lexeme: "", offset: 2),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testPartialWhitespace() {
        var scanner = Scanner(source: " = ")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .equal, lexeme: "=", offset: 1),
            Token(type: .eof, lexeme: "", offset: 3),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testInteger() {
        var scanner = Scanner(source: "123")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .integer, lexeme: "123", offset: 0),
            Token(type: .eof, lexeme: "", offset: 3),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testFloat() {
        var scanner = Scanner(source: "123.456")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .float, lexeme: "123.456", offset: 0),
            Token(type: .eof, lexeme: "", offset: 7),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testKeyword() {
        var scanner = Scanner(source: "set")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .setkeyword, lexeme: "set", offset: 0),
            Token(type: .eof, lexeme: "", offset: 3),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testIdentifier() {
        var scanner = Scanner(source: "foo")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .identifier, lexeme: "foo", offset: 0),
            Token(type: .eof, lexeme: "", offset: 3),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testIntegerExpression() {
        var scanner = Scanner(source: "1 + 2 * 33")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .integer, lexeme: "1", offset: 0),
            Token(type: .plus, lexeme: "+", offset: 2),
            Token(type: .integer, lexeme: "2", offset: 4),
            Token(type: .star, lexeme: "*", offset: 6),
            Token(type: .integer, lexeme: "33", offset: 8),
            Token(type: .eof, lexeme: "", offset: 10),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testFloatingPointExpression() {
        var scanner = Scanner(source: "1.2 + 22.34 * 33.456")
        let tokens = try! scanner.scan()
        let expect = [
            Token(type: .float, lexeme: "1.2", offset: 0),
            Token(type: .plus, lexeme: "+", offset: 4),
            Token(type: .float, lexeme: "22.34", offset: 6),
            Token(type: .star, lexeme: "*", offset: 12),
            Token(type: .float, lexeme: "33.456", offset: 14),
            Token(type: .eof, lexeme: "", offset: 20),
        ]
        XCTAssertEqual(tokens, expect)
    }

    func testSingleInvalidCharacter() {
        var scanner = Scanner(source: "&")
        XCTAssertThrowsError(try scanner.scan())
    }

}