//
//  ContactListItemView.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 12.12.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct ContactListItemView: View {
    @State private var collapsed: Bool = true

    let contactListItem: ContactListItem

    var body: some View {
        if contactListItem.viewRepresentationType == .short {
            ContactView(firstName: contactListItem.firstName,
                        lastName: contactListItem.lastName,
                        hasMoreInformation: false)
        } else if contactListItem.viewRepresentationType == .detail {
            NavigationLink(destination: ContactDetailView(listItem: contactListItem), label: {
                ContactView(firstName: contactListItem.firstName,
                            lastName: contactListItem.lastName,
                            hasMoreInformation: true)
            })
        } else if contactListItem.viewRepresentationType == .collapsable {
            VStack {
                if collapsed {
                    ContactView(firstName: contactListItem.firstName,
                                lastName: contactListItem.lastName,
                                hasMoreInformation: false)
                } else {
                    ContactDetailView(listItem: contactListItem)
                }

                Button(action: {
                    self.collapsed.toggle()
                }) {
                    Text("\(collapsed ? "show" : "hide") details")
                }.foregroundColor(.blue)
            }
        }
    }
}

#if DEBUG
struct ContactListOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListItemView(contactListItem: ContactListItem(id: "ID",
                                                             firstName: "Max",
                                                             lastName: "Example",
                                                             streetAddress: "Awesome street 5",
                                                             zip: "20097",
                                                             city: "Hamburg"))
    }
}
#endif
