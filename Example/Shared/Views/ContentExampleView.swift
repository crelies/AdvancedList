//
//  ContentExampleView.swift
//  AdvancedList-Example
//
//  Created by Christian Elies on 30/03/2022.
//  Copyright © 2022 Christian Elies. All rights reserved.
//

import AdvancedList
import SwiftUI

struct ContentExampleView: View {
    var body: some View {
        if #available(iOS 15, *) {
            AdvancedList(listState: .items) {
                Text("Example 1")
                Text("Example 2")
                Text("Example 3")
            } emptyStateView: {
                Text("Empty")
            } errorStateView: { error in
                VStack(alignment: .leading) {
                    Text("Error").foregroundColor(.primary)
                    Text(error.localizedDescription).foregroundColor(.secondary)
                }
            } loadingStateView: {
                ProgressView()
            }
            .navigationTitle("Content example")
        }
    }
}

#if DEBUG
struct ContentExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ContentExampleView()
    }
}
#endif
