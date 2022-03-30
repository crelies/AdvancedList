//
//  ContactListItem.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct ContactListItem: Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let streetAddress: String
    let zip: String
    let city: String

    var viewRepresentationType: ContactListItemViewRepresentationType = .short
}
