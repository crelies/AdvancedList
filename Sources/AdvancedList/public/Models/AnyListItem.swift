//
//  AnyListItem.swift
//  AdvancedList
//
//  Created by Christian Elies on 12.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation
import SwiftUI

public struct AnyListItem: Identifiable, View {
    public let id: AnyHashable
    public let body: AnyView
    
    public init<Item: Identifiable>(item: Item) where Item: View {
        id = item.id
        body = AnyView(item)
    }
}
