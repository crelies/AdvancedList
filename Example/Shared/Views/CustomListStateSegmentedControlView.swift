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
    let listState: Binding<ListState>
    let items: Binding<[AnyIdentifiable]>
    
    var body: some View {
        HStack {
            Button(action: {
                self.listState.wrappedValue = .items
                
                let items = ExampleDataProvider.randomItems()
                self.items.wrappedValue.removeAll()
                self.items.wrappedValue.append(contentsOf: items)
            }) {
                Text("Items")
            }
            
            Button(action: {
                self.items.wrappedValue.removeAll()
                self.listState.wrappedValue = .items
            }) {
                Text("Empty")
            }
            
            Button(action: {
                self.listState.wrappedValue = .loading
            }) {
                Text("Loading")
            }
            
            Button(action: {
                self.listState.wrappedValue = .error(ExampleError.allCases.randomElement()! as NSError)
            }) {
                Text("Error")
            }
        }
    }
}
