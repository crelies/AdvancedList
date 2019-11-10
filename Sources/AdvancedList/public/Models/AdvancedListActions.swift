//
//  AdvancedListActions.swift
//  
//
//  Created by Christian Elies on 09.11.19.
//

import Foundation

public enum AdvancedListActions {
    case delete(onDelete: (IndexSet) -> Void)
    case move(onMove: (IndexSet, Int) -> Void)
    case moveAndDelete(onMove: (IndexSet, Int) -> Void, onDelete: (IndexSet) -> Void)
    case none
}
