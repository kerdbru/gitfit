import Foundation
import UIKit

let fitBlue = UIColor(displayP3Red: 24/256, green: 184/256, blue: 215/256, alpha: 1)
let fitGray = UIColor(displayP3Red: 188/256, green: 186/256, blue: 190/256, alpha: 1)
let fitGreen = UIColor(displayP3Red: 76/256, green: 217/256, blue: 100/256, alpha: 1)
let fitYellow = UIColor(displayP3Red: 255/256, green: 204/256, blue: 0/256, alpha: 1)
let fitRed = UIColor(displayP3Red: 255/256, green: 59/256, blue: 48/256, alpha: 1)

var user: Profile?

extension String {
    var firstUpper: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}

func setDefaultButtonStyle(_ button: UIButton, _ color: UIColor) {
    button.layer.cornerRadius = button.frame.height / 2
    button.clipsToBounds = true
    button.backgroundColor = color
}

func setDefaultTextFieldStyle(_ text: UITextField, _ color: UIColor) {
    text.borderStyle = .none
    text.layer.cornerRadius = 5
    text.layer.borderWidth = 1.0
    text.layer.borderColor = fitGray.cgColor
    text.adjustsFontSizeToFitWidth = false
}
