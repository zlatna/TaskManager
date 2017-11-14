//
//  TaskCategoriesViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 13/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation

class TaskCategoriesViewModel {
    private var list: [CategoryMO]
    var count: Int {
        return list.count
    }
    init() {
        list =  CoreDataHandler.sharedInstance.fetchAllCategories()
    }
    func index(of category: CategoryMO?) -> Int {
        guard category != nil else {
            return 0
        }
        let index = list.index(of: category!)
        assert(index != nil, "Nonexisting category")
        return index!
    }
    subscript(index: Int) -> CategoryMO {
            return list[index]
    }
}
