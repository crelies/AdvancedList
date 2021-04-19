//
//  AdvancedList.swift
//  AdvancedList
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import ListPagination
import SwiftUI

/// An `advanced` container that presents rows of data arranged in a single column.
/// Built-in `empty`, `error` and `loading` state.
/// Supports `lastItem` or `thresholdItem` pagination.
public struct AdvancedList<Data: RandomAccessCollection, ListView: View, Content: View, EmptyStateView: View, ErrorStateView: View, LoadingStateView: View> : View where Data.Element: Identifiable {
    public typealias Rows = () -> AnyDynamicViewContent
    public typealias OnMoveAction = Optional<(IndexSet, Int) -> Void>
    public typealias OnDeleteAction = Optional<(IndexSet) -> Void>

    private typealias Configuration = (AnyDynamicViewContent) -> AnyDynamicViewContent

    private var pagination: AnyAdvancedListPagination?
    private var data: Data
    private var listView: ((Rows) -> ListView)?
    private var content: (Data.Element) -> Content
    private let listState: ListState
    private let emptyStateView: () -> EmptyStateView
    private let errorStateView: (Error) -> ErrorStateView
    private let loadingStateView: () -> LoadingStateView
    @State private var isLastItem: Bool = false

    private var configurations: [Configuration]

    /// Initializes the list with the given values.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - listView: A view builder that creates a custom list view from the given type erased dynamic view content representing the rows of the list.
    ///   - content: A view builder that creates the view for a single row of the list.
    ///   - listState: A value representing the state of the list.
    ///   - emptyStateView: A view builder that creates the view for the empty state of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init(_ data: Data, @ViewBuilder listView: @escaping (Rows) -> ListView, @ViewBuilder content: @escaping (Data.Element) -> Content, listState: ListState, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.data = data
        self.listView = listView
        self.content = content
        self.listState = listState
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        configurations = []
    }
}

extension AdvancedList where ListView == List<Never, AnyDynamicViewContent> {
    /// Initializes the list with the given values.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - content: A view builder that creates the view for a single row of the list.
    ///   - listState: A value representing the state of the list.
    ///   - emptyStateView: A view builder that creates the view for the empty state of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content, listState: ListState, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.data = data
        self.content = content
        self.listState = listState
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        configurations = []
        listView = getListView
    }
}

extension AdvancedList {
    @ViewBuilder public var body: some View {
        switch listState {
        case .items:
            if !data.isEmpty {
                VStack {
                    if let listView = listView {
                        listView(rows)
                    }

                    if let pagination = pagination, isLastItem {
                        pagination.content()
                    }
                }
            } else {
                emptyStateView()
            }
        case .loading:
            loadingStateView()
        case let .error(error):
            errorStateView(error)
        }
    }
}

// MARK: - View modifiers
extension AdvancedList {
    /// Sets the move action for the dynamic view.
    ///
    /// - Parameter action: A closure that SwiftUI invokes when elements in the dynamic view are moved. The closure takes two arguments that represent the offset relative to the dynamic view’s underlying collection of data.
    /// - Returns: An `AdvancedList` view that calls action when elements are moved within the original view.
    public func onMove(perform action: OnMoveAction) -> Self {
        configure { AnyDynamicViewContent($0.onMove(perform: action)) }
    }

    /// Sets the deletion action for the dynamic view.
    ///
    /// - Parameter action: The action that you want SwiftUI to perform when elements in the view are deleted. SwiftUI passes a set of indices to the closure that’s relative to the dynamic view’s underlying collection of data.
    /// - Returns: An `AdvancedList` view that calls action when elements are deleted from the original view.
    public func onDelete(perform action: OnDeleteAction) -> Self {
        configure { AnyDynamicViewContent($0.onDelete(perform: action)) }
    }

    /// Adds pagination to the `AdvancedList`.
    ///
    /// - Parameter pagination: An `AdvancedListPagination` object specifying the pagination.
    /// - Returns: An `AdvancedList` view that calls the `shouldLoadNextPage` closure of the specified `pagination` everytime when the end of a page was reached.
    public func pagination<Content: View>(
        _ pagination: AdvancedListPagination<Content>
    ) -> Self {
        var result = self
        result.pagination = AnyAdvancedListPagination(pagination)
        return result
    }
}

// MARK: - Private helper
private extension AdvancedList {
    private func configure(_ configuration: @escaping Configuration) -> Self {
        var result = self
        result.configurations.append(configuration)
        return result
    }

    func getListView(rows: Rows) -> List<Never, AnyDynamicViewContent> {
        List(content: rows)
    }

    func rows() -> AnyDynamicViewContent {
        configurations
            .reduce(
                AnyDynamicViewContent(
                    ForEach(data) { item in
                        getItemView(item)
                    }
                )
            ) { (currentView, configuration) in configuration(currentView) }
    }

    func getItemView(_ item: Data.Element) -> some View {
        content(item)
        .onAppear {
            listItemAppears(item)

            if data.isLastItem(item) {
                isLastItem = true
            }
        }
    }

    func listItemAppears(_ item: Data.Element) {
        guard let pagination = pagination else {
            return
        }

        switch pagination.type {
        case .lastItem:
            if data.isLastItem(item) {
                pagination.shouldLoadNextPage()
            }

        case let .thresholdItem(offset):
            if data.isThresholdItem(
                offset: offset,
                item: item
            ) {
                pagination.shouldLoadNextPage()
            }
        }
    }
}

#if DEBUG
struct AdvancedList_Previews : PreviewProvider {
    private struct MockItem: Identifiable {
        let id: String = UUID().uuidString
    }

    private static let items: [MockItem] = Array(0...5).map { _ in MockItem() }
    @State private static var listState: ListState = .items

    static var previews: some View {
        NavigationView {
            AdvancedList(items, content: { element in
                Text(element.id)
            }, listState: listState, emptyStateView: {
                Text("No data")
            }, errorStateView: { error in
                VStack {
                    Text(error.localizedDescription)
                        .lineLimit(nil)

                    Button(action: {
                        // do something
                    }) {
                        Text("Retry")
                    }
                }
            }, loadingStateView: {
                Text("Loading ...")
            })
        }
    }
}
#endif
