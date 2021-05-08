import PlaygroundSupport
import SmoothGradient
import SwiftUI

#if canImport(AppKit)
import AppKit

let fromColor = #colorLiteral(red: 0.1215686275, green: 0, blue: 0.3607843137, alpha: 1)
let toColor = #colorLiteral(red: 1, green: 0.7098039216, blue: 0.4196078431, alpha: 1)

let uiColors = SmoothGradientGenerator()
    .generate(
        from: fromColor,
        to: toColor,
        interpolation: .hcl,
        precision: .high
    )

func makeColor(from: [NSColor]) -> [Color] {
    return from.map(Color.init)
}

let swiftUIColors = SmoothGradientGenerator()
    .generate(
        from: Color(fromColor),
        to: Color(toColor),
        interpolation: .hcl,
        precision: .high
    )

let hslColors = SmoothGradientGenerator()
    .generate(
        from: Color(fromColor),
        to: Color(toColor),
        interpolation: .hsl,
        precision: .high
    )

let hsbColors = SmoothGradientGenerator()
    .generate(
        from: Color(fromColor),
        to: Color(toColor),
        interpolation: .hsb,
        precision: .high
    )

_ = SmoothGradientGenerator().generate(
    from: LCHColor(l: 1, c: 1, h: 1, alpha: 1),
    to: LCHColor(l: 1, c: 1, h: 1, alpha: 1),
    precision: .high
)

_ = SmoothGradientGenerator().generate(
    from: HSLColor(h: 1, s: 1, l: 1, alpha: 1),
    to: HSLColor(h: 1, s: 1, l: 1, alpha: 1),
    precision: .high
)

_ = SmoothGradientGenerator().generate(
    from: HSBColor(h: 1, s: 1, b: 1, alpha: 1),
    to: HSBColor(h: 1, s: 1, b: 1, alpha: 1),
    precision: .high
)

_ = SmoothGradientGenerator().generate(
    from: XYZColor(x: 1, y: 1, z: 1, alpha: 1),
    to: XYZColor(x: 1, y: 1, z: 1, alpha: 1),
    interpolation: .hsb,
    precision: .high
)

_ = SmoothGradientGenerator().generate(
    from: LABColor(l: 1, a: 1, b: 1, alpha: 1),
    to: LABColor(l: 1, a: 1, b: 1, alpha: 1),
    interpolation: .hsb,
    precision: .high
)

struct ContentView: View {
    var body: some View {
        VStack {
            gradient(
                title: "Original",
                colors: makeColor(from: [fromColor, toColor])
            )
            gradient(
                title: "Smooth NSColor HCL",
                colors: makeColor(from: uiColors)
            )
            gradient(
                title: "Smooth SwiftUI Color HCL",
                colors: swiftUIColors
            )
            gradient(
                title: "Smooth SwiftUI Color HSL",
                colors: hslColors
            )
            gradient(
                title: "Smooth SwiftUI Color HSB",
                colors: hsbColors
            )
        }
    }

    func gradient(title: String, colors: [Color]) -> some View {
        VStack(spacing: 2) {
            Text(title)
            Rectangle()
                .fill(LinearGradient(
                    gradient: .init(colors: colors),
                    startPoint: .init(x: 0, y: 0),
                    endPoint: .init(x: 1, y: 0)
                ))
                .frame(width: 300, height: 60)
        }
    }
}

#else

struct ContentView: View {
    var body: some View {
        Text("Switch playground settings to macOS!")
    }
}

#endif

PlaygroundPage.current.setLiveView(ContentView())
