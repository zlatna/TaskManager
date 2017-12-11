//
//  CategoryViewController.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 06/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit
import TextFieldEffects

class CategoryViewController: UITableViewController, PresentAlertsProtocol {
    private struct ColorPickerConfig {
        static let titleHeight: CGFloat = 40
        static let buttonsHeight: CGFloat = 40
    }
    @IBOutlet weak var categoryNameTextField: HoshiTextField!
    @IBOutlet weak var chooseColorButton: UIButton!
    var categoryViewModel: CategoryViewModel!
    @IBOutlet weak var addCategory: UIButton!
    @IBOutlet weak var deleteCategory: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryNameTextField.text = categoryViewModel?.name
        chooseColorButtonInitialSetup()
        addCategory.isHidden = categoryViewModel.mode != .create
        deleteCategory.isHidden = categoryViewModel.mode != .update
    }

    @IBAction func chooseColorTouchUpInside(_ sender: Any) {
        let alert = UIAlertController(title: R.string.alert.msgChooseCategoryColor(), message: "", preferredStyle: .alert)
        if let colorPicker = createColorPickerView() {
            let y = alert.view.frame.origin.y + ColorPickerConfig.titleHeight
            let width = alert.view.bounds.width
            let height = alert.view.bounds.height - ColorPickerConfig.titleHeight - ColorPickerConfig.buttonsHeight
            let viewFrame = CGRect(origin: CGPoint(x: alert.view.frame.origin.x, y: y), size: CGSize(width: width, height: height))
            colorPicker.frame = viewFrame

            alert.view.addSubview(colorPicker)
            alert.addAction(UIAlertAction(title: R.string.alert.buttonOk() , style: UIAlertActionStyle.default, handler: {(_) in
                self.chooseColorButton.backgroundColor = colorPicker.curentColor
            }))
            alert.addAction(UIAlertAction(title: R.string.alert.buttonCancel() , style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: {})
        }
    }

    @IBAction func addCtegoryTouchUpInside(_ sender: UIButton) {
        if categoryViewModel.mode == .create {
            guard let name = categoryNameTextField.text,
                !name.isEmpty else {
                    self.showInformationAlert(withTitle: R.string.categoryView.msgEnterCategoryName(), message: "")
                    return
            }

            guard let color = chooseColorButton.backgroundColor else {
                self.showInformationAlert(withTitle: R.string.categoryView.msgEnterCategoryName(), message: "")
                return
            }
            categoryViewModel.createCategoryWith(name: name, andColor: color)
        }
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteCtegoryTouchUpInside(_ sender: UIButton) {
        if categoryViewModel.mode == .update {
            categoryViewModel.deleteCurrentCategory()
        }
        self.navigationController?.popViewController(animated: true)
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil && categoryViewModel.mode == .update {
            guard let name = categoryNameTextField.text,
                !name.isEmpty else {
                    self.showInformationAlert(withTitle: R.string.categoryView.msgEnterCategoryName(), message: "")
                    return
            }

            guard let color = chooseColorButton.backgroundColor else {
                self.showInformationAlert(withTitle: R.string.categoryView.msgEnterCategoryName(), message: "")
                return
            }
            categoryViewModel.updateCategory(name: name, color: color)
        }
    }

//    fileprivate func canSave() -> Bool {
//        guard let name = categoryNameTextField.text,
//            !name.isEmpty else {
//                self.showInformationAlert(withTitle: R.string.categoryView.msgEnterCategoryName(), message: "")
//                return false
//        }
//
//        guard let _ = chooseColorButton.backgroundColor else {
//            self.showInformationAlert(withTitle: R.string.categoryView.msgEnterCategoryName(), message: "")
//            return false
//        }
//        return true
//    }
}

fileprivate typealias CategoryColorPickerConfig = CategoryViewController
extension CategoryColorPickerConfig {
    fileprivate func createColorPickerView() -> ColorPickerView? {
        guard let colorPicker = Bundle.main.loadNibNamed(ColorPickerView.nibName, owner: ColorPickerView.self, options: nil)?.first as? ColorPickerView else {
            return nil
        }
        if categoryViewModel.mode == .update,
            let color = categoryViewModel.color {
            colorPicker.initialColour = color
        }
        return colorPicker
    }

    func chooseColorButtonInitialSetup() {
        chooseColorButton.layer.cornerRadius = chooseColorButton.bounds.height / 2
        if categoryViewModel.mode == .update {
            chooseColorButton.backgroundColor = categoryViewModel?.color
        }
    }
}
