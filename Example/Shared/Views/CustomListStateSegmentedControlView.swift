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
    @Binding var items: [AnyIdentifiable]
    @Binding var listState: ListState
    @Binding var paginationState: AdvancedListPaginationState
    var shouldHideEmptyOption = false

    var body: some View {
        HStack {
            Button(action: {
                let items = ExampleDataProvider.randomItems()
                self.items.removeAll()
                self.items.append(contentsOf: items)

                listState = .items
                paginationState = .idle
            }) {
                Text("Items")
            }

            if !shouldHideEmptyOption {
                Button(action: {
                    items.removeAll()

                    listState = .items
                    paginationState = .idle
                }) {
                    Text("Empty")
                }
            }

            Button(action: {
                listState = .loading
                paginationState = .idle
            }) {
                Text("Loading")
            }

            Button(action: {
                listState = .error(ExampleError.allCases.randomElement()! as NSError)
                paginationState = .idle
            }) {
                Text("Error")
            }
        }
    }
}
