import SwiftUI

enum AdvancedListType<Element> {
    case data(data: AnyRandomAccessCollection<Element>, listView: (AdvancedList.Rows) -> AnyView, rowContent: (Element) -> AnyView)
    case container(content: () -> AnyView)
}

struct AnyAdvancedListType {
    let value: AdvancedListType<AnyIdentifiable>

    init<Element: Identifiable>(type: AdvancedListType<Element>) {
        switch type {
        case let .data(data, listView, rowContent):
            self.value = .data(
                data: AnyRandomAccessCollection(data.map(AnyIdentifiable.init)),
                listView: listView,
                rowContent: { rowContent($0.value as! Element) }
            )
        case let .container(content):
            self.value = .container(content: content)
        }
    }
}
