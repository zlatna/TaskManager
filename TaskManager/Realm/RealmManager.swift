//
//  RealmManager.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 28/08/2018.
//  Copyright © 2018 zlatnanikolova. All rights reserved.
//

import RealmSwift

class RealmManager {
    let realm = try? Realm()
    
    func addObject(object: Object) throws {
        try realm?.write {
            realm?.add(object, update: false)
        }
    }
    
    func updateObject(object: Object) throws {
        try realm?.write {
            realm?.add(object, update: true)
        }
    }
    
    func deleteobject(object: Object) throws {
        try realm?.write {
            realm?.delete(object)
        }
    }
    
    func getObjects(of type: Object.Type) throws -> Results<Object>? {
        guard let objects = realm?.objects(type) else {
            throw RealmErrors.fetchObjects
        }
        return objects
    }
    
    func getTasks() throws -> [Task] {
        var tasks = [Task]()
        if let tasksResult = try getObjects(of: Task.self) {
            for task in tasksResult {
                if let task = task as? Task {
                    tasks.append(task)
                }
            }
        }
        return tasks
    }
    
    func getCategories() throws -> [TaskCategory] {
        var categories = [TaskCategory]()
        if let categoryResult = try getObjects(of: TaskCategory.self) {
            for category in categoryResult {
                if let category =  category as? TaskCategory {
                    categories.append(category)
                }
            }
        }
        return categories
    }
}
