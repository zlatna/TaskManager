//
//  CoreDataHandler.swift
//  TaskManager
//
//  Created by Zlatna on 8/11/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler {
    static let sharedInstance = CoreDataHandler()
    private init() {}
}

// MARK: - TaskMO altering and extracting
typealias CoreDataTaskHandler = CoreDataHandler
extension CoreDataTaskHandler {
    // MARK: - altering
    func deleteTask(_ task: TaskMO) {
        let context = CoreDataManager.sharedInstance.viewContext
        context.delete(task)
        do {
            try context.save()
        } catch let error as NSError {
            assertionFailure("Could not delete Task. \(error), \(error.userInfo)")
        }
    }

    //TODO: to not return
    func addNewTask(withTitle title: String, completionDate: Date, category: CategoryMO) -> TaskMO? {
        let context = CoreDataManager.sharedInstance.viewContext
        let task = TaskMO(context: context)
        task.setValuesForKeys(["title" : title, "completionDate" : completionDate, "category" : category])
        task.title = title
        task.completionDate = completionDate as NSDate
        task.category = category
        task.isCompleted = false
        do {
            try context.save()
            return task
        } catch let error as NSError {
            assertionFailure("Could not add Task. \(error), \(error.userInfo)")
        }
        return nil
    }

    func editTask(_ task: TaskMO, title: String? = nil, completionDate: Date? = nil, category: CategoryMO? = nil, isCompleted: Bool? = nil) {
        let context = CoreDataManager.sharedInstance.viewContext
        if let taskTitle = title {
            task.setValue(taskTitle, forKey: "title")
        }

        if let taskcompletionDate = completionDate as NSDate? {
            task.setValue(taskcompletionDate, forKey: "completionDate")
        }

        if let taskcategory = category {
            task.setValue(taskcategory, forKey: "category")
        }

        if let taskIsCompleted = isCompleted {
            task.setValue(taskIsCompleted, forKey: "isCompleted")
        }

        do {
            try context.save()
        } catch let error as NSError {
            assertionFailure("Could not edit Task. \(error), \(error.userInfo)")
        }
    }

    // MARK: - extracting
    func fetchAllTasks() -> [TaskMO] {
        var tasksList: [TaskMO] = []
        let context = CoreDataManager.sharedInstance.viewContext
        let fetchRequest: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()

        do {
            tasksList = try context.fetch(fetchRequest)
        } catch let error as NSError {
            assertionFailure("Could not fetch Tasks. \(error)")
        }
        return tasksList
    }
}

// MARK: - CategoryMO altering and extracting
typealias CoreDataCategoryHandler = CoreDataHandler
extension CoreDataCategoryHandler {
    // MARK: - altering
    func addNewCategory(named name: String, color: String) {
        let context = CoreDataManager.sharedInstance.viewContext

        let category = CategoryMO(context: context)
        category.setValuesForKeys(["name" : name, "color" : color])

        do {
            try context.save()
        } catch let error as NSError {
            assertionFailure("Could not add Category. \(error), \(error.userInfo)")
        }
    }

    func addNewCategories(_ categories: [CategoryMO]) {
        let context = CoreDataManager.sharedInstance.viewContext
        for category in categories {
            context.insert(category)
        }
        do {
            try context.save()
        } catch let error as NSError {
            assertionFailure("Could not add Categories. \(error), \(error.userInfo)")
        }
    }

    // MARK: - extracting
    func fetchAllCategories() -> [CategoryMO] {
        var categoriesList: [CategoryMO] = []
        let context = CoreDataManager.sharedInstance.viewContext
        let fetchRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
        do {
            categoriesList = try context.fetch(fetchRequest)
        } catch let error as NSError {
            assertionFailure("Could not fetch Categories. \(error)")
        }
        return categoriesList
    }
}
