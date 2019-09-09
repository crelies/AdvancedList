//
//  AdvancedList.swift
//  AdvancedList
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import ListPagination
import SwiftUI

public struct AdvancedList<EmptyStateView: View, ErrorStateView: View, LoadingStateView: View, PaginationErrorView: View, PaginationLoadingView: View> : View {
    #if !targetEnvironment(macCatalyst)
    @ObservedObject private var listService: ListService
    @ObservedObject private var pagination: AdvancedListPagination<PaginationErrorView, PaginationLoadingView>
    #endif
    
    private let emptyStateView: () -> EmptyStateView
    private let errorStateView: (Error) -> ErrorStateView
    private let loadingStateView: () -> LoadingStateView
    @State private var isLastItem: Bool = false
    
    #if targetEnvironment(macCatalyst)
    @EnvironmentObject var listService: ListService
    @EnvironmentObject var pagination: AdvancedListPagination<PaginationErrorView, PaginationLoadingView>
    #endif
    
    public var body: AnyView {
        switch listService.listState {
            case .error(let error):
                return AnyView(
                    errorStateView(error)
                )
            case .items:
                if !listService.items.isEmpty {
                    return AnyView(
                        VStack {
                            List(listService.items) { item in
                                item
                                .onAppear {
                                    self.listItemAppears(item)
                                    
                                    if self.listService.items.isLastItem(item) {
                                        self.isLastItem = true
                                    }
                                }
                            }
                            
                            if isLastItem {
                                getPaginationStateView()
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
    
    #if !targetEnvironment(macCatalyst)
    public init(listService: ListService, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView, pagination: AdvancedListPagination<PaginationErrorView, PaginationLoadingView>) {
        self.listService = listService
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        self.pagination = pagination
    }
    #endif
    
    #if targetEnvironment(macCatalyst)
    public init(@ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
        self.pagination = pagination
    }
    #endif
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
    
    private func getPaginationStateView() -> AnyView {
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
            // TODO: why is this modifier not working on macOS?
//            .navigationBarTitle(Text("List of Items"))
        }
    }
}
#endif
