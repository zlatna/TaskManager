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
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let cellReuseIdentifier = "CategoryCell"
    fileprivate let itemsPerRow = 4
    fileprivate let taskCategories = TaskCategoriesViewModel()
    fileprivate let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    var selectedItem: CategoryMO?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        let cellNib = UINib(nibName: "CategoryCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
}

typealias CollectionViewConfig = TaskCategoryPicker
extension CollectionViewConfig: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(taskCategories)
        print(taskCategories.count)
        return taskCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CategoryCell {
            let category = taskCategories[indexPath.row]
            cell.setup(color: category.uiColor, name: category.name)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CollectionViewConfig: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = sectionInsets.left * CGFloat(itemsPerRow + 1)
        let availableWidth = collectionView.bounds.width - padding
        let itemWidth = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension CollectionViewConfig: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
