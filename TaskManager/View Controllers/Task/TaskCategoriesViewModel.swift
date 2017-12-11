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

    init?() {
        list = []
        do {
            list = try CoreDataHandler.fetchAllCategories()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    func index(of category: CategoryMO?) -> Int? {
        guard let category = category else {
            return 0
        }
        let index = list.index(of: category)
        return index
    }

    subscript(index: Int) -> CategoryMO {
            return list[index]
    }
}
