//
//  AdListItemView.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 12.12.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import SwiftUI

struct AdListItemView: View {
    @State private var isImageCollapsed: Bool = true
    
    let adListItem: AdListItem

    var body: some View {
        if adListItem.viewRepresentationType == .short {
            NavigationLink(destination: AdDetailView(text: adListItem.text), label: {
                Text(adListItem.text)
                    .lineLimit(1)
                Text("ℹ️")
            })
        } else if adListItem.viewRepresentationType == .long {
            Text(adListItem.text)
                .lineLimit(nil)
        } else if adListItem.viewRepresentationType == .image {
            VStack {
                if !isImageCollapsed {
                    Image("restaurant")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                }

                Button(action: {
                    self.isImageCollapsed.toggle()
                }) {
                    Text("\(isImageCollapsed ? "show" : "hide") image")
                }.foregroundColor(.blue)
            }
        }
    }
}

#if DEBUG
struct AdListItemView_Previews: PreviewProvider {
    static var previews: some View {
        AdListItemView(adListItem: AdListItem(id: "ID", text: "Text"))
    }
}
#endif
