import XCTest
@testable import AdvancedList

final class AdvancedListTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AdvancedList().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
