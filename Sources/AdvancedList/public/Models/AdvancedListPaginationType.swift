//
//  AdvancedListPaginationType.swift
//  AdvancedList
//
//  Created by Christian Elies on 16.08.19.
//

/// Specifies the different pagination types.
public enum AdvancedListPaginationType {
    /// Notifies the pagination configuration object when the last item in the list was reached.
    case lastItem
    /// Notifies the pagination configuration object when the given offset was passed.
    case thresholdItem(offset: Int)
}
