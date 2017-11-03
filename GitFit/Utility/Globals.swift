import Foundation
import UIKit

let fitBlue = UIColor(displayP3Red: 24/256, green: 184/256, blue: 215/256, alpha: 1)
let fitGray = UIColor(displayP3Red: 188/256, green: 186/256, blue: 190/256, alpha: 1)
var user: Profile?

func setDefaultButtonStyle(_ button: UIButton, _ color: UIColor) {
    button.layer.cornerRadius = button.frame.height / 2
    button.clipsToBounds = true
    button.backgroundColor = color
}

func setDefaultTextFieldStyle(_ text: UITextField, _ color: UIColor) {
    text.borderStyle = .roundedRect
}
