//
//  TaskCategory.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 28/08/2018.
//  Copyright © 2018 zlatnanikolova. All rights reserved.
//

import RealmSwift

class TaskCategory: Object {
    @objc dynamic private(set) var color: String = ""
    @objc dynamic private(set) var name: String = ""
    @objc dynamic private(set) var isCustom: Bool = false
    @objc dynamic private(set) var id: Int = 0
    private(set) var tasks = LinkingObjects(fromType: Task.self, property: "category")
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    convenience init(id: Int, color: String, name: String, isCustom: Bool) {
        self.init()
        self.id = id
        self.color = color
        self.name = name
        self.isCustom = isCustom
    }
    
    convenience init(color: String, name: String, isCustom: Bool = true) {
        let id = (RealmManager().getObjects(of: TaskCategory.self)?.max(ofProperty: "id") as Int? ?? 0 ) + 1
        self.init(id: id, color: color, name: name, isCustom: isCustom)
    }
    
    var uiColor: UIColor {
        let color = UIColor(fromHex: self.color)
        return color
    }
    
    class func createAndStoreInitialCategories() {
        let waslaunchedBefore = UserDefaults.standard.bool(forKey: UserDefaultsIdentifiers.launchedBefore.rawValue)
        if (!waslaunchedBefore) {
            let categories = CategoriesAndColors().dictionary
            for (categoryName, categoryColor) in categories {
                let category = TaskCategory(color: categoryColor, name: categoryName, isCustom: false)
                RealmManager().addObject(object: category)
            }
            UserDefaults.standard.set(true, forKey: UserDefaultsIdentifiers.launchedBefore.rawValue)
        }
    }
}
