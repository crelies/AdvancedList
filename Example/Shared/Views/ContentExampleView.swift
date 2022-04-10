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
    @State private var listState: ListState = .items

    var body: some View {
        VStack(spacing: 16) {
            CustomListStateSegmentedControlView(
                items: .constant([]),
                listState: $listState,
                paginationState: .constant(.idle)
            )

            AdvancedList(listState: listState) {
                Text("Example 1")
                Text("Example 2")
                Text("Example 3")
            } errorStateView: { error in
                VStack(alignment: .leading) {
                    Text("Error").foregroundColor(.primary)
                    Text(error.localizedDescription).foregroundColor(.secondary)
                }
            } loadingStateView: {
                ProgressView()
            }

            Spacer()
        }
        .navigationTitle("Content example")
    }
}

#if DEBUG
struct ContentExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ContentExampleView()
    }
}
#endif
