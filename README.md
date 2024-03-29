# SmoothGradient

![License](https://img.shields.io/github/license/intitni/SmoothGradient)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fintitni%2FSmoothGradient%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/intitni/SmoothGradient)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fintitni%2FSmoothGradient%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/intitni/SmoothGradient)

SmoothGradient helps you generate beautiful and buttery-smooth gradients. It helps you avoid gray dead zones in the middle of your gradients by interpolating colors in color spaces other than RGB. 

This is a package strongly inspired by this [gradient generator](https://learnui.design/tools/gradient-generator.html). You can click into the link to learn how this works.

![Image](https://github.com/intitni/SmoothGradient/raw/main/Resources/Gradients.png)

## Usage

```swift
let colors: [UIColor] = SmoothGradientGenerator()
    .generate(
        from: fromColor,
        to: toColor,
        interpolation: .hcl, // choose from hcl, hsl, hsb
        precision: .high
    )
```

Please check example playgrounds for more detail.

## Installation

### Swift Package Manager

Simply add `https://github.com/intitni/SmoothGradient` as a dependency in either Xcode or Package.swift.

## License

MIT.
