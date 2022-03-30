//
//  AnyDynamicViewContent.swift
//  AdvancedList
//
//  Created by Christian Elies on 20.11.19.
//

import SwiftUI

/// Type erased dynamic view content that generates views from an underlying collection of data.
public struct AnyDynamicViewContent: DynamicViewContent {
    private let view: AnyView

    public let data: AnyCollection<Any>

    public var body: some View { view }

    init<View: DynamicViewContent>(_ view: View) {
        self.view = AnyView(view)
        self.data = AnyCollection(view.data.map { $0 as Any })
    }
}
