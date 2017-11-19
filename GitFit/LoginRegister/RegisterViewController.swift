import UIKit

class RegisterViewController: UIViewController, RegisterModelDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, ImageModelDelegate {

    var newUser: Profile?
    let registerModel = RegisterModel()
    let imagePicker = UIImagePickerController()
    let imageModel = ImageModel()
    var move: CGFloat = 0
    var imageChanged = false

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyPassword: UITextField!
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerModel.delegate = self
        imagePicker.delegate = self
        imageModel.delegate = self
        setTextFieldStyle()
        setButtonStyle()
        addGestureToProfilePic()
        
        firstName.delegate = self
        firstName.returnKeyType = .next
        lastName.delegate = self
        lastName.returnKeyType = .next
        emailAddress.delegate = self
        emailAddress.returnKeyType = .next
        password.delegate = self
        password.returnKeyType = .next
        verifyPassword.delegate = self
        verifyPassword.returnKeyType = .go
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstName:
            lastName.becomeFirstResponder()
        case lastName:
            emailAddress.becomeFirstResponder()
        case emailAddress:
            password.becomeFirstResponder()
        case password:
            verifyPassword.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            registerUser()
        }
    
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
    
    func showError(string: String) {
        let alert = UIAlertController(title: "Error", message: string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion:nil)
    }
    
    func reset() {
        firstName.layer.borderColor = fitBlue.cgColor
        lastName.layer.borderColor = fitBlue.cgColor
        emailAddress.layer.borderColor = fitBlue.cgColor
        password.layer.borderColor = fitBlue.cgColor
        verifyPassword.layer.borderColor = fitBlue.cgColor
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            img.contentMode = .scaleAspectFill
            img.layer.cornerRadius = img.frame.height / 2
            img.layer.masksToBounds = false
            img.clipsToBounds = true
            img.image = pickedImage
            self.imageChanged = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func registerUser() {
        var valid = true
        var errorMessage = "Please enter all required fields"
        view.endEditing(true)
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
            errorMessage = "Passwords don't match"
        }
        
        if valid {
            registerModel.createProfile(firstName: firstName.text!, lastName: lastName.text!, emailAddress: emailAddress.text!, password: password.text!)
        }
        else {
            showError(string: errorMessage)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        registerUser()
    }
    
    func setTextFieldStyle() {
        setDefaultTextFieldStyle(firstName, fitGray)
        setDefaultTextFieldStyle(lastName, fitGray)
        setDefaultTextFieldStyle(emailAddress, fitGray)
        setDefaultTextFieldStyle(password, fitGray)
        setDefaultTextFieldStyle(verifyPassword, fitGray)
    }
    
    fileprivate func setButtonStyle() {
        setDefaultButtonStyle(registerButton, fitBlue)
    }
    
    fileprivate func addGestureToProfilePic() {
        img.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        img.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func profilePicUploaded() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func createdProfile(profile: Profile?) {
        if profile != nil {
            DispatchQueue.main.async {
                if self.imageChanged {
                    self.imageModel.uploadProfilePic("\(profile!.id!)", self.img.image!)
                }
                else {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                user = profile
            }
        }
        else {
            print("NO PROFILE RETURNED")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        view.endEditing(true)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.img.contentMode = .scaleAspectFill
            self.img.layer.cornerRadius = self.img.frame.height / 2
            self.img.layer.masksToBounds = false
            self.img.clipsToBounds = true
        })
    }
}
