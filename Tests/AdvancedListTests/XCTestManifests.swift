import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AdvancedListPaginationStateTests.allTests),
        testCase(AdvancedListTests.allTests),
        testCase(ListStateTests.allTests)
    ]
}
#endif
