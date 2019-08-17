//
//  AdvancedListPaginationState.swift
//  
//
//  Created by Christian Elies on 17.08.19.
//

import Foundation

public enum AdvancedListPaginationState {
    case error(_ error: Error)
    case idle
    case loading
}

extension AdvancedListPaginationState: Equatable {
    public static func ==(lhs: AdvancedListPaginationState,
                          rhs: AdvancedListPaginationState) -> Bool {
        switch (lhs, rhs) {
            case (.error(let lhsError), .error(let rhsError)):
                return (lhsError as NSError) == (rhsError as NSError)
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            default:
                return false
        }
    }
}
