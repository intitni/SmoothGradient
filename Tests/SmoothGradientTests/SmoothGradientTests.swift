import XCTest
@testable import SmoothGradient

final class SmoothGradientTests: XCTestCase {
    func testInterpolateValues() throws {
        XCTAssertEqual(
            interpolate(from: 0, to: 100, count: 0),
            [0, 100]
        )

        XCTAssertEqual(
            interpolate(from: 0, to: 100, count: 1),
            [0, 50, 100]
        )

        XCTAssertEqual(
            interpolate(from: 0, to: 100, count: 3),
            [0, 25, 50, 75, 100]
        )

        XCTAssertEqual(
            interpolate(from: 100, to: 0, count: 0),
            [100, 0]
        )

        XCTAssertEqual(
            interpolate(from: 100, to: 0, count: 1),
            [100, 50, 0]
        )

        XCTAssertEqual(
            interpolate(from: 100, to: 0, count: 3),
            [100, 75, 50, 25, 0]
        )
    }

    func testInterpolateCircularValues() throws {
        XCTAssertEqual(
            interpolateCircular(from: 0, to: 90, count: 0),
            [0, 90]
        )

        XCTAssertEqual(
            interpolateCircular(from: 0, to: 90, count: 1),
            [0, 45, 90]
        )

        XCTAssertEqual(
            interpolateCircular(from: 0, to: 270, count: 1),
            [0, 315, 270]
        )

        XCTAssertEqual(
            interpolateCircular(from: 0, to: 180, count: 1),
            [0, 90, 180]
        )

        XCTAssertEqual(
            interpolateCircular(from: 90, to: 0, count: 1),
            [90, 45, 0]
        )

        XCTAssertEqual(
            interpolateCircular(from: 270, to: 0, count: 1),
            [270, 315, 0]
        )
    }

    func testRGBtoHCL() throws {
        XCTAssertEqual(
            RGBColor(r: 0, g: 114 / 255, b: 214 / 255, alpha: 1).toLCH(),
            LCHColor(l: 48.12, c: 59.77, h: 281.16, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 135 / 255, g: 173 / 255, b: 140 / 255, alpha: 0.5).toLCH(),
            LCHColor(l: 67.22, c: 23.37, h: 146.77, alpha: 0.5)
        )

        XCTAssertEqual(
            RGBColor(r: 1, g: 173 / 255, b: 0, alpha: 1).toLCH(),
            LCHColor(l: 76.76, c: 82.56, h: 76.15, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 1, g: 0, b: 0, alpha: 1).toLCH(),
            LCHColor(l: 53.23, c: 104.57, h: 40.00, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 0, g: 1, b: 0, alpha: 1).toLCH(),
            LCHColor(l: 87.73, c: 119.77, h: 136.01, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 0, g: 0, b: 1, alpha: 1).toLCH(),
            LCHColor(l: 32.30, c: 133.81, h: 306.28, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 1, g: 1, b: 1, alpha: 1).toLCH(),
            LCHColor(l: 100, c: 0.011662039483869973, h: 158.19, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 0, g: 0, b: 0, alpha: 1).toLCH(),
            LCHColor(l: 0, c: 0, h: 0, alpha: 1)
        )
    }

    func testHCLtoRGB() throws {
        XCTAssertEqual(
            LCHColor(l: 48.12, c: 59.77, h: 281.16, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 114 / 255, b: 214 / 255, alpha: 1)
        )

        XCTAssertEqual(
            LCHColor(l: 48.12, c: 59.77, h: 281.16, alpha: 0.5).toRGB(),
            RGBColor(r: 0, g: 114 / 255, b: 214 / 255, alpha: 0.5)
        )

        XCTAssertEqual(
            LCHColor(l: 76.76, c: 82.56, h: 76.15, alpha: 1).toRGB(),
            RGBColor(r: 1, g: 173 / 255, b: 0, alpha: 1)
        )

        XCTAssertEqual(
            LCHColor(l: 53.23, c: 104.57, h: 40.00, alpha: 1).toRGB(),
            RGBColor(r: 1, g: 0, b: 0, alpha: 1)
        )

        XCTAssertEqual(
            LCHColor(l: 87.73, c: 119.77, h: 136.01, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 1, b: 0, alpha: 1)
        )

        XCTAssertEqual(
            LCHColor(l: 32.30, c: 133.81, h: 306.28, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 0, b: 1, alpha: 1)
        )

        XCTAssertEqual(
            LCHColor(l: 100, c: 0.011662039483869973, h: 158.19, alpha: 1).toRGB(),
            RGBColor(r: 1, g: 1, b: 1, alpha: 1)
        )

        XCTAssertEqual(
            LCHColor(l: 0, c: 0, h: 0, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 0, b: 0, alpha: 1)
        )
    }

    func testRGBtoHSL() throws {
        XCTAssertEqual(
            RGBColor(r: 0, g: 114 / 255, b: 214 / 255, alpha: 1).toHSL(),
            HSLColor(h: 208, s: 100, l: 42, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 135 / 255, g: 173 / 255, b: 140 / 255, alpha: 0.5).toHSL(),
            HSLColor(h: 128, s: 19, l: 60, alpha: 0.5)
        )

        XCTAssertEqual(
            RGBColor(r: 1, g: 173 / 255, b: 0, alpha: 1).toHSL(),
            HSLColor(h: 41, s: 100, l: 50, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 1, g: 0, b: 0, alpha: 1).toHSL(),
            HSLColor(h: 0, s: 100, l: 50, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 0, g: 1, b: 0, alpha: 1).toHSL(),
            HSLColor(h: 120, s: 100, l: 50, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 0, g: 0, b: 1, alpha: 1).toHSL(),
            HSLColor(h: 240, s: 100, l: 50, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 1, g: 1, b: 1, alpha: 1).toHSL(),
            HSLColor(h: 0, s: 0, l: 100, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 0, g: 0, b: 0, alpha: 1).toHSL(),
            HSLColor(h: 0, s: 0, l: 0, alpha: 1)
        )
    }

    func testHSLtoRGB() throws {
        XCTAssertEqual(
            HSLColor(h: 208, s: 100, l: 42, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 114 / 255, b: 214 / 255, alpha: 1)
        )

        XCTAssertEqual(
            HSLColor(h: 128, s: 19, l: 60, alpha: 0.5).toRGB(),
            RGBColor(r: 135 / 255, g: 173 / 255, b: 140 / 255, alpha: 0.5)
        )

        XCTAssertEqual(
            HSLColor(h: 41, s: 100, l: 50, alpha: 1).toRGB(),
            RGBColor(r: 1, g: 173 / 255, b: 0, alpha: 1)
        )

        XCTAssertEqual(
            HSLColor(h: 0, s: 100, l: 50, alpha: 1).toRGB(),
            RGBColor(r: 1, g: 0, b: 0, alpha: 1)
        )

        XCTAssertEqual(
            HSLColor(h: 120, s: 100, l: 50, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 1, b: 0, alpha: 1)
        )

        XCTAssertEqual(
            HSLColor(h: 240, s: 100, l: 50, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 0, b: 1, alpha: 1)
        )

        XCTAssertEqual(
            HSLColor(h: 0, s: 100, l: 100, alpha: 1).toRGB(),
            RGBColor(r: 1, g: 1, b: 1, alpha: 1)
        )

        XCTAssertEqual(
            HSLColor(h: 0, s: 0, l: 0, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 0, b: 0, alpha: 1)
        )
    }

    func testRGBtoHSB() throws {
        XCTAssertEqual(
            RGBColor(r: 0, g: 114 / 255, b: 214 / 255, alpha: 1).toHSB(),
            HSBColor(h: 208, s: 100, b: 83.9, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 135 / 255, g: 173 / 255, b: 140 / 255, alpha: 0.5).toHSB(),
            HSBColor(h: 128, s: 22, b: 67.8, alpha: 0.5)
        )

        XCTAssertEqual(
            RGBColor(r: 1, g: 173 / 255, b: 0, alpha: 1).toHSB(),
            HSBColor(h: 41, s: 100, b: 100, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 1, g: 0, b: 0, alpha: 1).toHSB(),
            HSBColor(h: 0, s: 100, b: 100, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 0, g: 1, b: 0, alpha: 1).toHSB(),
            HSBColor(h: 120, s: 100, b: 100, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 0, g: 0, b: 1, alpha: 1).toHSB(),
            HSBColor(h: 240, s: 100, b: 100, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 1, g: 1, b: 1, alpha: 1).toHSB(),
            HSBColor(h: 0, s: 0, b: 100, alpha: 1)
        )

        XCTAssertEqual(
            RGBColor(r: 0, g: 0, b: 0, alpha: 1).toHSB(),
            HSBColor(h: 0, s: 0, b: 0, alpha: 1)
        )
    }

    func testHSBtoRGB() throws {
        XCTAssertEqual(
            HSBColor(h: 208, s: 100, b: 83.9, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 114 / 255, b: 214 / 255, alpha: 1)
        )

        XCTAssertEqual(
            HSBColor(h: 128, s: 22, b: 67.8, alpha: 0.5).toRGB(),
            RGBColor(r: 135 / 255, g: 173 / 255, b: 140 / 255, alpha: 0.5)
        )

        XCTAssertEqual(
            HSBColor(h: 41, s: 100, b: 100, alpha: 1).toRGB(),
            RGBColor(r: 1, g: 173 / 255, b: 0, alpha: 1)
        )

        XCTAssertEqual(
            HSBColor(h: 0, s: 100, b: 100, alpha: 1).toRGB(),
            RGBColor(r: 1, g: 0, b: 0, alpha: 1)
        )

        XCTAssertEqual(
            HSBColor(h: 120, s: 100, b: 100, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 1, b: 0, alpha: 1)
        )

        XCTAssertEqual(
            HSBColor(h: 240, s: 100, b: 100, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 0, b: 1, alpha: 1)
        )

        XCTAssertEqual(
            HSBColor(h: 0, s: 0, b: 100, alpha: 1).toRGB(),
            RGBColor(r: 1, g: 1, b: 1, alpha: 1)
        )

        XCTAssertEqual(
            HSBColor(h: 0, s: 0, b: 0, alpha: 1).toRGB(),
            RGBColor(r: 0, g: 0, b: 0, alpha: 1)
        )
    }

    static var allTests = [
        ("testInterpolateValues", testInterpolateValues),
        ("testInterpolateCircularValues", testInterpolateCircularValues),
        ("testRGBtoHCL", testRGBtoHCL),
        ("testHCLtoRGB", testHCLtoRGB),
        ("testRGBtoHSL", testRGBtoHSL),
        ("testHSLtoRGB", testHSLtoRGB),
        ("testRGBtoHSB", testRGBtoHSB),
        ("testHSBtoRGB", testHSBtoRGB),
    ]
}

extension SmoothGradient.RGBColor: Equatable {
    public static func == (lhs: SmoothGradient.RGBColor, rhs: SmoothGradient.RGBColor) -> Bool {
        func closeEnough(l: CGFloat, r: CGFloat, v: CGFloat) -> Bool {
            abs(l - r) < v
        }
        return closeEnough(l: lhs.r, r: rhs.r, v: 0.01)
            && closeEnough(l: lhs.g, r: rhs.g, v: 0.01)
            && closeEnough(l: lhs.b, r: rhs.b, v: 0.01)
            && closeEnough(l: lhs.alpha, r: rhs.alpha, v: 0.01)
    }
}

extension LCHColor: Equatable {
    public static func == (lhs: LCHColor, rhs: LCHColor) -> Bool {
        func closeEnough(l: CGFloat, r: CGFloat, v: CGFloat) -> Bool {
            abs(l - r) < v
        }
        return closeEnough(l: lhs.l, r: rhs.l, v: 0.5)
            && closeEnough(l: lhs.c, r: rhs.c, v: 0.5)
            && closeEnough(l: lhs.h, r: rhs.h, v: 0.5)
            && closeEnough(l: lhs.alpha, r: rhs.alpha, v: 0.5)
    }
}

extension HSLColor: Equatable {
    public static func == (lhs: HSLColor, rhs: HSLColor) -> Bool {
        func closeEnough(l: CGFloat, r: CGFloat, d: CGFloat) -> Bool {
            abs(l - r) < d
        }
        return closeEnough(l: lhs.l, r: rhs.l, d: 0.5)
            && closeEnough(l: lhs.s, r: rhs.s, d: 0.5)
            && closeEnough(l: lhs.h, r: rhs.h, d: 0.5)
            && closeEnough(l: lhs.alpha, r: rhs.alpha, d: 0.5)
    }
}

extension HSBColor: Equatable {
    public static func == (lhs: HSBColor, rhs: HSBColor) -> Bool {
        func closeEnough(l: CGFloat, r: CGFloat, d: CGFloat) -> Bool {
            abs(l - r) < d
        }
        return closeEnough(l: lhs.h, r: rhs.h, d: 0.5)
            && closeEnough(l: lhs.s, r: rhs.s, d: 0.5)
            && closeEnough(l: lhs.b, r: rhs.b, d: 0.5)
            && closeEnough(l: lhs.alpha, r: rhs.alpha, d: 0.5)
    }
}
