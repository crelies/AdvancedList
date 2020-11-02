//
//  AdvancedListPagination.swift
//  AdvancedList
//
//  Created by Christian Elies on 15.08.19.
//

import SwiftUI

/// Represents the pagination configuration.
public struct AdvancedListPagination<Content: View> {
    let type: AdvancedListPaginationType
    let shouldLoadNextPage: () -> Void
    let content: () -> Content

    /// Initializes the pagination configuration with the given values.
    ///
    /// - Parameters:
    ///   - type: The type of the pagination, choose between `lastItem` or `thresholdItem`.
    ///   - shouldLoadNextPage: A closure that is called everytime the end of a page is reached.
    ///   - content: A closure providing a `View` which should be displayed at the end of a page.
    public init(
        type: AdvancedListPaginationType,
        shouldLoadNextPage: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.type = type
        self.shouldLoadNextPage = shouldLoadNextPage
        self.content = content
    }
}
