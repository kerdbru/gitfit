import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var profileImage = #imageLiteral(resourceName: "profile_pic_placeholder")
    let imagePicker = UIImagePickerController()
    var move: CGFloat = 0
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    var id: Int?
    var fName: String?
    var lName: String?
    var emailAddr: String?
    var password: String?
    let changePasswordModel = ChangePasswordModel()

    @objc func save() {
        loadValues()
        if firstName.text! != "" && lastName.text! != "" && email.text! != "" {
            changePasswordModel.changePassword(id: id!, firstName: fName!, lastName: lName!, emailAddress: emailAddr!, password: password!)
            user!.firstName = firstName.text!
            user!.lastName = lastName.text!
            user!.email = email.text!
            dismiss(animated: true, completion: nil)
        }
        else {
            showError()
        }
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func loadValues(){
        id = user?.id ?? 0
        fName = firstName.text!
        lName = lastName.text!
        emailAddr = email.text!
        password = user?.password ?? ""
    }
    
    func showError(){
        view.endEditing(true)
        
        if firstName.text! == "" {
            firstName.layer.borderColor = fitRed.cgColor
        }
        if lastName.text! == "" {
            lastName.layer.borderColor = fitRed.cgColor
        }
        if email.text! == "" {
            email.layer.borderColor = fitRed.cgColor
        }

        let alert = UIAlertController(title: "Error", message: "Cannot leave fields empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImage = pickedImage
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
            profileImageView.layer.masksToBounds = false
            profileImageView.clipsToBounds = true
            profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func loadTextField() {
        firstName.text = user?.firstName ?? ""
        lastName.text = user?.lastName ?? ""
        email.text = user?.email ?? ""
    }
    
    func setTextFieldStyle() {
        setDefaultTextFieldStyle(firstName, fitBlue)
        setDefaultTextFieldStyle(lastName, fitBlue)
        setDefaultTextFieldStyle(email, fitBlue)
    }
    
    fileprivate func setProfilePic() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.masksToBounds = false
        profileImageView.clipsToBounds = true
        profileImageView.image = profileImage
    }
    
    fileprivate func addGestureToProfilePic() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.addGestureRecognizer(tapRecognizer)
        profileImageView.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        imagePicker.delegate = self
        setTextFieldStyle()
        loadTextField()
        addGestureToProfilePic()
        
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = fitBlue.cgColor
        let textPos = (textField.superview?.superview?.superview?.superview?.frame.origin.y)! + textField.frame.origin.y
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
    
    override func viewDidAppear(_ animated: Bool) {
        setProfilePic()
    }
    
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        view.endEditing(true)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
            self.profileImageView.layer.masksToBounds = false
            self.profileImageView.clipsToBounds = true
        })
    }
}
