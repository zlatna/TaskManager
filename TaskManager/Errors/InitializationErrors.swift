//
//  InitializationErrors.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 28/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation

enum InitializationErrors: Error {
    case wrongParameters(message: String)
}
