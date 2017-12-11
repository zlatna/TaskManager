//
//  TaskManagerErrors.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 27/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation

enum GeneralError {
    case regular(message: String)
    case network(message: String, statusCode: Int)
    case silent(message: String)
}

enum CoreDataErrors: Error {
    case saveContex(message: String)

    case deleteTask(message: String, taskTitle: String)
    case addTask(message: String, taskTitle: String)
    case editTask(message: String, taskTitle: String)
    case createTask(message: String, taskTitle: String)
    case fetchTasks(message: String)

    case fetchCategories(message: String)
    case addCategory(message: String, categoryName: String)
    case addCategories(message: String)
    case deleteCategory(message: String)
    case editCategory(message: String)

//    func passError(with message: String) -> CoreDataErrors {
//        switch self {
//        case .:
//            // Log
//            return self
//            <#code#>
//        default:
//            <#code#>
//        }
//    }
}
