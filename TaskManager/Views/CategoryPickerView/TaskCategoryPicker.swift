//
//  TaskCategoryPicker.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 15/11/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import Foundation
import UIKit

class TaskCategoryPicker: UIView {
    class var nibName: String {
        return String(describing: TaskCategoryPicker.self)
    }
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let maxCellWidth = 90
    fileprivate let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    weak var delegate: CategoryPickerDelegate?

    fileprivate let taskCategories = TaskCategoriesViewModel()
    var selectedItem: CategoryMO?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerReusable(CategoryCell.self)
    }
}

// MARK: - CollectionView Setup
typealias CollectionViewConfig = TaskCategoryPicker
extension CollectionViewConfig: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskCategories?.count ??  0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        assert(taskCategories != nil)
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as CategoryCell
        let category = taskCategories![indexPath.row]
        cell.setup(color: category.uiColor, name: category.name)
        // In order to show the current category as selected
        if let category = selectedItem,
            let categoryIndex = taskCategories!.index(of: category) {
            let categoryIndexPath = IndexPath(row: categoryIndex, section: 0)
            if categoryIndexPath.elementsEqual(indexPath) {
                collectionView.selectItem(at: categoryIndexPath, animated: false, scrollPosition: .top)
                cell.isSelected = true
            }
        }
        return cell
    }
}

extension CollectionViewConfig: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = Int(collectionView.bounds.width / CGFloat(maxCellWidth))
        let padding = sectionInsets.left * CGFloat(itemsPerRow) + sectionInsets.right * CGFloat(itemsPerRow)
        let availableWidth = collectionView.bounds.width - padding
        let itemWidth = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

extension CollectionViewConfig: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        assert(taskCategories != nil)
        selectedItem = taskCategories![indexPath.row]
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        delegate?.didSelectItem(selectedItem!)
    }
}
