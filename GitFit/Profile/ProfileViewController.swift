import UIKit

class ProfileViewController: UIViewController, ImageModelDelegate {
    let imageModel = ImageModel()
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        let navController = UINavigationController(rootViewController: controller)
        user = nil
        self.present(navController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(true)
        if segue.identifier == "editProfile" {
            let dest = segue.destination.childViewControllers[0] as! EditProfileViewController
            dest.profileImage = profilePic.image!
        }
    }
    
    func loadLabelData() {
        let first = user?.firstName ?? ""
        let last = user?.lastName ?? ""
        name.text = "\(first) \(last)"
        email.text = user?.email ?? ""
    }
    
    func loadedImage(image: UIImage?) {
        DispatchQueue.main.async {
            self.profilePic.contentMode = .scaleAspectFill
            self.profilePic.layer.cornerRadius = self.profilePic.frame.height / 2
            self.profilePic.layer.masksToBounds = false
            self.profilePic.clipsToBounds = true
            self.profilePic.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.image = #imageLiteral(resourceName: "profile_pic_placeholder")
        imageModel.delegate = self
//        if let id = user!.id {
//            imageModel.loadImage(urlString: LOAD_PROFILE_IMAGE_URL+"\(id)")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLabelData()
    }
}
