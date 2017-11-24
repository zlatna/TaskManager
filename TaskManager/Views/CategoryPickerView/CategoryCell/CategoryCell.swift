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
        self.layer.cornerRadius = self.bounds.width / 4
    }

    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 2 : 0
            self.layer.borderColor = isSelected ? colorView.backgroundColor?.cgColor : UIColor.clear.cgColor
        }
    }

    func setup(color: UIColor, name: String) {
        colorView.backgroundColor = color
        nameLabel.text = name
    }
}

extension CategoryCell: Reusable {
    static var nib: UINib? {
        return UINib(nibName: String(describing: CategoryCell.self), bundle: nil)
    }
}
