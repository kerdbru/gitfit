import UIKit

class RegisterViewController: UIViewController, RegisterModelDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var newUser: Profile?
    let registerModel = RegisterModel()
    let imagePicker = UIImagePickerController();
    var currentOffset: CGFloat = 0

    @IBOutlet weak var scrollView: UIScrollView!
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
        firstName.returnKeyType = .next
        lastName.delegate = self
        lastName.returnKeyType = .next
        emailAddress.delegate = self
        emailAddress.returnKeyType = .next
        password.delegate = self
        password.returnKeyType = .next
        verifyPassword.delegate = self
        verifyPassword.returnKeyType = .done
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
            scrollView.setContentOffset(CGPoint(x: 0, y: currentOffset), animated: true)
        }
    
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentOffset = scrollView.contentOffset.y
//        print((textField.superview?.frame.origin.y)! + textField.frame.origin.y)
//        print(scrollView.frame.height)
        let textPos = (textField.superview?.frame.origin.y)! + textField.frame.origin.y
        let halfScreen = scrollView.frame.height / 2
        if halfScreen < (textPos + 100) {
            scrollView.setContentOffset(CGPoint(x: 0, y: 100 + textPos - halfScreen), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0)  , animated: true)
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
                self.registerModel.uploadImage(String(describing: profile!.id!), self.img.image!)
                user = profile
            }
        }
        else {
            print("NO PROFILE RETURNED")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.img.contentMode = .scaleAspectFill
            self.img.layer.cornerRadius = self.img.frame.height / 2
            self.img.layer.masksToBounds = false
            self.img.clipsToBounds = true
        })
    }
}
