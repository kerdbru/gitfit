import Foundation
import UIKit

let fitBlue = UIColor(displayP3Red: 24/256, green: 184/256, blue: 215/256, alpha: 1)
let fitGray = UIColor.gray
let fitGrayButton = UIColor(displayP3Red: 188/256, green: 186/256, blue: 190/256, alpha: 1)
let fitGreen = UIColor(displayP3Red: 76/256, green: 217/256, blue: 100/256, alpha: 1)
let fitYellow = UIColor(displayP3Red: 255/256, green: 204/256, blue: 0/256, alpha: 1)
let fitRed = UIColor(displayP3Red: 255/256, green: 59/256, blue: 48/256, alpha: 1)

var user: Profile?
var fitLabels: [FitPickerItem] = []

extension String {
    var firstUpper: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}


 // code taken from https://stackoverflow.com/questions/34962103/how-to-set-uiimageview-with-rounded-corners-for-aspect-fit-mode
extension UIImageView
{
    func roundCornersForAspectFit(radius: CGFloat)
    {
        if let image = self.image {
            
            //calculate drawingRect
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height
            
            var drawingRect: CGRect = self.bounds
            
            if boundsScale > imageScale {
                drawingRect.size.width =  drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            } else {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
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
    text.layer.borderColor = UIColor.gray.cgColor
    text.adjustsFontSizeToFitWidth = false
}
