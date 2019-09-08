//
//  AdvancedListPagination.swift
//  
//
//  Created by Christian Elies on 15.08.19.
//

import Combine
import SwiftUI

public final class AdvancedListPagination<ErrorView: View, LoadingView: View>: NSObject, ObservableObject {
    let errorView: (Error) -> ErrorView
    let loadingView: () -> LoadingView
    let type: AdvancedListPaginationType
    let shouldLoadNextPage: () -> Void
    
    public let objectWillChange = PassthroughSubject<Void, Never>()
    
    public var state: AdvancedListPaginationState {
        didSet {
            objectWillChange.send()
        }
    }
    
    init(@ViewBuilder errorView: @escaping (Error) -> ErrorView, @ViewBuilder loadingView: @escaping () -> LoadingView, type: AdvancedListPaginationType, shouldLoadNextPage: @escaping () -> Void, state: AdvancedListPaginationState) {
        self.errorView = errorView
        self.loadingView = loadingView
        self.type = type
        self.shouldLoadNextPage = shouldLoadNextPage
        self.state = state
    }
}

extension AdvancedListPagination {
    public static func lastItemPagination(@ViewBuilder errorView: @escaping (Error) -> ErrorView, @ViewBuilder loadingView: @escaping () -> LoadingView, shouldLoadNextPage: @escaping () -> Void, state: AdvancedListPaginationState) -> AdvancedListPagination {
        AdvancedListPagination(errorView: errorView,
                               loadingView: loadingView,
                               type: .lastItem,
                               shouldLoadNextPage: shouldLoadNextPage,
                               state: state)
    }
    
    public static func thresholdItemPagination(@ViewBuilder errorView: @escaping (Error) -> ErrorView, @ViewBuilder loadingView: @escaping () -> LoadingView, offset: Int, shouldLoadNextPage: @escaping () -> Void, state: AdvancedListPaginationState) -> AdvancedListPagination {
        AdvancedListPagination(errorView: errorView,
                               loadingView: loadingView,
                               type: .thresholdItem(offset: offset),
                               shouldLoadNextPage: shouldLoadNextPage,
                               state: state)
    }
}

extension AdvancedListPagination where ErrorView == EmptyView, ErrorView == LoadingView {
    public static var noPagination: AdvancedListPagination {
        AdvancedListPagination(errorView: { _ in ErrorView() },
                               loadingView: { LoadingView() },
                               type: .noPagination,
                               shouldLoadNextPage: {},
                               state: .idle)
    }
}
