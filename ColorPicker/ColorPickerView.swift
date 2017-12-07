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
    class var nibName: String {
        return String(describing: ColorPickerView.self)
    }

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
//    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var slidersStack: UIStackView!
    @IBOutlet weak var mainStack: UIStackView!
    weak var delegate: ColorPickerDelegate?

    fileprivate var curentColor: UIColor {
        let red = CGFloat(redSlider.value)
        let green = CGFloat(greenSlider.value)
        let blue = CGFloat(blueSlider.value)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }

    override func awakeFromNib() {
        slidersStack.isUserInteractionEnabled = true
        mainStack.isUserInteractionEnabled = true
        colorView.backgroundColor = self.curentColor
        redSlider.minimumTrackTintColor = UIColor(red: CGFloat(redSlider.value), green: 0, blue: 0, alpha: 1)
        greenSlider.minimumTrackTintColor =  UIColor(red: 0, green: CGFloat(greenSlider.value), blue: 0, alpha: 1)
        blueSlider.minimumTrackTintColor =  UIColor(red: 0, green: 0, blue: CGFloat(blueSlider.value), alpha: 1)
        DispatchQueue.main.async { [weak self] in
            self?.colorView.layer.cornerRadius = (self?.colorView.bounds.size.width ?? 0) / 2
        }
    }

    @IBAction func redSliderValueChanged(_ sender: UISlider) {
        redSlider.minimumTrackTintColor = UIColor(red: CGFloat(redSlider.value), green: 0, blue: 0, alpha: 1)
        colorView.backgroundColor = curentColor
    }

    @IBAction func greenSliderValueChanged(_ sender: UISlider) {
        greenSlider.minimumTrackTintColor =  UIColor(red: 0, green: CGFloat(greenSlider.value), blue: 0, alpha: 1)
        colorView.backgroundColor = curentColor
    }

    @IBAction func blueSliderValueChanged(_ sender: UISlider) {
        blueSlider.minimumTrackTintColor =  UIColor(red: 0, green: 0, blue: CGFloat(blueSlider.value), alpha: 1)
        colorView.backgroundColor = curentColor
    }

    @IBAction func alphaSliderValueChanged(_ sender: UISlider) {
        colorView.backgroundColor = curentColor
    }

    @IBAction func didSelectColor(_ sender: Any) {
        delegate?.didSelectColor(curentColor)
        let color = UIColor(fromHex: curentColor.toHexString)
        self.backgroundColor = color
    }
}
