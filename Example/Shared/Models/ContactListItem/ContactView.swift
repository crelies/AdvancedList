//
//  ContactView.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 13.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct ContactView : View {
    let firstName: String
    let lastName: String
    let hasMoreInformation: Bool
    
    var body: some View {
        HStack {
            Text("🕵️")
            Text(firstName)
            Text(lastName)
            if hasMoreInformation {
                Spacer()
                Text("ℹ️")
            }
        }
    }
}
