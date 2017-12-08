//
//  CategoryViewModel.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 07/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import UIKit

class CategoryViewModel {
    private var category: CategoryMO?
    var mode: EditMode = .create

    init(category: CategoryMO?, mode: EditMode) {
        self.category = category
        self.mode = mode
    }

    var color: UIColor? {
        return category?.uiColor
    }
    var name: String? {
        return category?.name
    }
}
