# AdvancedList

[![Swift5](https://img.shields.io/badge/swift5-compatible-green.svg?longCache=true&style=flat-square)](https://developer.apple.com/swift)
[![Platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS-lightgrey.svg?longCache=true&style=flat-square)](https://www.apple.com)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?longCache=true&style=flat-square)](https://en.wikipedia.org/wiki/MIT_License)

This package provides a wrapper view around the **SwiftUI** `List view` which adds **pagination** (through my [ListPagination package](https://github.com/crelies/ListPagination)) and an **empty**, **error** and **loading state** including a corresponding view.

## 📦 Installation

Add this Swift package in Xcode using its Github repository url. (File > Swift Packages > Add Package Dependency...)

## 🚀 How to use

You control the view through an instance of `ListService`. The service manages the current state and the items of the list.
Use it to append, update or remove items and to modify the state of the list. The view listens to the service and updates itself if needed.

### 📄 Pagination

The `Pagination` is implemented as a class (conforming to `ObservableObject`) so the `AdvancedList` can observe it.
It has three different states: `error`, `idle` and `loading`. If the `state` of the `Pagination` changes the `AdvancedList` updates itself to show or hide the state related view (`ErrorView` for state `.error(Error)` or `LoadingView` for state `.loading`, `.idle` will display nothing). Update the `state` if you start loading (`.loading`), stop loading ( `.idle`) or if an error occurred (`.error(Error)`) so the `AdvancedList` can render the appropriate view.

If you want to use pagination you can choose between the `lastItemPagination` and the `thresholdItemPagination`. Both concepts are described [here](https://github.com/crelies/ListPagination). Just pass `.lastItemPagination` or `.thresholdItemPagination` including the required parameters to the `AdvancedList` initializer.

Both pagination types require

- an **ErrorView** and a **LoadingView** (**ViewBuilder**)
- a block (**shouldLoadNextPage**) which is called if the `last or threshold item appeared` and
- the initial state (**AdvancedListPaginationState**) of the pagination which determines the visibility of the pagination state related view.

The `thresholdItemPagination` expects an offset parameter (number of items before the last item) to determine the threshold item.

**The ErrorView or LoadingView will only be visible below the List if the last item of the List appeared! That way the user is only interrupted if needed.**

**Skip pagination setup by using `.noPagination`.**

### 📁 Move and 🗑️ delete items

You can define which actions your list should support through the `supportedListActions` property of your `ListService` instance.
Choose between `delete`, `move`, `moveAndDelete` and `none`. The default is `none`.

### 🎛️ Filtering

The `AdvancedList` supports filtering (disabled by default). You only have to set the closure `excludeItem: (AnyListItem) -> Bool)` on your `ListService` instance.
`AnyListItem` gives you access to the item (`Any`). **Keep in mind that you have to cast this item to your custom type!**

## 🎁 Example

The following code shows how easy-to-use the view is:

```swift
let listService = ListService()

AdvancedList(listService: listService, emptyStateView: {
    Text("No data")
}, errorStateView: { error in
    VStack {
        Text(error.localizedDescription)
            .lineLimit(nil)
        
        Button(action: {
            // do something
        }) {
            Text("Retry")
        }
    }
}, loadingStateView: {
    Text("Loading ...")
}, pagination: .noPagination)
```
