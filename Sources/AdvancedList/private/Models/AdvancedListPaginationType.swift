//
//  AdvancedListPaginationType.swift
//  
//
//  Created by Christian Elies on 16.08.19.
//

import Foundation

enum AdvancedListPaginationType {
    case lastItem
    case thresholdItem(offset: Int)
    case noPagination
}
