import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: Profile?
    var profileImage = #imageLiteral(resourceName: "profile_pic_placeholder")
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBAction func changePassword(_ sender: Any) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePic.contentMode = .scaleAspectFill
            profilePic.layer.cornerRadius = profilePic.frame.height / 2
            profilePic.layer.masksToBounds = false
            profilePic.clipsToBounds = true
            profilePic.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func editToggle() {
        let val = editButton.isEnabled ? false: true
        setEdit(!val)
        editButton.isEnabled = val
        saveButton.isHidden = val
        cancelButton.isHidden = val
        profilePic.isUserInteractionEnabled = !val
    }
    
    @IBAction func edit(_ sender: Any) {
        editToggle()
    }
    
    @IBAction func save(_ sender: Any) {
    }
    
    @IBAction func cancel(_ sender: Any) {
        loadTextField()
        editToggle()
        profilePic.image = profileImage
    }
    
    func setTextFieldColor() {
        firstName.layer.borderColor = fitBlue.cgColor
        firstName.layer.borderWidth = 1.0
        
        lastName.layer.borderColor = fitBlue.cgColor
        lastName.layer.borderWidth = 1.0
        
        email.layer.borderColor = fitBlue.cgColor
        email.layer.borderWidth = 1.0
    }
    
    func loadProfileImage() {
        let requestURL = URL(string: "http://54.197.29.213/fitness/uploads/account/\(user!.id!)")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard let data = data, error == nil, response != nil else { return }
            
            if let myImage = UIImage(data: data) {
                DispatchQueue.main.async(execute: {
                    self.profileImage = myImage
                    self.profilePic.contentMode = .scaleAspectFill
                    self.profilePic.layer.cornerRadius = self.profilePic.frame.height / 2
                    self.profilePic.layer.masksToBounds = false
                    self.profilePic.clipsToBounds = true
                    self.profilePic.image = myImage
                })
            } else {
                print("NOPE")
            }
        }.resume()
    }
    
    func setEdit(_ val: Bool) {
        firstName.isUserInteractionEnabled = val
        lastName.isUserInteractionEnabled = val
        email.isUserInteractionEnabled = val
    }
    
    fileprivate func setButtons() {
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        saveButton.clipsToBounds = true
        saveButton.backgroundColor = fitBlue
        saveButton.isHidden = true
        
        cancelButton.layer.cornerRadius = saveButton.frame.height / 2
        cancelButton.clipsToBounds = true
        cancelButton.backgroundColor = fitGray
        cancelButton.isHidden = true
    }
    
    func loadTextField() {
        firstName.text! = user?.firstName ?? ""
        lastName.text! = user?.lastName ?? ""
        email.text = user?.email ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTextField()
        setTextFieldColor()
        loadProfileImage()
        setButtons()
        setEdit(false)
        
        imagePicker.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profilePic.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}
