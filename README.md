# AdvancedList

[![Swift 5.3](https://img.shields.io/badge/swift-5.3-green.svg?longCache=true&style=flat-square)](https://developer.apple.com/swift)
[![Platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS-lightgrey.svg?longCache=true&style=flat-square)](https://www.apple.com)
[![Current version](https://img.shields.io/github/v/tag/crelies/AdvancedList?longCache=true&style=flat-square)](https://github.com/crelies/AdvancedList)
[![Build status](https://github.com/crelies/AdvancedList/actions/workflows/build.yml/badge.svg)](https://github.com/crelies/AdvancedList/actions/workflows/build.yml)
[![Code coverage](https://codecov.io/gh/crelies/AdvancedList/branch/dev/graph/badge.svg?token=DhJyoUKNPM)](https://codecov.io/gh/crelies/AdvancedList)
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
}, listState: listState, emptyStateView: {
    Text("No data")
}, errorStateView: { error in
    Text(error.localizedDescription)
        .lineLimit(nil)
}, loadingStateView: {
    Text("Loading ...")
})
```

### 🆕 Custom List view

Starting from version `6.0.0` you can use a custom list view instead of the `SwiftUI` `List` used under the hood. As an example you can now easily use the **LazyVStack** introduced in **iOS 14** if needed.

Upgrade from version `5.0.0` **without breaking anything**. Simply add the **listView parameter** after the upgrade:

```swift
AdvancedList(yourData, listView: { rows in
    if #available(iOS 14, macOS 11, *) {
        ScrollView {
            LazyVStack(alignment: .leading, content: rows)
                .padding()
        }
    } else {
        List(content: rows)
    }
}, content: { item in
    Text("Item")
}, listState: listState, emptyStateView: {
    Text("No data")
}, errorStateView: { error in
    Text(error.localizedDescription)
        .lineLimit(nil)
}, loadingStateView: {
    Text("Loading ...")
})
```

### 🆕 Custom Content view

Starting from version `8.0.0` you have full freedom & control over the content view rendered in the `items` state of your `AdvancedList`. Use a `SwiftUI List` or a `custom view`.

Upgrade from version `7.0.0` **without breaking anything** and use the new API:

```swift
AdvancedList(listState: yourListState, content: {
    VStack {
        Text("Row 1")
        Text("Row 2")
        Text("Row 3")
    }
}, errorStateView: { error in
    VStack(alignment: .leading) {
        Text("Error").foregroundColor(.primary)
        Text(error.localizedDescription).foregroundColor(.secondary)
    }
}, loadingStateView: ProgressView.init)
```

### 📄 Pagination

The `Pagination` functionality is now (>= `5.0.0`) implemented as a `modifier`.
It has three different states: `error`, `idle` and `loading`. If the `state` of the `Pagination` changes the `AdvancedList` displays the view created by the view builder of the specified pagination object (`AdvancedListPagination`). Keep track of the current pagination state by creating a local state variable (`@State`) of type `AdvancedListPaginationState`. Use this state variable in the `content` `ViewBuilder` of your pagination configuration object to determine which view should be displayed in the list (see the example below).

If you want to use pagination you can choose between the `lastItemPagination` and the `thresholdItemPagination`. Both concepts are described [here](https://github.com/crelies/ListPagination). Just specify the type of the pagination when adding the `.pagination` modifier to your `AdvancedList`.

**The view created by the `content` `ViewBuilder` of your pagination configuration object will only be visible below the List if the last item of the List appeared! That way the user is only interrupted if needed.**

**Example:**

```swift
@State private var paginationState: AdvancedListPaginationState = .idle

AdvancedList(...)
.pagination(.init(type: .lastItem, shouldLoadNextPage: {
    paginationState = .loading
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        items.append(contentsOf: moreItems)
        paginationState = .idle
    }
}) {
    switch paginationState {
    case .idle:
        EmptyView()
    case .loading:
        if #available(iOS 14, *) {
            ProgressView()
        } else {
            Text("Loading ...")
        }
    case let .error(error):
        Text(error.localizedDescription)
    }
})
```

### 📁 Move and 🗑️ delete items

To enable the move or delete function just use the related `onMove` or `onDelete` view modifier.
**Per default the functions are disabled if you don't add the view modifiers.**

```swift
import AdvancedList

@State private var listState: ListState = .items

AdvancedList(yourData, content: { item in
    Text("Item")
}, listState: listState, emptyStateView: {
    Text("No data")
}, errorStateView: { error in
    Text(error.localizedDescription)
        .lineLimit(nil)
}, loadingStateView: {
    Text("Loading ...")
})
.onMove { (indexSet, index) in
    // move me
}
.onDelete { indexSet in
    // delete me
}
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
}, listState: listState, emptyStateView: {
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
})
```

For more examples take a look at the `Example` directory.

## Migration

<details>
<summary>Migration 2.x -> 3.0</summary>

The `AdvancedList` was dramatically simplified and is now more like the `List` and `ForEach` SwiftUI views.

1. Delete your list service instances and directly **pass your data to the list initializer**
2. Create your views through a content block (**initializer parameter**) instead of conforming your items to `View` directly (removed type erased wrapper `AnyListItem`)
3. Pass a list state binding to the initializer (**before:** the `ListService` managed the list state)
4. **Move and delete:** Instead of setting `AdvancedListActions` on your list service just pass a `onMoveAction` and/or `onDeleteAction` block to the initializer

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
</details>

<details>
<summary>Migration 3.0 -> 4.0</summary>

Thanks to a hint from @SpectralDragon I could refactor the `onMove` and `onDelete` functionality to view modifiers.

**Before:**

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

**After:**

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
.onMove { (indexSet, index) in
    // move me
}
.onDelete { indexSet in
    // delete me
}
```
</details>

<details>
<summary>Migration 4.0 -> 5.0</summary>

`Pagination` is now implemented as a `modifier` 💪 And last but not least the code documentation arrived 😀

**Before:**

```swift
private lazy var pagination: AdvancedListPagination<AnyView, AnyView> = {
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
}, pagination: pagination)

```

**After:**

```swift
@State private var listState: ListState = .items
@State private var paginationState: AdvancedListPaginationState = .idle

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
})
.pagination(.init(type: .lastItem, shouldLoadNextPage: {
    paginationState = .loading
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        items.append(contentsOf: moreItems)
        paginationState = .idle
    }
}) {
    switch paginationState {
    case .idle:
        EmptyView()
    case .loading:
        if #available(iOS 14, *) {
            ProgressView()
        } else {
            Text("Loading ...")
        }
    case let .error(error):
        Text(error.localizedDescription)
    }
})
```
</details>

<details>
<summary>Migration 6.0 -> 7.0</summary>

I replaced the unnecessary listState `Binding` and replaced it with a simple value parameter.

**Before:**

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

**After:**

```swift
import AdvancedList

@State private var listState: ListState = .items

AdvancedList(yourData, content: { item in
    Text("Item")
}, listState: listState, emptyStateView: {
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
</details>

<details>
<summary>Migration 7.0 -> 8.0</summary>
Nothing to do 🎉
</details>
