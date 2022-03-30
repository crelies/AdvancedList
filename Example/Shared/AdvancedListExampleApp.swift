//
//  AdvancedListExampleApp.swift
//  Shared
//
//  Created by Christian Elies on 03.08.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import AdvancedList
import SwiftUI

@main
struct AdvancedListExampleApp: App {
    private var navigationStyle: some NavigationViewStyle {
        #if os(iOS)
        return StackNavigationViewStyle()
        #else
        return DefaultNavigationViewStyle()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    NavigationLink("Data example", destination: DataExampleView())

                    if #available(iOS 15, *) {
                        NavigationLink("Content example", destination: ContentExampleView())
                    }
                }
                .navigationTitle("Examples")
            }
            .navigationViewStyle(navigationStyle)
        }
    }
}
