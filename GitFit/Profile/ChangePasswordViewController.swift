//
//  ChangePasswordViewController.swift
//  GitFit
//
//  Created by Ubicomp3 on 10/31/17.
//  Copyright © 2017 Team3. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var currPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var verifyPass: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    var id: Int?
    var move: CGFloat = 0
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    let changePasswordModel = ChangePasswordModel()
    
    @IBAction func submit(_ sender: Any) {
        loadValues()
        changePasswordModel.changePassword(id: id!, firstName: firstName!, lastName: lastName!, emailAddress: email!, password: password!)
    }
    
    func setButtonStyle() {
        setDefaultButtonStyle(submitButton, fitBlue)
    }
    
    func setTextFieldStyle() {
        setDefaultTextFieldStyle(currPass, fitBlue)
        setDefaultTextFieldStyle(newPass, fitBlue)
        setDefaultTextFieldStyle(verifyPass, fitBlue)
    }

    func loadValues() {
        id = user?.id ?? 0
        firstName = user?.firstName ?? ""
        lastName = user?.lastName ?? ""
        email = user?.email ?? ""
        password = newPass.text!
//      user?.password = newPass.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldStyle()
        setButtonStyle()
        currPass.delegate = self
        newPass.delegate = self
        verifyPass.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = fitBlue.cgColor
        let textPos = (textField.superview?.frame.origin.y)! + textField.frame.origin.y
        let halfScreen = UIScreen.main.bounds.height / 2
        if halfScreen < (textPos + 50) {
            move = 50 + textPos - halfScreen
            moveTextField(textField: textField, distance: -move)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = fitGray.cgColor
        if move != 0 {
            moveTextField(textField: textField, distance: move)
            move = 0
        }
    }
    
    func moveTextField(textField: UITextField, distance: CGFloat) {
        let moveDuration = 0.3
        
        UIView.beginAnimations("animageTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: distance)
        UIView.commitAnimations()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.endEditing(true)
    }
}
