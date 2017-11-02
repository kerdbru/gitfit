//
//  ChangePasswordViewController.swift
//  GitFit
//
//  Created by Ubicomp3 on 10/31/17.
//  Copyright © 2017 Team3. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
   
    @IBOutlet weak var currPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var verifyPass: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    var id: Int?
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
