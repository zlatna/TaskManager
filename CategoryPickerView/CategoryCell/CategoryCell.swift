//
//  CollectionViewCell.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 14/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.cornerRadius = colorView.bounds.width / 2
    }
    func setup(color: UIColor, name: String) {
        colorView.backgroundColor = color
        nameLabel.text = name
    }
}
