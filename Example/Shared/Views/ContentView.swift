//
//  ContentView.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import AdvancedList
import SwiftUI

struct ContentView: View {
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

    private var navigationStyle: some NavigationViewStyle {
        #if os(iOS)
        return StackNavigationViewStyle()
        #else
        return DefaultNavigationViewStyle()
        #endif
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    CustomListStateSegmentedControlView(
                        listState: $listState,
                        items: $items
                    )
                    
                    let advancedList = AdvancedList(items, content: { item in
                        view(for: item)
                    }, listState: listState, emptyStateView: {
                        Text("No data")
                    }, errorStateView: { error in
                        Text("\(error.localizedDescription)").lineLimit(nil)
                    }, loadingStateView: {
                        if #available(iOS 14, *) {
                            ProgressView()
                        } else {
                            Text("Loading ...")
                        }
                    })
                    .pagination(.init(type: .lastItem, shouldLoadNextPage: loadNextItems) {
                        switch paginationState {
                        case .idle:
                            EmptyView()
                        case .loading:
                            HStack {
                                Spacer()

                                if #available(iOS 14, *) {
                                    ProgressView()
                                } else {
                                    Text("Loading ...")
                                }

                                Spacer()
                            }
                            .padding()
                            .background(backgroundColor)
                            .cornerRadius(16)
                            .padding(.horizontal)

                        case let .error(error):
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
                    })

                    if #available(iOS 15, macOS 12, tvOS 15, *) {
                        advancedList
                        .refreshable {
                            let duration = UInt64(3 * 1_000_000_000)
                            try? await Task<Never, Never>.sleep(nanoseconds: duration)

                            Task(priority: .userInitiated) {
                                listState = .items

                                let items = ExampleDataProvider.randomItems()
                                self.items.removeAll()
                                self.items.append(contentsOf: items)
                            }
                        }
                        .frame(width: geometry.size.width)
                    } else {
                        advancedList.frame(width: geometry.size.width)
                    }
                }
                .navigationTitle(Text("List of Items"))
            }
        }.navigationViewStyle(navigationStyle)
    }
}

private extension ContentView {
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
        ContentView()
    }
}
#endif
