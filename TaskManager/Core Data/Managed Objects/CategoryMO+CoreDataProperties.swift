//
//  CategoryMO+CoreDataProperties.swift
//  TaskManager
//
//  Created by Zlatna on 8/11/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import CoreData


extension CategoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryMO> {
        return NSFetchRequest<CategoryMO>(entityName: "Category")
    }

    @NSManaged public var color: String
    @NSManaged public var name: String
    @NSManaged public var task: NSSet?

}

// MARK: Generated accessors for task
extension CategoryMO {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: TaskMO)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: TaskMO)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}
