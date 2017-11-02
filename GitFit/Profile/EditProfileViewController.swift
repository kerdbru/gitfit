import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var profileImage = #imageLiteral(resourceName: "profile_pic_placeholder")
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func save(_ sender: Any) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
            profileImageView.layer.masksToBounds = false
            profileImageView.clipsToBounds = true
            profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func setButtonStyle() {
        setDefaultButtonStyle(saveButton, fitBlue)
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
        imagePicker.delegate = self
        setTextFieldStyle()
        setButtonStyle()
        loadTextField()
        addGestureToProfilePic()
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
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.profileImageView.contentMode = .scaleAspectFill
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
            self.profileImageView.layer.masksToBounds = false
            self.profileImageView.clipsToBounds = true
        })
    }
}
