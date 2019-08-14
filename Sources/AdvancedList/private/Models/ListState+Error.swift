//
//  File.swift
//  
//
//  Created by Christian Elies on 14.08.19.
//

import Foundation

extension ListState {
    var error: Error? {
        switch self {
            case .error(let error):
                return error
            default:
                return nil
        }
    }
}
