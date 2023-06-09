import XCTest
@testable import CalcLang

class InterpreterTests: XCTestCase {

    // ---------------------------------------------------------------------
    // Literals.
    // ---------------------------------------------------------------------

    func testIntegerLiteral() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "99")
        XCTAssertEqual(output, "99")
    }

    func testFloatLiteral() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "99.99")
        XCTAssertEqual(output, "99.99")
    }

    func testDotFloatLiteral() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: ".99")
        XCTAssertEqual(output, "0.99")
    }

    func testIntegerLiteralWithTrailingZeros() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "100")
        XCTAssertEqual(output, "100")
    }

    func testFloatLiteralWithTrailingZeros() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "99.900")
        XCTAssertEqual(output, "99.9")
    }

    func testFloatLiteralWithAllTrailingZeros() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "100.00")
        XCTAssertEqual(output, "100")
    }

    func testBinaryLiteral() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "0b0101")
        XCTAssertEqual(output, "5")
    }

    func testOctalLiteral() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "0o0101")
        XCTAssertEqual(output, "65")
    }

    func testDecimalLiteral() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "0d0101")
        XCTAssertEqual(output, "101")
    }

    func testHexLiteral() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "0x0101")
        XCTAssertEqual(output, "257")
    }

    func testExpLiteralNoDecimal() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "123e4")
        XCTAssertEqual(output, "1230000")
    }

    func testExpLiteralWithDecimal() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "1.23e4")
        XCTAssertEqual(output, "12300")
    }

    func testExpLiteralNegativeIndex() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "1.23e-4")
        XCTAssertEqual(output, "0.000123")
    }

    // ---------------------------------------------------------------------
    // Literals with underscores.
    // ---------------------------------------------------------------------

    func testIntegerLiteralWithUnderscores() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "123_456")
        XCTAssertEqual(output, "123456")
    }

    func testFloatLiteralWithUnderscores() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "123_456.123_456")
        XCTAssertEqual(output, "123456.123456")
    }

    func testDotFloatLiteralWithUnderscores() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: ".123_456")
        XCTAssertEqual(output, "0.123456")
    }

    func testBinaryLiteralWithUnderscores() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "0b01_01")
        XCTAssertEqual(output, "5")
    }

    func testOctalLiteralWithUnderscores() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "0o01_01")
        XCTAssertEqual(output, "65")
    }

    func testDecimalLiteralWithUnderscores() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "0d01_01")
        XCTAssertEqual(output, "101")
    }

    func testHexLiteralWithUnderscores() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "0x01_01")
        XCTAssertEqual(output, "257")
    }

    // ---------------------------------------------------------------------
    // Simple expressions.
    // ---------------------------------------------------------------------

    func testBinaryExpr() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "1 + 2")
        XCTAssertEqual(output, "3")
    }

    func testBinaryExprWithUnaryOperands() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "+1 + -2")
        XCTAssertEqual(output, "-1")
    }

    func testAdditionMultiplicationPrecedence() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "1 + 2 * 3")
        XCTAssertEqual(output, "7")
    }

    func testMultiplicationAdditionPrecedence() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "1 * 2 + 3")
        XCTAssertEqual(output, "5")
    }

    func testGrouping() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "(1 + 2) * 3")
        XCTAssertEqual(output, "9")
    }

    func testZeroOutput() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "1 - 1")
        XCTAssertEqual(output, "0")
    }

    func testNegativeOutput() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "1 - 2")
        XCTAssertEqual(output, "-1")
    }

    func testRoundedOutputVeryCloseToZero() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "0.1 + 0.1 + 0.1 - 0.3")
        XCTAssertEqual(output, "0")
    }

    func testDivByZeroError() {
        let interpreter = Interpreter()
        XCTAssertThrowsError(
            try interpreter.eval(source: "1 / 0")) { error in
                guard case CalcLangError.runtimeError = error else {
                    return XCTFail()
                }
            }
    }

    func testAddition() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "1.50 + 9")
        XCTAssertEqual(output, "10.5")
    }

    func testSubtraction() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "1.50 - 9")
        XCTAssertEqual(output, "-7.5")
    }

    func testMultiplication() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "1.50 * 2")
        XCTAssertEqual(output, "3")
    }

    func testDivision() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "3 / 2")
        XCTAssertEqual(output, "1.5")
    }

    func testIntegerModulo() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "3 % 2")
        XCTAssertEqual(output, "1")
    }

    func testFloatModulo() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "5 % 1.5")
        XCTAssertEqual(output, "0.5")
    }

    func testIntegerPower() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "2 ^ 3")
        XCTAssertEqual(output, "8")
    }

    func testMultiplicationPowerPrecedence() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "4 * 2 ^ 3")
        XCTAssertEqual(output, "32")
    }

    func testPowerMultiplicationPrecedence() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "2 ^ 3 * 4")
        XCTAssertEqual(output, "32")
    }

    func testFractionalPower() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "9 ^ 0.5")
        XCTAssertEqual(output, "3")
    }

    func testFloatPower() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "9 ^ 1.5")
        XCTAssertEqual(output, "27")
    }

    func testFactorialOperator() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "5!")
        XCTAssertEqual(output, "120")
    }

    // ---------------------------------------------------------------------
    // Variables, constants, and assignment.
    // ---------------------------------------------------------------------

    func testPiConstant() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "pi")
        XCTAssertEqual(output, "3.141592654")
    }

    func testEulerConstant() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "e")
        XCTAssertEqual(output, "2.718281828")
    }

    func testUndefinedVariableError() {
        let interpreter = Interpreter()
        XCTAssertThrowsError(
            try interpreter.eval(source: "foo")) { error in
                guard case CalcLangError.runtimeError = error else {
                    return XCTFail()
                }
            }
    }

    func testAssignment() {
        let interpreter = Interpreter()
        var output = try! interpreter.eval(source: "foo = 101 + 1")
        XCTAssertEqual(output, "102")
        output = try! interpreter.eval(source: "foo")
        XCTAssertEqual(output, "102")
    }

    func testPlusEqualsAssignment() {
        let interpreter = Interpreter()
        _ = try! interpreter.eval(source: "foo = 1")
        _ = try! interpreter.eval(source: "foo += 1")
        let output = try! interpreter.eval(source: "foo")
        XCTAssertEqual(output, "2")
    }

    func testMinusEqualsAssignment() {
        let interpreter = Interpreter()
        _ = try! interpreter.eval(source: "foo = 1")
        _ = try! interpreter.eval(source: "foo -= 1")
        let output = try! interpreter.eval(source: "foo")
        XCTAssertEqual(output, "0")
    }

    func testStarEqualsAssignment() {
        let interpreter = Interpreter()
        _ = try! interpreter.eval(source: "foo = 2")
        _ = try! interpreter.eval(source: "foo *= 3")
        let output = try! interpreter.eval(source: "foo")
        XCTAssertEqual(output, "6")
    }

    func testSlashEqualsAssignment() {
        let interpreter = Interpreter()
        _ = try! interpreter.eval(source: "foo = 5")
        _ = try! interpreter.eval(source: "foo /= 2")
        let output = try! interpreter.eval(source: "foo")
        XCTAssertEqual(output, "2.5")
    }

    func testModuloEqualsAssignment() {
        let interpreter = Interpreter()
        _ = try! interpreter.eval(source: "foo = 10")
        _ = try! interpreter.eval(source: "foo %= 3")
        let output = try! interpreter.eval(source: "foo")
        XCTAssertEqual(output, "1")
    }

    func testCaretEqualsAssignment() {
        let interpreter = Interpreter()
        _ = try! interpreter.eval(source: "foo = 2")
        _ = try! interpreter.eval(source: "foo ^= 3")
        let output = try! interpreter.eval(source: "foo")
        XCTAssertEqual(output, "8")
    }

    // ---------------------------------------------------------------------
    // Trig functions.
    // ---------------------------------------------------------------------

    func testDegFunc() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "deg(pi)")
        XCTAssertEqual(output, "180")
    }

    func testRadFunc() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "rad(180)")
        XCTAssertEqual(output, "3.141592654")
    }

    func testDegFuncArityErrorWithNoArgs() {
        let interpreter = Interpreter()
        XCTAssertThrowsError(
            try interpreter.eval(source: "deg()")) { error in
                guard case CalcLangError.runtimeError = error else {
                    return XCTFail()
                }
            }
    }

    func testDegFuncArityErrorWithTwoArgs() {
        let interpreter = Interpreter()
        XCTAssertThrowsError(
            try interpreter.eval(source: "deg(1, 2)")) { error in
                guard case CalcLangError.runtimeError = error else {
                    return XCTFail()
                }
            }
    }

    func testCos_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cos(0)")
        XCTAssertEqual(output, "1")
    }

    func testCos_90() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cos(pi/2)")
        XCTAssertEqual(output, "0")
    }

    func testCos_180() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cos(pi)")
        XCTAssertEqual(output, "-1")
    }

    func testCos_270() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cos(3 * pi / 2)")
        XCTAssertEqual(output, "0")
    }

    func testCos_360() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cos(2 * pi)")
        XCTAssertEqual(output, "1")
    }

    func testSin_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sin(0)")
        XCTAssertEqual(output, "0")
    }

    func testSin_90() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sin(pi/2)")
        XCTAssertEqual(output, "1")
    }

    func testSin_180() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sin(pi)")
        XCTAssertEqual(output, "0")
    }

    func testSin_270() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sin(3 * pi / 2)")
        XCTAssertEqual(output, "-1")
    }

    func testSin_360() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sin(2 * pi)")
        XCTAssertEqual(output, "0")
    }

    func testTan_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "tan(0)")
        XCTAssertEqual(output, "0")
    }

    func testTan_45() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "tan(pi/4)")
        XCTAssertEqual(output, "1")
    }

    func testTan_135() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "tan(3 * pi / 4)")
        XCTAssertEqual(output, "-1")
    }

    func testTan_180() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "tan(pi)")
        XCTAssertEqual(output, "0")
    }

    func testCosd_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cosd(0)")
        XCTAssertEqual(output, "1")
    }

    func testCosd_90() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cosd(90)")
        XCTAssertEqual(output, "0")
    }

    func testCosd_180() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cosd(180)")
        XCTAssertEqual(output, "-1")
    }

    func testCosd_270() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cosd(270)")
        XCTAssertEqual(output, "0")
    }

    func testCosd_360() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cosd(360)")
        XCTAssertEqual(output, "1")
    }

    func testSind_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sind(0)")
        XCTAssertEqual(output, "0")
    }

    func testSind_90() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sind(90)")
        XCTAssertEqual(output, "1")
    }

    func testSind_180() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sind(180)")
        XCTAssertEqual(output, "0")
    }

    func testSind_270() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sind(270)")
        XCTAssertEqual(output, "-1")
    }

    func testSind_360() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sind(360)")
        XCTAssertEqual(output, "0")
    }

    func testTand_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "tand(0)")
        XCTAssertEqual(output, "0")
    }

    func testTand_45() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "tand(45)")
        XCTAssertEqual(output, "1")
    }

    func testTand_135() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "tand(135)")
        XCTAssertEqual(output, "-1")
    }

    func testTand_180() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "tand(180)")
        XCTAssertEqual(output, "0")
    }

    func testAcos_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "acos(0)")
        XCTAssertEqual(output, "1.570796327")
    }

    func testAcos_1() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "acos(1)")
        XCTAssertEqual(output, "0")
    }

    func testAcos_Minus1() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "acos(-1)")
        XCTAssertEqual(output, "3.141592654")
    }

    func testAsin_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "asin(0)")
        XCTAssertEqual(output, "0")
    }

    func testAsin_1() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "asin(1)")
        XCTAssertEqual(output, "1.570796327")
    }

    func testAsin_Minus1() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "asin(-1)")
        XCTAssertEqual(output, "-1.570796327")
    }

    func testAtan_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "atan(0)")
        XCTAssertEqual(output, "0")
    }

    func testAtan_1() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "atan(1)")
        XCTAssertEqual(output, "0.785398163")
    }

    func testAcosd_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "acosd(0)")
        XCTAssertEqual(output, "90")
    }

    func testAcosd_1() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "acosd(1)")
        XCTAssertEqual(output, "0")
    }

    func testAsind_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "asind(0)")
        XCTAssertEqual(output, "0")
    }

    func testAsind_1() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "asind(1)")
        XCTAssertEqual(output, "90")
    }

    func testAtand_0() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "atand(0)")
        XCTAssertEqual(output, "0")
    }

    func testAtand_1() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "atand(1)")
        XCTAssertEqual(output, "45")
    }

    // ---------------------------------------------------------------------
    // Roots.
    // ---------------------------------------------------------------------

    func testRootTwoOfFour() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "root(2,4)")
        XCTAssertEqual(output, "2")
    }

    func testRootTwoOfTwo() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "root(2,2)")
        XCTAssertEqual(output, "1.414213562")
    }

    func testRootThreeOfEight() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "root(3,8)")
        XCTAssertEqual(output, "2")
    }

    func testRootThreeOfNine() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "root(3,9)")
        XCTAssertEqual(output, "2.080083823")
    }

    func testSqrtOfFour() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sqrt(4)")
        XCTAssertEqual(output, "2")
    }

    func testSqrtOfTwo() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "sqrt(2)")
        XCTAssertEqual(output, "1.414213562")
    }

    func testCbrtOfEight() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cbrt(8)")
        XCTAssertEqual(output, "2")
    }

    func testCbrtOfNine() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "cbrt(9)")
        XCTAssertEqual(output, "2.080083823")
    }

    // ---------------------------------------------------------------------
    // Logs.
    // ---------------------------------------------------------------------

    func testLogTwoOfEight() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "log(2,8)")
        XCTAssertEqual(output, "3")
    }

    func testLogTwoOfNine() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "log(2,9)")
        XCTAssertEqual(output, "3.169925001")
    }

    func testLogTenOfOneHundred() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "log(10,100)")
        XCTAssertEqual(output, "2")
    }

    func testLogTenOfOneHundredAndOne() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "log(10,101)")
        XCTAssertEqual(output, "2.004321374")
    }

    func testLogEOfE() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "log(e,e)")
        XCTAssertEqual(output, "1")
    }

    func testLogEOfTen() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "log(e,10)")
        XCTAssertEqual(output, "2.302585093")
    }

    func testLog2OfEight() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "log2(8)")
        XCTAssertEqual(output, "3")
    }

    func testLog2OfNine() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "log2(9)")
        XCTAssertEqual(output, "3.169925001")
    }

    func testLog10OfOneHundred() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "log10(100)")
        XCTAssertEqual(output, "2")
    }

    func testLog10OfOneHundredAndOne() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "log10(101)")
        XCTAssertEqual(output, "2.004321374")
    }

    func testLnOfE() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "ln(e)")
        XCTAssertEqual(output, "1")
    }

    func testLnOfTen() {
        let interpreter = Interpreter()
        let output = try! interpreter.eval(source: "ln(10)")
        XCTAssertEqual(output, "2.302585093")
    }

    // ---------------------------------------------------------------------
    // Formatting.
    // ---------------------------------------------------------------------

    func testPrecision() {
        let interpreter = Interpreter()
        interpreter.precision = 2
        var output = try! interpreter.eval(source: "99.12345")
        XCTAssertEqual(output, "99.12")

        interpreter.precision = 3
        output = try! interpreter.eval(source: "99.12345")
        XCTAssertEqual(output, "99.123")

        interpreter.precision = 4
        output = try! interpreter.eval(source: "99.12345")
        XCTAssertEqual(output, "99.1235")
    }

    func testSeparators() {
        let interpreter = Interpreter()
        interpreter.kiloSeparator = ","
        interpreter.milliSeparator = " "
        interpreter.decimalSeparator = ":"
        let output = try! interpreter.eval(source: "123456.123456")
        XCTAssertEqual(output, "123,456:123 456")
    }
}
