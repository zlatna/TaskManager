//
//  TasksListViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 13/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation

class TasksListViewModel {
    private var tasks: [TaskMO] = []
    init() {
        self.loadData()
    }
    subscript (index: Int) -> TaskMO {
            return tasks[index]
    }
    var count: Int {
        return tasks.count
    }
    func remove(at index: Int) {
        tasks.remove(at: index)
    }
    func loadData() {
        let tasksMO = CoreDataHandler.sharedInstance.fetchAllTasks()
        let sortedTasks = tasksMO.sorted(by: { (leftTask, righTask) -> Bool in
            let descending = (leftTask.completionDate.compare(righTask.completionDate as Date) == .orderedDescending)
            return descending
        })
        self.tasks = sortedTasks
    }
}
