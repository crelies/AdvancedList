# AdvancedList

[![Swift5](https://img.shields.io/badge/swift5-compatible-green.svg?longCache=true&style=flat-square)](https://developer.apple.com/swift)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg?longCache=true&style=flat-square)](https://www.apple.com/de/ios)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?longCache=true&style=flat-square)](https://en.wikipedia.org/wiki/MIT_License)

This package provides a wrapper view around the **SwiftUI** `List view` which adds **pagination** (through my [ListPagination package](https://github.com/crelies/ListPagination)) and an **empty**, **error** and **loading state** including a corresponding view.

## Installation

Add this Swift package in Xcode using its Github repository url. (File > Swift Packages > Add Package Dependency...)

## How to use

You control the view through an instance of `ListService`. The service manages the current state and the items of the list.
Use it to append, update or remove items and to modify the state of the list. The view listens to the service and updates itself if needed.

### Pagination

The `Pagination` is implemented as a class (conforming to `ObservableObject`) so the `AdvancedList` can observe it. If the `isLoading` property of the `Pagination` changes the `AdvancedList` updates itself to show or hide the `LoadingView`. Update the `isLoading` property everytime you start or stop fetching the next page.

If you want to use pagination you can choose between the `lastItemPagination` and the `thresholdItemPagination`. Both concepts are described [here](https://github.com/crelies/ListPagination). Just pass `.lastItemPagination` or `.thresholdItemPagination` including the required parameters to the `AdvancedList` initializer.

Both pagination types require

- a **LoadingView** (**ViewBuilder**)
- a block (**shouldLoadNextPage**) which is called if the `last or threshold item appeared` and
- the initial loading state (**Bool**) of the pagination which determines the visibility of the **LoadingView**.

The `thresholdItemPagination` expects an offset parameter (number of items before the last item) to determine the threshold item.

**The `LoadingView` is only displayed right below the last item of the list if the `isLoading` property of the `Pagination` is true.**

**Skip pagination setup by using `.noPagination`.**

## Example

The following code shows how easy-to-use the view is:

```swift
let listService = ListService()

AdvancedList(listService: listService, emptyStateView: {
    Text("No data")
}, errorStateView: { error in
    VStack {
        Text(error?.localizedDescription ?? "Error")
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
