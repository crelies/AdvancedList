//
//  ListStateTests.swift
//  AdvancedListTests
//
//  Created by Christian Elies on 21.02.20.
//

@testable import AdvancedList
import XCTest

final class ListStateTests: XCTestCase {
    func testEqualObjects() {
        let object1: ListState = .items
        let object2: ListState = .items
        XCTAssertEqual(object1, object2)
    }

    func testUnequalObjects() {
        let object1: ListState = .items
        let object2: ListState = .loading
        XCTAssertNotEqual(object1, object2)
    }

    func testEqualError() {
        let error = NSError(domain: "MockDomain", code: 0, userInfo: nil)
        let object1: ListState = .error(error)
        let object2: ListState = .error(error)
        XCTAssertEqual(object1, object2)
    }

    func testUnequalError() {
        let error1 = NSError(domain: "MockDomain", code: 0, userInfo: nil)
        let error2 = NSError(domain: "MockDomain2", code: 1, userInfo: nil)
        let object1: ListState = .error(error1)
        let object2: ListState = .error(error2)
        XCTAssertNotEqual(object1, object2)
    }

    static var allTests = [
        ("testEqualObjects", testEqualObjects),
        ("testUnequalObjects", testUnequalObjects),
        ("testEqualError", testEqualError),
        ("testUnequalError", testUnequalError)
    ]
}
