//
//  ManageCategoriesViewController.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 06/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

class ManageCategoriesViewController: UIViewController {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var categoriesViewModel = TaskCategoriesViewModel()
    struct CollectionConfig {
        static let maxCellWidth = 90
        static let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let colorPicker = Bundle.main.loadNibNamed(ColorPickerView.nibName, owner: ColorPickerView.self, options: nil)?.first as? ColorPickerView else {
//            return
//        }
//        var frame = self.view.bounds
//        frame.origin.y += 300
//        colorPicker.frame = self.view.bounds
//        view.addSubview(colorPicker)
//        // Do any additional setup after loading the view.
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CategoryCell.nib, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
    }
}

// MARK: - CollectionView Setup
fileprivate typealias CollectionViewConfig = ManageCategoriesViewController
extension CollectionViewConfig: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesViewModel?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        assert(categoriesViewModel != nil)
        let cell = categoriesCollectionView.dequeReusableCell(indexPath: indexPath) as CategoryCell
        let category = categoriesViewModel![indexPath.row]
        cell.setup(color: category.uiColor, name: category.name)
        return cell
    }
}

extension CollectionViewConfig: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: - extract this logic for all collection views
        let itemsPerRow = Int(collectionView.bounds.width / CGFloat(CollectionConfig.maxCellWidth))
        let padding = CollectionConfig.sectionInsets.left * CGFloat(itemsPerRow) + CollectionConfig.sectionInsets.right * CGFloat(itemsPerRow)
        let availableWidth = collectionView.bounds.width - padding
        let itemWidth = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionConfig.sectionInsets.top
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return CollectionConfig.sectionInsets
    }
}
