//
//  TaskMO+CoreDataProperties.swift
//  TaskManager
//
//  Created by Zlatna on 8/11/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import CoreData


extension TaskMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskMO> {
        return NSFetchRequest<TaskMO>(entityName: "Task")
    }

    @NSManaged public var completionDate: NSDate
    @NSManaged public var title: String
    @NSManaged public var category: CategoryMO

}
