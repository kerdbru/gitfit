//
//  fitTextField.swift
//  GitFit
//
//  Created by Keith Erdbruegger on 11/2/17.
//  Copyright © 2017 Team3. All rights reserved.
//

import UIKit

class FitTextField: UITextField {
    let padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
