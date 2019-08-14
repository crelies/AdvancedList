//
//  ListService.swift
//  AdvancedList
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

public final class ListService: ObservableObject {
    public let objectWillChange = PassthroughSubject<Void, Never>()
    
    public private(set) var items: [AnyListItem] = [] {
        didSet {
            objectWillChange.send()
        }
    }
    
    public var listState: ListState = .items {
        didSet {
            objectWillChange.send()
        }
    }
    
    public init() {}
    
    public func appendItems<Item: Identifiable>(_ items: [Item]) where Item: View {
        let anyListItems = items.map { AnyListItem(item: $0) }
        self.items.append(contentsOf: anyListItems)
    }
    
    public func updateItems<Item: Identifiable>(_ items: [Item]) where Item: View {
        let anyListItems = items.map { AnyListItem(item: $0) }
        for anyListItem in anyListItems {
            guard let itemIndex = self.items.firstIndex(where: { $0.id == anyListItem.id }) else {
                continue
            }
            
            self.items[itemIndex] = anyListItem
        }
    }
    
    public func removeItems<Item: Identifiable>(_ items: [Item]) where Item: View {
        let anyListItemsToRemove = items.map { AnyListItem(item: $0) }
        self.items.removeAll(where: { item in
             return anyListItemsToRemove.contains { item.id == $0.id }
        })
    }
    
    public func removeAllItems() {
        items.removeAll()
    }
}
