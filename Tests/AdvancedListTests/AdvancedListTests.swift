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
    private let emptyStateString = "Empty"
    private lazy var emptyStateView = Text(emptyStateString)
    private let errorStateString = "Error"
    private lazy var errorStateView = Text(errorStateString)
    private let loadingStateString = "Loading ..."
    private lazy var loadingStateView = Text(loadingStateString)

    func testEmptyStateView() {
        let emptyListState: ListState = .items

        let items: [String] = []

        let view = AdvancedList(
            items, content: { item in Text(item) },
            listState: emptyListState,
            emptyStateView: { self.emptyStateView },
            errorStateView: { _ in self.errorStateView },
            loadingStateView: { self.loadingStateView }
        )

        do {
            let inspectableView = try view.body.inspect()
            let text = try inspectableView.text()
            let textString = try text.string()
            XCTAssertEqual(textString, emptyStateString)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testNotEmptyStateView() {
        let itemsListState: ListState = .items

        let mockItem1 = "MockItem1"
        let mockItem2 = "MockItem2"
        let items: [String] = [mockItem1, mockItem2]

        let view = AdvancedList(
            items, content: { item in Text(item) },
            listState: itemsListState,
            emptyStateView: { self.emptyStateView },
            errorStateView: { _ in self.errorStateView },
            loadingStateView: { self.loadingStateView }
        )

        do {
            let inspectableView = try view.body.inspect()
            let vStack = try inspectableView.vStack()
            let list = try vStack.anyView(0).list()
            let anyDynamicViewContent = try list.first?.view(AnyDynamicViewContent.self)
            let forEach = try anyDynamicViewContent?.anyView().forEach()

            let firstElement = try forEach?.first?.anyView()
            XCTAssertEqual(try firstElement?.text().string(), mockItem1)

            let secondElement = try forEach?[1].anyView()
            XCTAssertEqual(try secondElement?.text().string(), mockItem2)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testLoadingStateView() {
        let loadingListState: ListState = .loading

        let items: [String] = []

        let view = AdvancedList(
            items, content: { item in Text(item) },
            listState: loadingListState,
            emptyStateView: { self.emptyStateView },
            errorStateView: { _ in self.errorStateView },
            loadingStateView: { self.loadingStateView }
        )

        do {
            let inspectableView = try view.body.inspect()
            let text = try inspectableView.text()
            let textString = try text.string()
            XCTAssertEqual(textString, loadingStateString)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testErrorStateView() {
        let error = NSError(domain: "MockDomain", code: 1, userInfo: nil)
        let errorListState: ListState = .error(error)

        let items: [String] = []

        let view = AdvancedList(
            items, content: { item in Text(item) },
            listState: errorListState,
            emptyStateView: { self.emptyStateView },
            errorStateView: { _ in self.errorStateView },
            loadingStateView: { self.loadingStateView }
        )

        do {
            let inspectableView = try view.body.inspect()
            let text = try inspectableView.text()
            let textString = try text.string()
            XCTAssertEqual(textString, errorStateString)
        } catch {
            XCTFail("\(error)")
        }
    }

    static var allTests = [
        ("testEmptyStateView", testEmptyStateView),
        ("testNotEmptyStateView", testNotEmptyStateView),
        ("testLoadingStateView", testLoadingStateView),
        ("testErrorStateView", testErrorStateView)
    ]
}
