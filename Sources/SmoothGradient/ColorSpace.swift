/// This file is composed and modified from the following 2 files.
///
/// Part of the code from https://github.com/timrwood/ColorSpaces
///
/// Copyright (c) 2015-2016 Tim Wood
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///
/// Part of the code from https://github.com/ovenbits/Alexandria
///
/// Copyright (c) 2014-2016 Oven Bits, LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import Foundation

// MARK: - Constants

private let RAD_TO_DEG = 180 / Double.pi

private let LAB_E: Double = 0.008856
private let LAB_16_116: Double = 0.1379310
private let LAB_K_116: Double = 7.787036
private let LAB_X: Double = 0.95047
private let LAB_Y: Double = 1
private let LAB_Z: Double = 1.08883

// MARK: - RGB

public struct RGBColor {
    public let r: Double // 0..1
    public let g: Double // 0..1
    public let b: Double // 0..1
    public let alpha: Double // 0..1

    public init(r: Double, g: Double, b: Double, alpha: Double) {
        self.r = r
        self.g = g
        self.b = b
        self.alpha = alpha
    }

    fileprivate func sRGBCompand(_ v: Double) -> Double {
        let absV = abs(v)
        let out = absV > 0.04045 ? pow((absV + 0.055) / 1.055, 2.4) : absV / 12.92
        return v > 0 ? out : -out
    }

    func toXYZ() -> XYZColor {
        let R = sRGBCompand(r)
        let G = sRGBCompand(g)
        let B = sRGBCompand(b)
        let x: Double = (R * 0.4124564) + (G * 0.3575761) + (B * 0.1804375)
        let y: Double = (R * 0.2126729) + (G * 0.7151522) + (B * 0.0721750)
        let z: Double = (R * 0.0193339) + (G * 0.1191920) + (B * 0.9503041)
        return XYZColor(x: x, y: y, z: z, alpha: alpha)
    }

    func toLAB() -> LABColor {
        return toXYZ().toLAB()
    }

    func toLCH() -> LCHColor {
        return toXYZ().toLCH()
    }

    /// Converts RGB to HSL (https://en.wikipedia.org/wiki/HSL_and_HSV)
    func toHSL() -> HSLColor {
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)

        var h, s: Double
        let l = (max + min) / 2
        let d = max - min

        if max == min {
            h = 0
            s = 0
        } else {
            s = (l > 0.5) ? d / (2 - max - min) : d / (max + min)

            switch max {
            case r: h = (g - b) / d + (g < b ? 6 : 0)
            case g: h = (b - r) / d + 2
            case b: h = (r - g) / d + 4
            default: h = 0
            }

            h /= 6
        }

        return HSLColor(h: h * 360, s: s * 100, l: l * 100, alpha: alpha)
    }

    /// Converts RGB to HSB (https://en.wikipedia.org/wiki/HSL_and_HSV)
    func toHSB() -> HSBColor {
        var h, s, v: Double

        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)
        let d = max - min

        if d == 0 {
            h = 0
            s = 0
        } else {
            s = (max == 0) ? 0 : d / max

            switch max {
            case r: h = ((g - b) / d) + (g < b ? 6 : 0)
            case g: h = ((b - r) / d) + 2
            case b: h = ((r - g) / d) + 4
            default: h = 0
            }

            h /= 6
        }

        v = max

        return HSBColor(h: h * 360, s: s * 100, b: v * 100, alpha: alpha)
    }
}

// MARK: - XYZ

public struct XYZColor {
    public let x: Double // 0..0.95047
    public let y: Double // 0..1
    public let z: Double // 0..1.08883
    public let alpha: Double // 0..1

    public init(x: Double, y: Double, z: Double, alpha: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.alpha = alpha
    }

    fileprivate func sRGBCompand(_ v: Double) -> Double {
        let absV = abs(v)
        let out = absV > 0.0031308 ? 1.055 * pow(absV, 1 / 2.4) - 0.055 : absV * 12.92
        return v > 0 ? out : -out
    }

    func toRGB() -> RGBColor {
        let r = (x * 3.2404542) + (y * -1.5371385) + (z * -0.4985314)
        let g = (x * -0.9692660) + (y * 1.8760108) + (z * 0.0415560)
        let b = (x * 0.0556434) + (y * -0.2040259) + (z * 1.0572252)
        let R = sRGBCompand(r)
        let G = sRGBCompand(g)
        let B = sRGBCompand(b)
        return RGBColor(r: R, g: G, b: B, alpha: alpha)
    }

    fileprivate func labCompand(_ v: Double) -> Double {
        return v > LAB_E ? pow(v, 1.0 / 3.0) : (LAB_K_116 * v) + LAB_16_116
    }

    func toLAB() -> LABColor {
        let fx = labCompand(x / LAB_X)
        let fy = labCompand(y / LAB_Y)
        let fz = labCompand(z / LAB_Z)
        return LABColor(
            l: 116 * fy - 16,
            a: 500 * (fx - fy),
            b: 200 * (fy - fz),
            alpha: alpha
        )
    }

    func toLCH() -> LCHColor {
        return toLAB().toLCH()
    }
}

// MARK: - LAB

public struct LABColor {
    public let l: Double //    0..100
    public let a: Double // -128..128
    public let b: Double // -128..128
    public let alpha: Double //    0..1

    public init(l: Double, a: Double, b: Double, alpha: Double) {
        self.l = l
        self.a = a
        self.b = b
        self.alpha = alpha
    }

    fileprivate func xyzCompand(_ v: Double) -> Double {
        let v3 = v * v * v
        return v3 > LAB_E ? v3 : (v - LAB_16_116) / LAB_K_116
    }

    func toXYZ() -> XYZColor {
        let y = (l + 16) / 116
        let x = y + (a / 500)
        let z = y - (b / 200)
        return XYZColor(
            x: xyzCompand(x) * LAB_X,
            y: xyzCompand(y) * LAB_Y,
            z: xyzCompand(z) * LAB_Z,
            alpha: alpha
        )
    }

    func toLCH() -> LCHColor {
        let c = sqrt(a * a + b * b)
        let angle = atan2(b, a) * RAD_TO_DEG
        let h = angle < 0 ? angle + 360 : angle
        return LCHColor(l: l, c: c, h: h, alpha: alpha)
    }

    func toRGB() -> RGBColor {
        return toXYZ().toRGB()
    }
}

// MARK: - LCH

public struct LCHColor {
    public let l: Double // 0..100
    public let c: Double // 0..128
    public let h: Double // 0..360
    public let alpha: Double // 0..1

    public init(l: Double, c: Double, h: Double, alpha: Double) {
        self.l = l
        self.c = c
        self.h = h
        self.alpha = alpha
    }

    func toLAB() -> LABColor {
        let rad = h / RAD_TO_DEG
        let a = cos(rad) * c
        let b = sin(rad) * c
        return LABColor(l: l, a: a, b: b, alpha: alpha)
    }

    func toXYZ() -> XYZColor {
        return toLAB().toXYZ()
    }

    func toRGB() -> RGBColor {
        return toXYZ().toRGB()
    }
}

// MARK: - HSL

public struct HSLColor {
    public let h: Double // 0..360
    public let s: Double // 0..100
    public let l: Double // 0..100
    public let alpha: Double // 0..1

    public init(h: Double, s: Double, l: Double, alpha: Double) {
        self.h = h
        self.s = s
        self.l = l
        self.alpha = alpha
    }

    /// Converts HSL to RGB (https://en.wikipedia.org/wiki/HSL_and_HSV)
    func toRGB() -> RGBColor {
        var r, g, b: Double

        let nl = l / 100
        let ns = s / 100

        if s == 0 {
            r = nl
            g = nl
            b = nl
        } else {
            let c = (1 - abs(2 * nl - 1)) * ns
            let x = c * (1 - abs((h / 60).truncatingRemainder(dividingBy: 2) - 1))
            let m = nl - c / 2

            switch h / 60 {
            case 0..<1: (r, g, b) = (c + m, x + m, 0 + m)
            case 1..<2: (r, g, b) = (x + m, c + m, 0 + m)
            case 2..<3: (r, g, b) = (0 + m, c + m, x + m)
            case 3..<4: (r, g, b) = (0 + m, x + m, c + m)
            case 4..<5: (r, g, b) = (x + m, 0 + m, c + m)
            case 5..<6: (r, g, b) = (c + m, 0 + m, x + m)
            default: (r, g, b) = (m, m, m)
            }
        }

        return RGBColor(r: r, g: g, b: b, alpha: alpha)
    }
}

// MARK: - HSB / HSV

public struct HSBColor {
    public let h: Double // 0..360
    public let s: Double // 0..100
    public let b: Double // 0..100
    public let alpha: Double // 0..1

    public init(h: Double, s: Double, b: Double, alpha: Double) {
        self.h = h
        self.s = s
        self.b = b
        self.alpha = alpha
    }

    /// Converts HSB to RGB (https://en.wikipedia.org/wiki/HSL_and_HSV)
    func toRGB() -> RGBColor {
        let nb = b / 100
        let ns = s / 100

        let c = nb * ns
        let x = c * (1 - abs((h / 60).truncatingRemainder(dividingBy: 2) - 1))
        let m = nb - c

        var r, g, b: Double

        switch h / 60 {
        case 0..<1: (r, g, b) = (c + m, x + m, 0 + m)
        case 1..<2: (r, g, b) = (x + m, c + m, 0 + m)
        case 2..<3: (r, g, b) = (0 + m, c + m, x + m)
        case 3..<4: (r, g, b) = (0 + m, x + m, c + m)
        case 4..<5: (r, g, b) = (x + m, 0 + m, c + m)
        case 5..<6: (r, g, b) = (c + m, 0 + m, x + m)
        default: (r, g, b) = (m, m, m)
        }

        return RGBColor(r: r, g: g, b: b, alpha: alpha)
    }
}
