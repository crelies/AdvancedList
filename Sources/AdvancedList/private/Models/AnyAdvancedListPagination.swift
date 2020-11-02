//
//  AnyAdvancedListPagination.swift
//  AdvancedList
//
//  Created by Christian Elies on 31.07.20.
//

import SwiftUI

struct AnyAdvancedListPagination {
    let type: AdvancedListPaginationType
    let shouldLoadNextPage: () -> Void
    let content: () -> AnyView

    init<Content: View>(_ pagination: AdvancedListPagination<Content>) {
        type = pagination.type
        shouldLoadNextPage = pagination.shouldLoadNextPage
        content = { AnyView(pagination.content()) }
    }
}
