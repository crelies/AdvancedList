//
//  ContactDetailView.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 13.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct ContactDetailView : View {
    let listItem: ContactListItem
    
    var body: some View {
        VStack {
            HStack {
                Text("🕵️")
                Text(listItem.firstName)
                Text(listItem.lastName)
            }
            Text(listItem.streetAddress)
            HStack {
                Text(listItem.zip)
                Text(listItem.city)
            }
        }
    }
}
