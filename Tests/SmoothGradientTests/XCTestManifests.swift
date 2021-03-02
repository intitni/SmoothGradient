import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SmoothGradientTests.allTests),
    ]
}
#endif
