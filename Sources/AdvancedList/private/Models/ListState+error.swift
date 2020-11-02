//
//  ListState+error.swift
//  AdvancedList
//
//  Created by Christian Elies on 02.08.20.
//

extension ListState {
    var error: Swift.Error? {
        guard case let ListState.error(error) = self else {
            return nil
        }
        return error
    }
}
