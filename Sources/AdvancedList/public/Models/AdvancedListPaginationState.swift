//
//  AdvancedListPaginationState.swift
//  AdvancedList
//
//  Created by Christian Elies on 17.08.19.
//

import Foundation

/// Represents the different states of a pagination.
public enum AdvancedListPaginationState: Equatable {
    /// The error state; use this state if an error occurs while loading a page.
    case error(_ error: NSError)
    /// The idle state; use this state if no page loading is in progress.
    case idle
    /// The loading state; use this state if a page is loaded.
    case loading
}
