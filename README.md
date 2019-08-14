# AdvancedList

This package provides a wrapper view around the **SwiftUI** `List view` which adds an empty, error and loading state including a corresponding view.

## How to use

You control the view through an instance of `ListService`. The service manages the current state and the items of the list.
Use it to append, update or remove items and to modify the state of the list. The view listens to the service and updates itself if needed.

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
})
```
