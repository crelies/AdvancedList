//
//  ExampleError.swift
//  AdvancedListExample
//
//  Created by Christian Elies on 08.07.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

enum ExampleError: Error, CaseIterable {
    case requestTimedOut
    case unknown
}

extension ExampleError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .requestTimedOut:
                return "The request timed out."
            case .unknown:
                return "An unknown error occurred."
        }
    }
}
