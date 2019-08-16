//
//  AdvancedListPagination.swift
//  
//
//  Created by Christian Elies on 15.08.19.
//

import Combine
import SwiftUI

public final class AdvancedListPagination<LoadingView: View>: ObservableObject {
    let loadingView: () -> LoadingView
    let type: AdvancedListPaginationType
    let shouldLoadNextPage: () -> Void
    
    public let objectWillChange = PassthroughSubject<Void, Never>()
    
    public var isLoading: Bool {
        didSet {
            objectWillChange.send()
        }
    }
    
    init(@ViewBuilder loadingView: @escaping () -> LoadingView, type: AdvancedListPaginationType, shouldLoadNextPage: @escaping () -> Void, isLoading: Bool) {
        self.loadingView = loadingView
        self.type = type
        self.shouldLoadNextPage = shouldLoadNextPage
        self.isLoading = isLoading
    }
}

extension AdvancedListPagination {
    public static func lastItemPagination(@ViewBuilder loadingView: @escaping () -> LoadingView, shouldLoadNextPage: @escaping () -> Void, isLoading: Bool) -> AdvancedListPagination {
        AdvancedListPagination(loadingView: loadingView,
                               type: .lastItem,
                               shouldLoadNextPage: shouldLoadNextPage,
                               isLoading: isLoading)
    }
    
    public static func thresholdItemPagination(@ViewBuilder loadingView: @escaping () -> LoadingView, offset: Int, shouldLoadNextPage: @escaping () -> Void, isLoading: Bool) -> AdvancedListPagination {
        AdvancedListPagination(loadingView: loadingView,
                               type: .thresholdItem(offset: offset),
                               shouldLoadNextPage: shouldLoadNextPage,
                               isLoading: isLoading)
    }
}

extension AdvancedListPagination where LoadingView == EmptyView {
    public static var noPagination: AdvancedListPagination {
        AdvancedListPagination(loadingView: { LoadingView() },
                               type: .noPagination,
                               shouldLoadNextPage: {},
                               isLoading: false)
    }
}
