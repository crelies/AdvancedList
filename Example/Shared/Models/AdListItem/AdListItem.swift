//
//  AdListItem.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 01.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct AdListItem: Identifiable {
    let id: String
    let text: String

    var viewRepresentationType: AdListItemViewRepresentationType = .short
}
