//
//  CustomListStateSegmentedControlView.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 11.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import AdvancedList
import SwiftUI

struct CustomListStateSegmentedControlView : View {
    @Binding var listState: ListState
    @Binding var items: [AnyIdentifiable]

    var body: some View {
        HStack {
            Button(action: {
                self.listState = .items

                let items = ExampleDataProvider.randomItems()
                self.items.removeAll()
                self.items.append(contentsOf: items)
            }) {
                Text("Items")
            }

            Button(action: {
                self.items.removeAll()
                self.listState = .items
            }) {
                Text("Empty")
            }

            Button(action: {
                self.listState = .loading
            }) {
                Text("Loading")
            }

            Button(action: {
                self.listState = .error(ExampleError.allCases.randomElement()! as NSError)
            }) {
                Text("Error")
            }
        }
    }
}
