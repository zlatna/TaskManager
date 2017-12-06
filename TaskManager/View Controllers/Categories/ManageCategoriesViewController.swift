//
//  ManageCategoriesViewController.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 06/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

class ManageCategoriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let colorPicker = Bundle.main.loadNibNamed(ColorPickerView.nibName, owner: ColorPickerView.self, options: nil)?.first as? ColorPickerView else {
            return
        }
        var frame = self.view.bounds
        frame.origin.y += 300
        colorPicker.frame = self.view.bounds
        view.addSubview(colorPicker)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
