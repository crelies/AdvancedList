//
//  DataExampleView.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import AdvancedList
import SwiftUI

struct DataExampleView: View {
    @State private var items = ExampleDataProvider.randomItems()
    @State private var listState: ListState = .items
    @State private var paginationState: AdvancedListPaginationState = .idle

    private var backgroundColor: Color? {
        #if os(iOS)
        return Color(.secondarySystemBackground)
        #else
        return nil
        #endif
    }

    var body: some View {
        VStack(spacing: 16) {
            CustomListStateSegmentedControlView(
                items: $items,
                listState: $listState,
                paginationState: $paginationState
            )

            list()

            Spacer()
        }
        .navigationTitle("Data example")
    }
}

private extension DataExampleView {
    @ViewBuilder
    func list() -> some View {
        let advancedList = AdvancedList(items, content: { item in
            view(for: item)
        }, listState: listState, emptyStateView: {
            Text("No data")
        }, errorStateView: { error in
            Text("\(error.localizedDescription)").lineLimit(nil)
        }, loadingStateView: {
            ProgressView()
        })
        .pagination(.init(type: .lastItem, shouldLoadNextPage: loadNextItems) {
            switch paginationState {
            case .idle:
                EmptyView()
            case .loading:
                paginationLoadingStateView()
            case let .error(error):
                paginationErrorStateView(error)
            }
        })

        if #available(tvOS 15, *) {
            advancedList
            .refreshable(action: refresh)
        } else {
            advancedList
        }
    }

    func paginationLoadingStateView() -> some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(16)
        .padding(.horizontal)
    }

    func paginationErrorStateView(_ error: Error) -> some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)

                Button(action: {
                    loadNextItems()
                }) {
                    Text("Retry")
                }
            }
            Spacer()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(16)
        .padding(.horizontal)
    }

    @Sendable
    func refresh() async {
        listState = .loading

        Task(priority: .userInitiated) {
            let duration = UInt64(1.5 * 1_000_000_000)
            try? await Task<Never, Never>.sleep(nanoseconds: duration)

            let items = ExampleDataProvider.randomItems()
            self.items.removeAll()
            self.items.append(contentsOf: items)

            listState = .items
            paginationState = .idle
        }
    }
}

private extension DataExampleView {
    @ViewBuilder func view(for identifiable: AnyIdentifiable) -> some View {
        if let contactListItem = identifiable.value as? ContactListItem {
            ContactListItemView(contactListItem: contactListItem)
        } else if let adListItem = identifiable.value as? AdListItem {
            AdListItemView(adListItem: adListItem)
        } else {
            EmptyView()
        }
    }

    func loadNextItems() {
        guard paginationState != .loading else {
            return
        }

        paginationState = .loading

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if Bool.random() {
                items.append(contentsOf: ExampleDataProvider.randomItems())
                paginationState = .idle
            } else {
                paginationState = .error(ExampleError.requestTimedOut as NSError)
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        DataExampleView()
    }
}
#endif
