//
//  ColorPickerView.swift
//  TaskManager
//
//  Created by Zlatna Nikolova on 06/12/2017.
//  Copyright © 2017 zlatnanikolova. All rights reserved.
//

import UIKit

class ColorPickerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var colorView: UIView!

    override func awakeFromNib() {
        DispatchQueue.main.async { [weak self] in
            self?.colorView.layer.cornerRadius = (self?.colorView.bounds.size.width ?? 0) / 2
            self?.colorView.backgroundColor = self?.curenColour
        }
    }

    fileprivate var curenColour: UIColor {
        return UIColor(displayP3Red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: CGFloat(alphaSlider.value))
    }

    @IBAction func redSliderValueChanged(_ sender: UISlider) {
        redSlider.maximumTrackTintColor =  UIColor(displayP3Red: CGFloat(redSlider.value), green: 0, blue: 0, alpha: 1)
        colorView.backgroundColor = curenColour
    }
    @IBAction func greenSliderValueChanged(_ sender: UISlider) {
        greenSlider.maximumTrackTintColor =  UIColor(displayP3Red: CGFloat(redSlider.value), green: 0, blue: 0, alpha: 1)
        colorView.backgroundColor = curenColour
    }
    @IBAction func blueSliderValueChanged(_ sender: UISlider) {
        blueSlider.maximumTrackTintColor =  UIColor(displayP3Red: CGFloat(redSlider.value), green: 0, blue: 0, alpha: 1)
        colorView.backgroundColor = curenColour
    }
    @IBAction func alphaSliderValueChanged(_ sender: UISlider) {
        colorView.backgroundColor = curenColour
    }
}
