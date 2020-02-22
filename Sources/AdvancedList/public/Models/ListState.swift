//
//  ListState.swift
//  AdvancedList
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

public enum ListState {
    case error(_ error: Error)
    case items
    case loading
}

extension ListState {
    var error: Error? {
        guard case let ListState.error(error) = self else {
            return nil
        }
        return error
    }
}

extension ListState: Equatable {
    public static func ==(lhs: ListState, rhs: ListState) -> Bool {
        switch (lhs, rhs) {
            case (.error(let lhsError), .error(let rhsError)):
                return (lhsError as NSError) == (rhsError as NSError)
            case (.items, .items):
                return true
            case (.loading, .loading):
                return true
            default:
                return false
        }
    }
}
