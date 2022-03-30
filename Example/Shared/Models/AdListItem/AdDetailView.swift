//
//  AdDetailView.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 12.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct AdDetailView : View {
    let text: String
    
    var body: some View {
        Text(text)
            .lineLimit(nil)
            .padding()
    }
}
