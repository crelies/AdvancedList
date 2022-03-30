//
//  ExampleDataProvider.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 11.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import AdvancedList
import SwiftUI

final class ExampleDataProvider {
    static func randomItems() -> [AnyIdentifiable] {
        let itemCount = Array(5...15).randomElement()!
        let items: [AnyIdentifiable] = Array(0...itemCount).map { _ in
            if Bool.random() {
                let id = UUID().uuidString
                let firstName = "Max"
                let lastName = "Mustermann"
                let streetAddress = "Schlossallee 19"
                let zip = "20097"
                let city = "Hamburg"
                let viewRepresentationType = ContactListItemViewRepresentationType.allCases.randomElement()!
                let itemModel = ContactListItem(id: id,
                                                firstName: firstName,
                                                lastName: lastName,
                                                streetAddress: streetAddress,
                                                zip: zip,
                                                city: city,
                                                viewRepresentationType: viewRepresentationType)
                return AnyIdentifiable(itemModel)
            } else {
                let id = UUID().uuidString
                let text = "⚠️ This is a really long and annoying advertisement I want to get rid off. Everyone knows that it's hard to hide from ads. They always find us ☢️!"
                let viewRepresentationType = AdListItemViewRepresentationType.allCases.randomElement()!
                let itemModel = AdListItem(id: id,
                                           text: text,
                                           viewRepresentationType: viewRepresentationType)
                return AnyIdentifiable(itemModel)
            }
        }
        return items
    }
}
