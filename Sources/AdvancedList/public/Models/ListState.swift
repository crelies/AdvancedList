//
//  ListState.swift
//  AdvancedList
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

public enum ListState {
    case error(_ error: Error?)
    case items
    case loading
}

extension ListState: Equatable {
    public static func ==(lhs: ListState, rhs: ListState) -> Bool {
        switch (lhs, rhs) {
            case (.error(let lhsError), .error(let rhsError)):
                if let lhsError = lhsError, let rhsError = rhsError {
                    return (lhsError as NSError) == (rhsError as NSError)
                } else if lhsError == nil && rhsError == nil {
                    return true
                } else {
                    return false
                }
            case (.items, .items):
                return true
            case (.loading, .loading):
                return true
            default:
                return false
        }
    }
}
