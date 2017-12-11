//
//  ManageCategoriesViewController.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 06/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

class ManageCategoriesViewController: UIViewController, PresentAlertsProtocol {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var manageCategoriesViewModel = ManageCategoriesViewModel()
    struct CollectionConfig {
        static let maxCellWidth = 90
        static let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CategoryCell.nib, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        categoriesCollectionView.registerReusableSuplementaryView(elementKind: UICollectionElementKindSectionHeader, CategoryCollectionSuplementaryView.self)
    }

    override func viewDidAppear(_ animated: Bool) {
        reloadData()
    }

    func reloadData() {
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            self.manageCategoriesViewModel?.loadData()
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case R.segue.manageCategoriesViewController.editCategory.identifier?:
            if let destinationViewController = segue.destination as? CategoryViewController,
                let selectionIndexPath = categoriesCollectionView.indexPathsForSelectedItems?.first,
                let category = manageCategoriesViewModel?.categoryAtIndexPath(indexPath: selectionIndexPath) {
                do {
                    let categoryVM = try CategoryViewModel(category: category, mode: .update)
                    destinationViewController.categoryViewModel = categoryVM
                } catch let error {
                    assertionFailure(error.localizedDescription)
                }
            }
        case R.segue.manageCategoriesViewController.createCategory.identifier?:
            if let destinationViewController = segue.destination as? CategoryViewController {
                do {
                    let categoryVM = try CategoryViewModel(category: nil, mode: .create)
                    destinationViewController.categoryViewModel = categoryVM
                } catch let error {
                    assertionFailure(error.localizedDescription)
                }
            }
        default:
            break
        }
    }
}

// MARK: - CollectionView Setup
fileprivate typealias CollectionViewConfig = ManageCategoriesViewController
extension CollectionViewConfig: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ManageCategoriesViewModel.CategoriesSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let manageCategoriesVM = manageCategoriesViewModel else {
            return 0
        }
        return manageCategoriesVM.countForSection(section: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        assert(manageCategoriesViewModel != nil)
        let cell = categoriesCollectionView.dequeReusableCell(indexPath: indexPath) as CategoryCell
        let category = manageCategoriesViewModel!.categoryAtIndexPath(indexPath: indexPath)
        assert(category != nil)
        cell.setup(color: category!.uiColor, name: category!.name)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            do {
                let headerView = try categoriesCollectionView.dequeueReusableSupplementaryView(elementKind: UICollectionElementKindSectionHeader, indexPath: indexPath) as  CategoryCollectionSuplementaryView
                switch indexPath.section {
                case ManageCategoriesViewModel.CategoriesSections.customCategpries.rawValue:
                    headerView.title.text = R.string.manageCategories.titleCustomCategorySection()
                case ManageCategoriesViewModel.CategoriesSections.defaultCategories.rawValue:
                    headerView.title.text = R.string.manageCategories.titleDefaultCategorySection()
                default:
                    break
                }
                return headerView
            } catch let error {
                showInformationAlert(withTitle: error.localizedDescription)
            }
            return UICollectionReusableView()
        default:
            assert(false)
        }

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

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case ManageCategoriesViewModel.CategoriesSections.customCategpries.rawValue:
            return true
        default:
            return false
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == ManageCategoriesViewModel.CategoriesSections.customCategpries.rawValue {
            performSegue(withIdentifier: R.segue.manageCategoriesViewController.editCategory, sender: self)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}
