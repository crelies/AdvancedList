//
//  AnyIdentifiable.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 12.12.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

struct AnyIdentifiable: Identifiable {
    let id: AnyHashable
    let value: Any

    init<T: Identifiable>(_ identifiable: T) {
        self.id = AnyHashable(identifiable.id)
        self.value = identifiable
    }
}
