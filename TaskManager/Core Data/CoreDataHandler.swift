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

    class var getManagedObjectContext: NSManagedObjectContext? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext
    }
    
    // MARK: Task
    class func deleteTask(_ task: TaskMO) {
        
        if let context = getManagedObjectContext {
            context.delete(task)
            
            do{
                try context.save()
            } catch let error as NSError {
                debugPrint("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    //TODO: to not return
    class func addNewTask(withTitle title: String, completionDate: Date, category: CategoryMO) -> TaskMO? {
        if let context = getManagedObjectContext {
            
            let task = TaskMO(context: context)
            task.setValuesForKeys(["title" : title, "completionDate" : completionDate, "category" : category])
            task.title = title
            task.completionDate = completionDate as NSDate
            task.category = category
            
            do{
                try context.save()
                return task
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        return nil
    }
    
    class func editTask(_ task: TaskMO, title: String?, completionDate: Date?, category: CategoryMO?) {
        if let context = getManagedObjectContext {
            if let taskTitle = title {
                task.setValue(taskTitle, forKey: "title")
            }
            
            if let taskcompletionDate = completionDate as NSDate? {
                task.setValue(taskcompletionDate, forKey: "completionDate")
            }
            
            if let taskcategory = category {
                task.setValue(taskcategory, forKey: "category")
            }
            
            do{
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    class func fetchAllTasks() -> [TaskMO] {
        var tasksList: [TaskMO] = []
         if let context = getManagedObjectContext {            
            let fetchRequest: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()
            
            do {
                tasksList = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        return tasksList
    }
    
    
    // MARK: Category
    class func addNewCategory(named name: String, color: String) {
        if let context = getManagedObjectContext {
            
            let category = CategoryMO(context: context)
            category.setValuesForKeys(["name" : name, "color" : color])
            
            do{
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    class func addNewCategories(_ categories: [CategoryMO]) {
        if let context = getManagedObjectContext {
            for category in categories {
                context.insert(category)
            }
            do{
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    class func fetchAllCategories() -> [CategoryMO] {
        var categoriesList: [CategoryMO] = []
        if let context = getManagedObjectContext {
            let fetchRequest: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
            
            do {
                categoriesList = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        return categoriesList
    }
}
