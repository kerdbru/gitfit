import UIKit

class RegisterViewController: UIViewController, RegisterModelDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var newUser: Profile?
    let registerModel = RegisterModel()
    let imagePicker = UIImagePickerController();

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
        setTextFieldStyle()
        setButtonStyle()
        addGestureToProfilePic()
        
        firstName.delegate = self
        lastName.delegate = self
        emailAddress.delegate = self
        password.delegate = self
        verifyPassword.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
            img.contentMode = .scaleAspectFill
            img.layer.cornerRadius = img.frame.height / 2
            img.layer.masksToBounds = false
            img.clipsToBounds = true
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
    
    func setTextFieldStyle() {
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
    }
    
    fileprivate func setButtonStyle() {
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        registerButton.clipsToBounds = true
        registerButton.backgroundColor = fitBlue
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
                self.registerModel.uploadImage(String(describing: profile!.id!), self.img.image!)
                user = profile
            }
        }
        else {
            print("NO PROFILE RETURNED")
        }
    }
}
