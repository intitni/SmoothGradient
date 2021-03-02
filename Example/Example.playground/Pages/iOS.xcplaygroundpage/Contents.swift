import PlaygroundSupport
import SmoothGradient
import SwiftUI

#if canImport(UIKit)
import UIKit

let fromColor = #colorLiteral(red: 0.1215686275, green: 0, blue: 0.3607843137, alpha: 1)
let toColor = #colorLiteral(red: 1, green: 0.7098039216, blue: 0.4196078431, alpha: 1)

let uiColors = SmoothGradientGenerator()
    .generate(
        from: fromColor,
        to: toColor,
        interpolation: .hcl,
        precision: .high
    )

func makeColor(from: [UIColor]) -> [Color] {
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

struct ContentView: View {
    var body: some View {
        VStack {
            gradient(
                title: "Original",
                colors: makeColor(from: [fromColor, toColor])
            )
            gradient(
                title: "Smooth UIColor HCL",
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
        Text("Switch playground settings to iOS!")
    }
}

#endif

PlaygroundPage.current.setLiveView(ContentView())
