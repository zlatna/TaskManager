//
//  CategoryCollectionSuplementaryView.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 11/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

class CategoryCollectionSuplementaryView: UICollectionReusableView {

    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension CategoryCollectionSuplementaryView: Reusable {
    static var nib: UINib? {
        return UINib(nibName: String(describing: CategoryCollectionSuplementaryView.self), bundle: nil)
    }
}
