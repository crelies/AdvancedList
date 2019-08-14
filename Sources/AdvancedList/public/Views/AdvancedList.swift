//
//  AdvancedList.swift
//  AdvancedList
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

public struct AdvancedList<EmptyStateView: View, ErrorStateView: View, LoadingStateView: View> : View {
    @ObservedObject private var listService: ListService
    private let emptyStateView: () -> EmptyStateView
    private let errorStateView: (Error?) -> ErrorStateView
    private let loadingStateView: () -> LoadingStateView
    
    public var body: some View {
        return Group {
            if listService.listState.error != nil {
                errorStateView(listService.listState.error)
            } else if listService.listState == .items {
                if !listService.items.isEmpty {
                    List(listService.items, id: \.id) { item in
                        item
                    }
                } else {
                    emptyStateView()
                }
            } else if listService.listState == .loading {
                loadingStateView()
            } else {
                EmptyView()
            }
        }
    }
    
    public init(listService: ListService, @ViewBuilder emptyStateView: @escaping () -> EmptyStateView, @ViewBuilder errorStateView: @escaping (Error?) -> ErrorStateView, @ViewBuilder loadingStateView: @escaping () -> LoadingStateView) {
        self.listService = listService
        self.emptyStateView = emptyStateView
        self.errorStateView = errorStateView
        self.loadingStateView = loadingStateView
    }
}

#if DEBUG
struct AdvancedList_Previews : PreviewProvider {
    private static let listService = ListService()
    
    static var previews: some View {
        return NavigationView {
            AdvancedList(listService: listService, emptyStateView: {
                Text("No data")
            }, errorStateView: { error in
                VStack {
                    Text(error?.localizedDescription ?? "Error")
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
            .navigationBarTitle(Text("List of Items"))
        }
    }
}
#endif
