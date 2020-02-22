//
//  AnyDynamicViewContent.swift
//  
//
//  Created by Christian Elies on 20.11.19.
//

import SwiftUI

struct AnyDynamicViewContent: DynamicViewContent {
    private let view: AnyView

    private(set) var data: AnyCollection<Any>
    var body: some View { view }

    init<View: DynamicViewContent>(_ view: View) {
        self.view = AnyView(view)
        self.data = AnyCollection(view.data.map { $0 as Any })
    }
}
