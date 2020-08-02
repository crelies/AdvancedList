//
//  ListState.swift
//  AdvancedList
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

/// Specifies the different states of an `AdvancedList`.
public enum ListState: Equatable {
    /// The `error` state; displays the error view instead of the list to the user.
    case error(_ error: NSError)
    /// The `items` state (`default`); displays the items or the empty state view (if there are no items) to the user.
    case items
    /// The `loading` state; displays the loading state view instead of the list to the user.
    case loading
}
