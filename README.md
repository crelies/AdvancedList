# AdvancedList

[![Swift5](https://img.shields.io/badge/swift5-compatible-green.svg?longCache=true&style=flat-square)](https://developer.apple.com/swift)
[![Platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS-lightgrey.svg?longCache=true&style=flat-square)](https://www.apple.com)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?longCache=true&style=flat-square)](https://en.wikipedia.org/wiki/MIT_License)

This package provides a wrapper view around the **SwiftUI** `List view` which adds **pagination** (through my [ListPagination package](https://github.com/crelies/ListPagination)) and an **empty**, **error** and **loading state** including a corresponding view.

## 📦 Installation

Add this Swift package in Xcode using its Github repository url. (File > Swift Packages > Add Package Dependency...)

## 🚀 How to use

The `AdvancedList` view is similar to the `List` and `ForEach` views. You have to pass data (`RandomAccessCollection`) and a view provider (`(Data.Element) -> some View`) to the initializer. In addition to the `List` view the `AdvancedList` expects a list state and corresponding views.
Modify your data anytime or hide an item through the content block if you like. The view is updated automatically 🎉.

```swift
import AdvancedList

@State private var listState: ListState = .items

AdvancedList(yourData, content: { item in
    Text("Item")
}, listState: $listState, emptyStateView: {
    Text("No data")
}, errorStateView: { error in
    Text(error.localizedDescription)
        .lineLimit(nil)
}, loadingStateView: {
    Text("Loading ...")
}, pagination: .noPagination)
```

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

**Example:**

```swift
private(set) lazy var pagination: AdvancedListPagination<AnyView, AnyView> = {
    .thresholdItemPagination(errorView: { error in
        AnyView(
            VStack {
                Text(error.localizedDescription)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    // load current page again
                }) {
                    Text("Retry")
                }.padding()
            }
        )
    }, loadingView: {
        AnyView(
            VStack {
                Divider()
                Text("Loading...")
            }
        )
    }, offset: 25, shouldLoadNextPage: {
        // load next page
    }, state: .idle)
}()
```

### 📁 Move and 🗑️ delete items

You can define which actions your list should support through the `onMoveAction` and `onDeleteAction` initializer parameters.
**Per default the move and delete function is disabled.**

```swift
import AdvancedList

@State private var listState: ListState = .items

AdvancedList(yourData, content: { item in
    Text("Item")
}, listState: $listState, onMoveAction: { (indexSet, index) in
    // do something
}, onDeleteAction: { indexSet in
    // do something
}, emptyStateView: {
    Text("No data")
}, errorStateView: { error in
    Text(error.localizedDescription)
        .lineLimit(nil)
}, loadingStateView: {
    Text("Loading ...")
}, pagination: .noPagination)
```

### 🎛️ Filtering

**You can hide items in your list through the content block.** Only return a view in the content block if a specific condition is met.

## 🎁 Example

The following code shows how easy-to-use the view is:

```swift
import AdvancedList

@State private var listState: ListState = .items

AdvancedList(yourData, content: { item in
    Text("Item")
}, listState: $listState, emptyStateView: {
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

For more examples take a look at [AdvancedList-SwiftUI](https://github.com/crelies/AdvancedList-SwiftUI).

## Migration 2.x -> 3.0

The `AdvancedList` was dramatically simplified and is now more like the `List` and `ForEach` SwiftUI views.

1. Delete your list service instances and directly **pass your data to the list initializer**
2. Create your views through a content block (initializer parameter) instead of conforming your items to `View` directly (removed type erased wrapper `AnyListItem`)
3. Pass a list state binding to the initializer (before: the `ListService` managed the list state)
4. Move and delete: Instead of setting `AdvancedListActions` on your list service just pass a `onMoveAction` and/or `onDeleteAction` block to the initializer

**Before:**
```swift
import AdvancedList

let listService = ListService()
listService.supportedListActions = .moveAndDelete(onMove: { (indexSet, index) in
    // please move me
}, onDelete: { indexSet in
    // please delete me
})
listService.listState = .loading

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

listService.listState = .loading
// fetch your items ...
listService.appendItems(yourItems)
listService.listState = .items
```

**After:**
```swift
import AdvancedList

@State private var listState: ListState = .items

AdvancedList(yourData, content: { item in
    Text("Item")
}, listState: $listState, onMoveAction: { (indexSet, index) in
    // move me
}, onDeleteAction: { indexSet in
    // delete me
}, emptyStateView: {
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
