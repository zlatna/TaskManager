//
//  TaskCategoriesViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 13/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation

class TaskCategoriesViewModel {
    private var list: [TaskCategory]

    var count: Int {
        return list.count
    }

    init?() {
        list = RealmManager().getCategories()
    }

    func index(of category: TaskCategory?) -> Int? {
        guard let category = category else {
            return 0
        }
        let index = list.index(of: category)
        return index
    }

    subscript(index: Int) -> TaskCategory {
            return list[index]
    }
}
