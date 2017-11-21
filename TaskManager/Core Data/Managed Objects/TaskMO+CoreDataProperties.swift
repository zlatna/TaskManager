//
//  TaskMO+CoreDataProperties.swift
//  
//
//  Created by Zlatna Nikolova on 21/11/2017.
//
//

import Foundation
import CoreData

extension TaskMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskMO> {
        return NSFetchRequest<TaskMO>(entityName: "Task")
    }

    @NSManaged public var completionDate: NSDate
    @NSManaged public var title: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var category: CategoryMO

}
