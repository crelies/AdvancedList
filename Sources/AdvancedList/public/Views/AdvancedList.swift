//
//  AdvancedList.swift
//  AdvancedList
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import ListPagination
import SwiftUI

public struct AdvancedList<Data: RandomAccessCollection, Content: View, EmptyStateView: View, ErrorStateView: View, LoadingStateView: View, PaginationErrorView: View, PaginationLoadingView: View> : View where Data.Element: Identifiable {
    public typealias OnMoveAction = Optional<(IndexSet, Int) -> Void>
    public typealias OnDeleteAction = Optional<(IndexSet) -> Void>

    @ObservedObject private var pagination: AdvancedListPagination<PaginationErrorView, PaginationLoadingView>
    private var data: Data
    private var content: (Data.Element) -> Content
    private var listState: Binding<ListState>
    private var onMoveAction: OnMoveAction = nil
    private var onDeleteAction: OnDeleteAction = nil
    private let emptyStateView: () -> EmptyStateView
    private let errorStateView: (Error) -> ErrorStateView
    private let loadingStateView: () -> LoadingStateView
    @State private var isLastItem: Bool = false

    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content, listState: Binding<ListState>, onMoveAction: OnMoveAction = nil, onDeleteAction: OnDeleteAction = nil, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView, pagination: AdvancedListPagination<PaginationErrorView, PaginationLoadingView>) {
        self.data = data
        self.content = content
        self.listState = listState
        self.onMoveAction = onMoveAction
        self.onDeleteAction = onDeleteAction
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        self.pagination = pagination
    }
}

extension AdvancedList {
    public var body: some View {
        switch listState.wrappedValue {
        case .error(let error):
            return AnyView(errorStateView(error))
        case .items:
            if !data.isEmpty {
                return AnyView(
                    VStack {
                        getListView()

                        if isLastItem {
                            getPaginationStateView()
                        }
                    }
                )
            } else {
                return AnyView(emptyStateView())
            }
        case .loading:
            return AnyView(loadingStateView())
        }
    }
}

extension AdvancedList {
    private func getListView() -> some View {
        List {
            ForEach(data) { item in
                self.getItemView(item)
            }.onMove(perform: self.onMoveAction)
            .onDelete(perform: self.onDeleteAction)
        }
    }

    private func getItemView(_ item: Data.Element) -> some View {
        content(item)
        .onAppear {
            self.listItemAppears(item)

            if self.data.isLastItem(item) {
                self.isLastItem = true
            }
        }
    }

    private func listItemAppears(_ item: Data.Element) {
        switch pagination.type {
        case .lastItem:
            if data.isLastItem(item) {
                pagination.shouldLoadNextPage()
            }

        case .thresholdItem(let offset):
            if data.isThresholdItem(offset: offset,
                                    item: item) {
                pagination.shouldLoadNextPage()
            }
        case .noPagination: ()
        }
    }

    private func getPaginationStateView() -> some View {
        var paginationStateView = AnyView(EmptyView())

        switch pagination.state {
        case .error(let error):
            paginationStateView = AnyView(pagination.errorView(error))
        case .idle:
            paginationStateView = AnyView(EmptyView())
        case .loading:
            paginationStateView = AnyView(pagination.loadingView())
        }

        return paginationStateView
    }
}

#if DEBUG
struct AdvancedList_Previews : PreviewProvider {
    private struct MockItem: Identifiable {
        let id: String = UUID().uuidString
    }

    private static let items: [MockItem] = []
    @State private static var listState: ListState = .items

    static var previews: some View {
        NavigationView {
            AdvancedList(items, content: { element in
                Text(element.id)
            }, listState: $listState, emptyStateView: {
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
            }, pagination: .noPagination)
        }
    }
}
#endif
