//
//  ListContentExampleView.swift
//  AdvancedList-Example
//
//  Created by Christian Elies on 10/04/2022.
//  Copyright © 2022 Christian Elies. All rights reserved.
//

import AdvancedList
import SwiftUI

struct ListContentExampleView: View {
    @State private var listState: ListState = .items

    var body: some View {
        VStack(spacing: 16) {
            CustomListStateSegmentedControlView(
                items: .constant([]),
                listState: $listState,
                paginationState: .constant(.idle),
                shouldHideEmptyOption: true
            )

            AdvancedList(listState: listState, listContent: {
                Text("Example 1")
                Text("Example 2")
                Text("Example 3")
            }, errorStateView: { error in
                VStack(alignment: .leading) {
                    Text("Error").foregroundColor(.primary)
                    Text(error.localizedDescription).foregroundColor(.secondary)
                }
            }, loadingStateView: ProgressView.init)

            Spacer()
        }
        .navigationTitle("List content example")
    }
}

#if DEBUG
struct ListContentExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ListContentExampleView()
    }
}
#endif
