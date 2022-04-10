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
public struct AdvancedList<EmptyStateView: View, ErrorStateView: View, LoadingStateView: View>: View {
    // MARK: - Public

    public typealias OnMoveAction = Optional<(IndexSet, Int) -> Void>
    public typealias OnDeleteAction = Optional<(IndexSet) -> Void>

    // MARK: - Private

    private typealias Configuration = (AnyDynamicViewContent) -> AnyDynamicViewContent

    private let type: AnyAdvancedListType

    private let listState: ListState
    private let emptyStateView: () -> EmptyStateView
    private let errorStateView: (Error) -> ErrorStateView
    private let loadingStateView: () -> LoadingStateView

    private var pagination: AnyAdvancedListPagination?
    @State private var isLastItem: Bool = false

    private var configurations: [Configuration]
}

// MARK: - Data initializers

extension AdvancedList {
    public typealias Rows = () -> AnyDynamicViewContent

    /// Initializes the list with the given values.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - listView: A view builder that creates a custom list view from the given type erased dynamic view content representing the rows of the list.
    ///   - content: A view builder that creates the view for a single row of the list.
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - emptyStateView: A view builder that creates the view for the empty state of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<Data: RandomAccessCollection, ListView: View, RowContent: View>(_ data: Data, @ViewBuilder listView: @escaping (Rows) -> ListView, @ViewBuilder content: @escaping (Data.Element) -> RowContent, listState: ListState = .items, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) where Data.Element: Identifiable {
        let listView = { AnyView(listView($0)) }
        self.type = .init(type: .data(data: AnyRandomAccessCollection(data), listView: listView, rowContent: { AnyView(content($0)) }))

        self.listState = listState
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        configurations = []
    }

    /// Initializes the list with the given values.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - content: A view builder that creates the view for a single row of the list.
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - emptyStateView: A view builder that creates the view for the empty state of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<Data: RandomAccessCollection, RowContent: View>(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> RowContent, listState: ListState = .items, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) where Data.Element: Identifiable {
        let listView = { AnyView(List<Never, AnyDynamicViewContent>(content: $0)) }
        self.type = .init(type: .data(data: AnyRandomAccessCollection(data), listView: listView, rowContent: { AnyView(content($0)) }))

        self.listState = listState
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        configurations = []
    }

    /// Initializes the list with the given values that supports selecting a single row.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - rowContent: A view builder that creates the view for a single row of the list.
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - selection: A binding to a selected value.
    ///   - emptyStateView: A view builder that creates the view for the empty state of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<Data: RandomAccessCollection, SelectionValue: Hashable, RowContent: View>(_ data: Data, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent, listState: ListState = .items, selection: Binding<SelectionValue?>?, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) where Data.Element: Identifiable {
        let listView = { AnyView(List<SelectionValue, AnyDynamicViewContent>(selection: selection, content: $0)) }
        self.type = .init(type: .data(data: AnyRandomAccessCollection(data), listView: listView, rowContent: { AnyView(rowContent($0)) }))

        self.listState = listState
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        configurations = []
    }

    /// Initializes the list with the given values that supports selecting multiple rows.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - rowContent: A view builder that creates the view for a single row of the list.
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - emptyStateView: A view builder that creates the view for the empty state of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<Data: RandomAccessCollection, SelectionValue: Hashable, RowContent: View>(_ data: Data, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent, listState: ListState = .items, selection: Binding<Set<SelectionValue>>?, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) where Data.Element: Identifiable {
        let listView = { AnyView(List<SelectionValue, AnyDynamicViewContent>(selection: selection, content: $0)) }
        self.type = .init(type: .data(data: AnyRandomAccessCollection(data), listView: listView, rowContent: { AnyView(rowContent($0)) }))

        self.listState = listState
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        configurations = []
    }
}

// MARK: - Content initializers

@available(iOS 15, *)
@available(macOS 12, *)
@available(tvOS 15, *)
extension AdvancedList where EmptyStateView == EmptyView {
    /// Initializes the list with the given content.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - content: A view builder that creates the content of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<Content: View>(listState: ListState = .items, @ViewBuilder content: @escaping () -> Content, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(content()) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        configurations = []
    }

    /// Initializes the list with the given content.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - listContent: A view builder that creates the content of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<ListContent: View>(listState: ListState = .items, @ViewBuilder listContent: @escaping () -> ListContent, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(List(content: listContent)) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        configurations = []
    }

    /// Initializes the list with the given content that supports selecting a single row.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - selection: A binding to a selected value.
    ///   - listContent: A view builder that creates the content of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<ListContent: View, SelectionValue: Hashable>(listState: ListState = .items, selection: Binding<SelectionValue?>?, @ViewBuilder listContent: @escaping () -> ListContent, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(List(selection: selection, content: listContent)) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        configurations = []
    }

    /// Initializes the list with the given content that supports selecting multiple rows.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - listContent: A view builder that creates the content of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<ListContent: View, SelectionValue: Hashable>(listState: ListState = .items, selection: Binding<Set<SelectionValue>>?, @ViewBuilder listContent: @escaping () -> ListContent, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(List(selection: selection, content: listContent)) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        configurations = []
    }
}

@available(iOS 15, *)
@available(macOS 12, *)
@available(tvOS 15, *)
extension AdvancedList where EmptyStateView == EmptyView, ErrorStateView == EmptyView {
    /// Initializes the list with the given content.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - content: A view builder that creates the content of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<Content: View>(listState: ListState = .items, @ViewBuilder content: @escaping () -> Content, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(content()) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = { _ in ErrorStateView() }
        self.loadingStateView = loadingStateView
        configurations = []
    }

    /// Initializes the list with the given content.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - listContent: A view builder that creates the content of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<ListContent: View>(listState: ListState = .items, @ViewBuilder listContent: @escaping () -> ListContent, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(List(content: listContent)) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = { _ in ErrorStateView() }
        self.loadingStateView = loadingStateView
        configurations = []
    }

    /// Initializes the list with the given content that supports selecting a single row.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - selection: A binding to a selected value.
    ///   - listContent: A view builder that creates the content of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<ListContent: View, SelectionValue: Hashable>(listState: ListState = .items, selection: Binding<SelectionValue?>?, @ViewBuilder listContent: @escaping () -> ListContent, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(List(selection: selection, content: listContent)) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = { _ in ErrorStateView() }
        self.loadingStateView = loadingStateView
        configurations = []
    }

    /// Initializes the list with the given content that supports selecting multiple rows.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - listContent: A view builder that creates the content of the list.
    ///   - loadingStateView: A view builder that creates the view for the loading state of the list.
    public init<ListContent: View, SelectionValue: Hashable>(listState: ListState = .items, selection: Binding<Set<SelectionValue>>?, @ViewBuilder listContent: @escaping () -> ListContent, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(List(selection: selection, content: listContent)) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = { _ in ErrorStateView() }
        self.loadingStateView = loadingStateView
        configurations = []
    }
}

@available(iOS 15, *)
@available(macOS 12, *)
@available(tvOS 15, *)
extension AdvancedList where EmptyStateView == EmptyView, LoadingStateView == EmptyView {
    /// Initializes the list with the given content.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - content: A view builder that creates the content of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    public init<Content: View>(listState: ListState = .items, @ViewBuilder content: @escaping () -> Content, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(content()) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = errorStateView
        self.loadingStateView = { LoadingStateView() }
        configurations = []
    }

    /// Initializes the list with the given content.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - listContent: A view builder that creates the content of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    public init<ListContent: View>(listState: ListState = .items, @ViewBuilder listContent: @escaping () -> ListContent, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(List(content: listContent)) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = errorStateView
        self.loadingStateView = { LoadingStateView() }
        configurations = []
    }

    /// Initializes the list with the given content that supports selecting a single row.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - selection: A binding to a selected value.
    ///   - listContent: A view builder that creates the content of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    public init<ListContent: View, SelectionValue: Hashable>(listState: ListState = .items, selection: Binding<SelectionValue?>?, @ViewBuilder listContent: @escaping () -> ListContent, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(List(selection: selection, content: listContent)) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = errorStateView
        self.loadingStateView = { LoadingStateView() }
        configurations = []
    }

    /// Initializes the list with the given content that supports selecting multiple rows.
    /// Uses the native `SwiftUI` `List` as list view.
    ///
    /// - Parameters:
    ///   - listState: A value representing the state of the list, defaults to `items`.
    ///   - selection: A binding to a set that identifies selected rows.
    ///   - listContent: A view builder that creates the content of the list.
    ///   - errorStateView: A view builder that creates the view for the error state of the list.
    public init<ListContent: View, SelectionValue: Hashable>(listState: ListState = .items, selection: Binding<Set<SelectionValue>>?, @ViewBuilder listContent: @escaping () -> ListContent, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView) {
        self.type = .init(type: AdvancedListType<Never>.container(content: { AnyView(List(selection: selection, content: listContent)) }))
        self.listState = listState
        self.emptyStateView = { EmptyStateView() }
        self.errorStateView = errorStateView
        self.loadingStateView = { LoadingStateView() }
        configurations = []
    }
}

extension AdvancedList {
    @ViewBuilder public var body: some View {
        switch listState {
        case .items:
            switch type.value {
            case let .data(data, listView, _):
                if !data.isEmpty {
                    VStack {
                        if let rows = rows() {
                            listView({ rows })
                        }

                        if let pagination = pagination, isLastItem {
                            pagination.content()
                        }
                    }
                } else {
                    emptyStateView()
                }
            case let .container(content):
                content()
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
    /// `Attention`: Works only if you initialize an `AdvancedList` with a `RandomAccessCollection`.
    ///
    /// - Parameter action: A closure that SwiftUI invokes when elements in the dynamic view are moved. The closure takes two arguments that represent the offset relative to the dynamic view’s underlying collection of data.
    /// - Returns: An `AdvancedList` view that calls action when elements are moved within the original view.
    public func onMove(perform action: OnMoveAction) -> Self {
        configure { AnyDynamicViewContent($0.onMove(perform: action)) }
    }

    /// Sets the deletion action for the dynamic view.
    ///
    /// `Attention`: Works only if you initialize an `AdvancedList` with a `RandomAccessCollection`.
    ///
    /// - Parameter action: The action that you want SwiftUI to perform when elements in the view are deleted. SwiftUI passes a set of indices to the closure that’s relative to the dynamic view’s underlying collection of data.
    /// - Returns: An `AdvancedList` view that calls action when elements are deleted from the original view.
    public func onDelete(perform action: OnDeleteAction) -> Self {
        configure { AnyDynamicViewContent($0.onDelete(perform: action)) }
    }

    /// Adds pagination to the `AdvancedList`.
    ///
    /// `Attention`: Works only if you initialize an `AdvancedList` with a `RandomAccessCollection`.
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

    func rows() -> AnyDynamicViewContent? {
        switch type.value {
        case let .data(data, _, _):
            return configurations
                .reduce(
                    AnyDynamicViewContent(
                        ForEach(data) { item in
                            itemView(item)
                        }
                    )
                ) { (currentView, configuration) in configuration(currentView) }
        case .container:
            return nil
        }
    }

    @ViewBuilder
    func itemView(_ item: AnyIdentifiable) -> some View {
        switch type.value {
        case let .data(data, _, rowContent):
            rowContent(item)
            .onAppear {
                listItemAppears(item)

                if data.isLastItem(item) {
                    isLastItem = true
                }
            }
        case .container:
            EmptyView()
        }
    }

    func listItemAppears(_ item: AnyIdentifiable) {
        guard let pagination = pagination else {
            return
        }

        switch type.value {
        case let .data(data, _, _):
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
        case .container: ()
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
