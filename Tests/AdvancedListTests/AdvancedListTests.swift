//
//  AdvancedListTests.swift
//  AdvancedListTests
//
//  Created by Christian Elies on 21.02.20.
//

@testable import AdvancedList
import SwiftUI
import XCTest

final class AdvancedListTests: XCTestCase {
    @State private var listState: ListState = .items

    private let emptyStateView = Text("Empty")
    private let errorStateView = Text("Error")
    private let loadingStateView = Text("Loading ...")

    override func setUp() {
        listState = .items
    }

    func testEmptyStateView() {
        let items: [String] = []

        let view = AdvancedList(items, content: { item in Text(item) },
                                listState: $listState,
                                emptyStateView: { self.emptyStateView },
                                errorStateView: { _ in self.errorStateView },
                                loadingStateView: { self.loadingStateView },
                                pagination: .noPagination)

        let body = view.body as? AnyView
        XCTAssertNotNil(body)
    }

    func testNotEmptyStateView() {
        let items: [String] = ["MockItem1", "MockItem2"]

        let view = AdvancedList(items, content: { item in Text(item) },
                                listState: $listState,
                                emptyStateView: { self.emptyStateView },
                                errorStateView: { _ in self.errorStateView },
                                loadingStateView: { self.loadingStateView },
                                pagination: .noPagination)

        let body = view.body as? AnyView
        XCTAssertNotNil(body)
    }

    func testLoadingStateView() {
        listState = .loading

        let items: [String] = []

        let view = AdvancedList(items, content: { item in Text(item) },
                                listState: $listState,
                                emptyStateView: { self.emptyStateView },
                                errorStateView: { _ in self.errorStateView },
                                loadingStateView: { self.loadingStateView },
                                pagination: .noPagination)

        let body = view.body as? AnyView
        XCTAssertNotNil(body)
    }

    func testErrorStateView() {
        let error = NSError(domain: "MockDomain", code: 1, userInfo: nil)
        listState = .error(error)

        let items: [String] = []

        let view = AdvancedList(items, content: { item in Text(item) },
                                listState: $listState,
                                emptyStateView: { self.emptyStateView },
                                errorStateView: { _ in self.errorStateView },
                                loadingStateView: { self.loadingStateView },
                                pagination: .noPagination)

        let body = view.body as? AnyView
        XCTAssertNotNil(body)
    }

    static var allTests = [
        ("testEmptyStateView", testEmptyStateView),
        ("testNotEmptyStateView", testNotEmptyStateView),
        ("testLoadingStateView", testLoadingStateView),
        ("testErrorStateView", testErrorStateView)
    ]
}
