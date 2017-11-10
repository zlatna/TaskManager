//
//  InitialCategories.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 10/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
struct CategoriesAndColors{
    var dictionary: [String : String] {
        var dictionary: [String : String] =  [:]
        let colors = ["#C6DA02", "#79A700", "#F68B2C", "#E2B400", "#F5522D", "#FF6E83"]
        for (index, color) in colors.enumerated() {
            dictionary["category \(index + 1)"] = color
        }
        return dictionary
    }
}
