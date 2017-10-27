//
//  RegisterViewController.swift
//  GitFit
//
//  Created by Ubicomp3 on 10/9/17.
//  Copyright © 2017 Team3. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, RegisterModelDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var newUser: Profile?
    let registerModel = RegisterModel()
    let imagePicker = UIImagePickerController();

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyPassword: UITextField!
    @IBOutlet weak var img: UIImageView!
    
    func showError(){
        let alert = UIAlertController(title: "Error", message: "Please enter all required fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion:nil)
    }
    
    func reset(){
        firstName.layer.borderColor = fitBlue.cgColor
        lastName.layer.borderColor = fitBlue.cgColor
        emailAddress.layer.borderColor = fitBlue.cgColor
        password.layer.borderColor = fitBlue.cgColor
        verifyPassword.layer.borderColor = fitBlue.cgColor
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            img.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        var valid = true
        reset()
        if firstName.text! == "" {
            firstName.layer.borderColor = UIColor.red.cgColor
            valid = false
        }
        if lastName.text! == "" {
            lastName.layer.borderColor = UIColor.red.cgColor
            valid = false
        }
        if emailAddress.text! == "" {
            emailAddress.layer.borderColor = UIColor.red.cgColor
            valid = false
        }
        if password.text! == "" {
            password.layer.borderColor = UIColor.red.cgColor
            valid = false
        }
        if verifyPassword.text! == "" {
            verifyPassword.layer.borderColor = UIColor.red.cgColor
            valid = false
        }
        if verifyPassword.text! != password.text! {
            valid = false
            // separate error
        }
            
        if valid {
            registerModel.createProfile(firstName: firstName.text!, lastName: lastName.text!, emailAddress: emailAddress.text!, password: password.text!)
        }
        else {
            showError()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Register"
        registerModel.delegate = self
        firstName.layer.borderColor = fitBlue.cgColor
        firstName.layer.borderWidth = 1.0
        
        lastName.layer.borderColor = fitBlue.cgColor
        lastName.layer.borderWidth = 1.0
        
        emailAddress.layer.borderColor = fitBlue.cgColor
        emailAddress.layer.borderWidth = 1.0
        
        password.layer.borderColor = fitBlue.cgColor
        password.layer.borderWidth = 1.0
        
        verifyPassword.layer.borderColor = fitBlue.cgColor
        verifyPassword.layer.borderWidth = 1.0
        
        imagePicker.delegate = self
        
        img.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        img.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func createdProfile(profile: Profile?) {
        if profile != nil {
            DispatchQueue.main.async {
                let login = self.navigationController?.childViewControllers[0] as! LoginViewController
                login.user = profile
                login.fromRegister = true
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            print("NOPE")
        }
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
