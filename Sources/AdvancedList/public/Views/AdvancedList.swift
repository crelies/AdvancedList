//
//  AdvancedList.swift
//  AdvancedList
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import ListPagination
import SwiftUI

public struct AdvancedList<EmptyStateView: View, ErrorStateView: View, LoadingStateView: View, PaginationLoadingView: View> : View {
    @ObservedObject private var listService: ListService
    private let emptyStateView: () -> EmptyStateView
    private let errorStateView: (Error) -> ErrorStateView
    private let loadingStateView: () -> LoadingStateView
    @ObservedObject private var pagination: AdvancedListPagination<PaginationLoadingView>
    
    public var body: AnyView {
        switch listService.listState {
            case .error(let error):
                return AnyView(
                    errorStateView(error)
                )
            case .items:
                if !listService.items.isEmpty {
                    return AnyView(
                        List(listService.items) { item in
                            VStack {
                                item
                                .onAppear {
                                    self.listItemAppears(item)
                                }
                                
                                if self.pagination.isLoading && self.listService.items.isLastItem(item) {
                                    self.pagination.loadingView()
                                }
                            }
                        }
                    )
                } else {
                    return AnyView(
                        emptyStateView()
                    )
                }
            case .loading:
                return AnyView(
                    loadingStateView()
                )
        }
    }
    
    public init(listService: ListService, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView, pagination: AdvancedListPagination<PaginationLoadingView>) {
        self.listService = listService
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        self.pagination = pagination
    }
}

extension AdvancedList {
    private func listItemAppears<Item: Identifiable>(_ item: Item) {
        switch pagination.type {
            case .lastItem:
                if listService.items.isLastItem(item) {
                    pagination.shouldLoadNextPage()
                }
            
            case .thresholdItem(let offset):
                if listService.items.isThresholdItem(offset: offset,
                                                     item: item) {
                    pagination.shouldLoadNextPage()
                }
            case .noPagination: ()
        }
    }
}

#if DEBUG
struct AdvancedList_Previews : PreviewProvider {
    private static let listService = ListService()
    
    static var previews: some View {
        NavigationView {
            AdvancedList(listService: listService, emptyStateView: {
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
            .navigationBarTitle(Text("List of Items"))
        }
    }
}
#endif
