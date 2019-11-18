//
//  AdvancedList2.swift
//  
//
//  Created by Christian Elies on 16.11.19.
//

import ListPagination
import SwiftUI

public struct AdvancedList2<Data: RandomAccessCollection, Content: View, EmptyStateView: View, ErrorStateView: View, LoadingStateView: View, PaginationErrorView: View, PaginationLoadingView: View> : View where Data.Element: Identifiable {
    @ObservedObject private var pagination: AdvancedListPagination<PaginationErrorView, PaginationLoadingView>
    private var data: Data
    private var content: (Data.Element) -> Content
    private let listState: Binding<ListState>
    private let emptyStateView: () -> EmptyStateView
    private let errorStateView: (Error) -> ErrorStateView
    private let loadingStateView: () -> LoadingStateView
    @State private var isLastItem: Bool = false
    private let supportedListActions: AdvancedListActions
    private var excludeItem: (Data.Element) -> Bool

    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content, listState: Binding<ListState>, supportedListActions: AdvancedListActions = .none, excludeItem: @escaping (Data.Element) -> Bool = { _ in false }, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView, pagination: AdvancedListPagination<PaginationErrorView, PaginationLoadingView>) {
        self.data = data
        self.content = content
        self.listState = listState
        self.supportedListActions = supportedListActions
        self.excludeItem = excludeItem
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        self.pagination = pagination
    }
}

extension AdvancedList2 {
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

extension AdvancedList2 {
    private func getListView() -> some View {
        switch supportedListActions {
        case .delete(let onDelete):
            return AnyView(List {
                ForEach(data) { item in
                    if !self.excludeItem(item) {
                        self.getItemView(item)
                    }
                }.onDelete { indexSet in
                    onDelete(indexSet)
                }
            })
        case .move(let onMove):
            return AnyView(List {
                ForEach(data) { item in
                    if !self.excludeItem(item) {
                        self.getItemView(item)
                    }
                }.onMove { (indexSet, index) in
                    onMove(indexSet, index)
                }
            })
        case .moveAndDelete(let onMove, let onDelete):
            return AnyView(List {
                ForEach(data) { item in
                    if !self.excludeItem(item) {
                        self.getItemView(item)
                    }
                }.onMove { (indexSet, index) in
                    onMove(indexSet, index)
                }.onDelete { indexSet in
                    onDelete(indexSet)
                }
            })
        case .none:
            return AnyView(List(data) { item in
                if !self.excludeItem(item) {
                    self.getItemView(item)
                }
            })
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
