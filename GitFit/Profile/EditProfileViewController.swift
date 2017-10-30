import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: Profile?
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
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        saveButton.clipsToBounds = true
        saveButton.backgroundColor = fitBlue
    }
    
    func loadTextField() {
        firstName.text = user?.firstName ?? ""
        lastName.text = user?.lastName ?? ""
        email.text = user?.email ?? ""
    }
    
    func setTextFieldStyle() {
        firstName.layer.borderColor = fitBlue.cgColor
        firstName.layer.borderWidth = 1.0
        lastName.layer.borderColor = fitBlue.cgColor
        lastName.layer.borderWidth = 1.0
        email.layer.borderColor = fitBlue.cgColor
        email.layer.borderWidth = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldStyle()
        setButtonStyle()
        loadTextField()
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.masksToBounds = false
        profileImageView.clipsToBounds = true
        profileImageView.image = profileImage
        
        imagePicker.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImageView.addGestureRecognizer(tapRecognizer)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}


