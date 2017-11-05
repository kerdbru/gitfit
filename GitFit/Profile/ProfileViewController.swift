import UIKit

class ProfileViewController: UIViewController {
    
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
            let dest = segue.destination as! EditProfileViewController
            dest.profileImage = profilePic.image!
        }
    }
    
    func loadProfileImage() {
        let requestURL = URL(string: "http://54.197.29.213/fitness/uploads/account/\(user!.id!)")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard let data = data, error == nil, response != nil else {
                print("No image")
                return
            }
            
            if let myImage = UIImage(data: data) {
                DispatchQueue.main.async(execute: {
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
    
    func loadLabelData() {
        let first = user?.firstName ?? ""
        let last = user?.lastName ?? ""
        name.text = "\(first) \(last)"
        email.text = user?.email ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLabelData()
        profilePic.image = #imageLiteral(resourceName: "profile_pic_placeholder")
        // loadProfileImage()
    }
}
