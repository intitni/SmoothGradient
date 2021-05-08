/// In which color space to interpolate.
public enum SmoothGradientInterpolation {
    case hcl
    case hsl
    case hsb
}

/// Define the number of intermediate colors to generate.
public enum SmoothGradientPrecision: Int {
    case low = 1
    case lowMedium = 3
    case medium = 5
    case mediumHigh = 7
    case high = 9
}

protocol RGBColorConvertible {
    func toRGB() -> RGBColor
}

extension XYZColor: RGBColorConvertible {}
extension LABColor: RGBColorConvertible {}
extension LCHColor: RGBColorConvertible {}
extension HSLColor: RGBColorConvertible {}
extension HSBColor: RGBColorConvertible {}

/// Generate a set of intermediate colors to make gradient of 2 colors buttery-smooth.
public struct SmoothGradientGenerator {
    public init() {}

    /// Generate gradient from `RGBColor`s.
    public func generate(
        from: RGBColor,
        to: RGBColor,
        interpolation: SmoothGradientInterpolation = .hcl,
        precision: SmoothGradientPrecision = .medium
    ) -> [RGBColor] {
        let count = precision.rawValue
        return interpolate(from: from, to: to, count: count, interpolation: interpolation)
    }

    /// Generate gradient from any type that convertible from/to RGBColor
    func generateAsRGBColor<T: RGBColorConvertible>(
        from: T,
        to: T,
        interpolation: SmoothGradientInterpolation,
        precision: SmoothGradientPrecision
    ) -> [RGBColor] {
        let rgb_from = from.toRGB()
        let rgb_to = to.toRGB()
        return generate(
            from: rgb_from,
            to: rgb_to,
            interpolation: interpolation,
            precision: precision
        )
    }

    /// Generate gradient from `LCHColor`s. Default to interpolate in LCH.
    ///
    /// When interpolating in color space other than LCH, colors will be converted to RGBColor for
    /// computation.
    public func generate(
        from: LCHColor,
        to: LCHColor,
        interpolation: SmoothGradientInterpolation = .hcl,
        precision: SmoothGradientPrecision = .medium
    ) -> [LCHColor] {
        switch interpolation {
        case .hcl:
            let count = precision.rawValue
            return interpolate(from: from, to: to, count: count)
        default:
            return generateAsRGBColor(
                from: from,
                to: to,
                interpolation: interpolation,
                precision: precision
            )
            .map { $0.toLCH() }
        }
    }

    /// Generate gradient from `HSLColor`s. Default to interpolate in HSL.
    ///
    /// When interpolating in color space other than HSL, colors will be converted to RGBColor for
    /// computation.
    public func generate(
        from: HSLColor,
        to: HSLColor,
        interpolation: SmoothGradientInterpolation = .hsl,
        precision: SmoothGradientPrecision = .medium
    ) -> [HSLColor] {
        switch interpolation {
        case .hsl:
            let count = precision.rawValue
            return interpolate(from: from, to: to, count: count)
        default:
            return generateAsRGBColor(
                from: from,
                to: to,
                interpolation: interpolation,
                precision: precision
            )
            .map { $0.toHSL() }
        }
    }

    /// Generate gradient from `HSBColor`s. Default to interpolate in HSB.
    ///
    /// When interpolating in color space other than HSB, colors will be converted to RGBColor for
    /// computation.
    public func generate(
        from: HSBColor,
        to: HSBColor,
        interpolation: SmoothGradientInterpolation = .hsb,
        precision: SmoothGradientPrecision = .medium
    ) -> [HSBColor] {
        switch interpolation {
        case .hsb:
            let count = precision.rawValue
            return interpolate(from: from, to: to, count: count)
        default:
            return generateAsRGBColor(
                from: from,
                to: to,
                interpolation: interpolation,
                precision: precision
            )
            .map { $0.toHSB() }
        }
    }

    /// Generate gradient from `LABColor`s.
    public func generate(
        from: LABColor,
        to: LABColor,
        interpolation: SmoothGradientInterpolation = .hcl,
        precision: SmoothGradientPrecision = .medium
    ) -> [LABColor] {
        return generateAsRGBColor(
            from: from,
            to: to,
            interpolation: interpolation,
            precision: precision
        )
        .map { $0.toLAB() }
    }

    /// Generate gradient from `XYZColor`s.
    public func generate(
        from: XYZColor,
        to: XYZColor,
        interpolation: SmoothGradientInterpolation = .hcl,
        precision: SmoothGradientPrecision = .medium
    ) -> [XYZColor] {
        return generateAsRGBColor(
            from: from,
            to: to,
            interpolation: interpolation,
            precision: precision
        )
        .map { $0.toXYZ() }
    }
}

#if canImport(UIKit)
import UIKit

public extension SmoothGradientGenerator {
    /// Generate gradient from `UIColor`s.
    func generate(
        from: UIColor,
        to: UIColor,
        interpolation: SmoothGradientInterpolation = .hcl,
        precision: SmoothGradientPrecision = .medium
    ) -> [UIColor] {
        generateAsRGBColor(from: from, to: to, interpolation: interpolation, precision: precision)
            .map {
                UIColor(
                    red: CGFloat($0.r),
                    green: CGFloat($0.g),
                    blue: CGFloat($0.b),
                    alpha: CGFloat($0.alpha)
                )
            }
    }
}

extension UIColor: RGBColorConvertible {
    func toRGB() -> RGBColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)
        return RGBColor(r: Double(r), g: Double(g), b: Double(b), alpha: Double(a))
    }
}

#elseif canImport(AppKit)
import AppKit

public extension SmoothGradientGenerator {
    /// Generate gradient from `NSColor`s.
    func generate(
        from: NSColor,
        to: NSColor,
        interpolation: SmoothGradientInterpolation = .hcl,
        precision: SmoothGradientPrecision = .medium
    ) -> [NSColor] {
        generateAsRGBColor(from: from, to: to, interpolation: interpolation, precision: precision)
            .map {
                NSColor(
                    red: CGFloat($0.r),
                    green: CGFloat($0.g),
                    blue: CGFloat($0.b),
                    alpha: CGFloat($0.alpha)
                )
            }
    }
}

extension NSColor: RGBColorConvertible {
    func toRGB() -> RGBColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)
        return RGBColor(r: Double(r), g: Double(g), b: Double(b), alpha: Double(a))
    }
}

#endif

#if canImport(SwiftUI) && (arch(arm64) || arch(x86_64))

import SwiftUI

public extension SmoothGradientGenerator {
    /// Generate gradient from SwiftUI `Color`s.
    @available(iOS 14.0, OSX 11, tvOS 14, *)
    func generate(
        from: Color,
        to: Color,
        colorSpace: Color.RGBColorSpace = .sRGB,
        interpolation: SmoothGradientInterpolation = .hcl,
        precision: SmoothGradientPrecision = .medium
    ) -> [Color] {
        let rgb_from = from.toRGB()
        let rgb_to = to.toRGB()
        return generate(
            from: rgb_from,
            to: rgb_to,
            interpolation: interpolation,
            precision: precision
        )
        .map {
            Color(
                colorSpace,
                red: Double($0.r),
                green: Double($0.g),
                blue: Double($0.b),
                opacity: Double($0.alpha)
            )
        }
    }
}

@available(iOS 14.0, OSX 11, tvOS 14, *)
extension Color {
    func toRGB() -> RGBColor {
        guard let components = cgColor?.components else { return .init(r: 0, g: 0, b: 0, alpha: 0) }
        return .init(
            r: Double(components[safely: 0] ?? 0),
            g: Double(components[safely: 1] ?? 0),
            b: Double(components[safely: 2] ?? 0),
            alpha: Double(components[safely: 3] ?? 0)
        )
    }
}

#endif

/// Generate intermediate colors.
func interpolate(
    from: RGBColor,
    to: RGBColor,
    count: Int,
    interpolation: SmoothGradientInterpolation
) -> [RGBColor] {
    switch interpolation {
    case .hcl:
        let lch_from = from.toLCH()
        let lch_to = to.toLCH()
        return interpolate(from: lch_from, to: lch_to, count: count)
            .map { $0.toRGB() }
    case .hsl:
        let hsl_from = from.toHSL()
        let hsl_to = to.toHSL()
        return interpolate(from: hsl_from, to: hsl_to, count: count)
            .map { $0.toRGB() }
    case .hsb:
        let hsb_from = from.toHSB()
        let hsb_to = to.toHSB()
        return interpolate(from: hsb_from, to: hsb_to, count: count)
            .map { $0.toRGB() }
    }
}

func interpolate(from: LCHColor, to: LCHColor, count: Int) -> [LCHColor] {
    let l = interpolate(from: from.l, to: to.l, count: count)
    let c = interpolate(from: from.c, to: to.c, count: count)
    let h = interpolateCircular(from: from.h, to: to.h, count: count)
    let alpha = interpolate(from: from.alpha, to: to.alpha, count: count)

    return zip(l, c, h, alpha)
        .map(LCHColor.init(l:c:h:alpha:))
}

func interpolate(from: HSLColor, to: HSLColor, count: Int) -> [HSLColor] {
    let l = interpolate(from: from.l, to: to.l, count: count)
    let s = interpolate(from: from.s, to: to.s, count: count)
    let h = interpolateCircular(from: from.h, to: to.h, count: count)
    let alpha = interpolate(from: from.alpha, to: to.alpha, count: count)

    return zip(h, s, l, alpha)
        .map(HSLColor.init(h:s:l:alpha:))
}

func interpolate(from: HSBColor, to: HSBColor, count: Int) -> [HSBColor] {
    let b = interpolate(from: from.b, to: to.b, count: count)
    let s = interpolate(from: from.s, to: to.s, count: count)
    let h = interpolateCircular(from: from.h, to: to.h, count: count)
    let alpha = interpolate(from: from.alpha, to: to.alpha, count: count)

    return zip(h, s, b, alpha)
        .map(HSBColor.init(h:s:b:alpha:))
}

/// Interpolate values linearly.
func interpolate(from: Double, to: Double, count: Int) -> [Double] {
    guard count > 0 else { return [from, to] }
    guard to != from else { return .init(repeating: from, count: count + 2) }
    let step = (to - from) / Double(count + 1)
    return Array(stride(from: from, through: to, by: step))
}

/// Interpolate values as degree. It will choose the shortest arc for interpolation.
func interpolateCircular(from: Double, to: Double, count: Int) -> [Double] {
    func clamp(_ value: Double) -> Double {
        var v = value
        while v < 0 { v += 360 }
        while v >= 360 { v -= 360 }
        return v
    }

    let clockwise = (to > from && to - from <= 180) || (to < from && from - to > 180)
    switch (to > from, clockwise) {
    case (true, true):
        return interpolate(from: from, to: to, count: count)
    case (false, true):
        return interpolate(from: from, to: to + 360, count: count).map(clamp)
    case (true, false):
        return interpolate(from: from, to: to - 360, count: count).map(clamp)
    case (false, false):
        return interpolate(from: from, to: to, count: count)
    }
}

func zip<A, B, C, D>(_ a: [A], _ b: [B], _ c: [C], _ d: [D]) -> [(A, B, C, D)] {
    zip(zip(a, b), zip(c, d)).map {
        ($0.0, $0.1, $1.0, $1.1)
    }
}

extension Collection {
    subscript(safely index: Index) -> Element? {
        guard index < endIndex, index >= startIndex else { return nil }
        return self[index]
    }
}
