//
//  Task.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 28/08/2018.
//  Copyright © 2018 zlatnanikolova. All rights reserved.
//

import RealmSwift

class Task: Object {
    @objc dynamic private(set) var id: Int = 0
    @objc dynamic private(set) var completionDate: Date = Date()
    @objc dynamic private(set) var title: String = ""
    @objc dynamic private(set) var isCompleted: Bool = false
    @objc dynamic private(set) var category: TaskCategory?
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(id: Int, completionDate: Date, title: String, isCompleted: Bool = false, category: TaskCategory?) {
        self.init()
        self.completionDate = completionDate
        self.title = title
        self.isCompleted = isCompleted
        self.category = category
        self.id = id
    }
    
    convenience init(completionDate: Date, title: String, isCompleted: Bool = false, category: TaskCategory?) {
        do {
            let id = try (RealmManager().getObjects(of: Task.self)?.max(ofProperty: "id") as Int? ?? 0 ) + 1
            self.init(id: id,
                      completionDate: completionDate,
                      title: title,
                      isCompleted: isCompleted,
                      category: category)
        } catch {
            self.init()
            assertionFailure("Task id can not be initialized")
        }
    }
    
    convenience init(taskObject: Task, toComplete: Bool? = nil) {
        self.init(id: taskObject.id,
                  completionDate: taskObject.completionDate,
                  title: taskObject.title,
                  isCompleted: toComplete ?? taskObject.isCompleted,
                  category: taskObject.category)
    }
}
