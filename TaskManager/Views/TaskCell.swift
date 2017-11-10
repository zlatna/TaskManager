//
//  TaskCell.swift
//  TaskManager
//
//  Created by Zlatna on 8/11/17.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var categoryColorView: UIView!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var completionDateLabel: UILabel!
    @IBOutlet weak var customSeparator: UIView!
    
    func setup(task: TaskMO) {
        let categoryColor = task.category.uiColor
        categoryColorView.backgroundColor = categoryColor
        customSeparator.backgroundColor = categoryColor
        taskTitleLabel.text = task.title
        completionDateLabel.text = CustomDateFormatter.defaultFormatedDate(date: task.completionDate as Date)
        let timeinterval = task.completionDate.timeIntervalSince(Date())
        backgroundColor = timeinterval < 1 ? UIColor.groupTableViewBackground : UIColor.white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryColorView.layer.cornerRadius = categoryColorView.bounds.width / 2
    }
}
