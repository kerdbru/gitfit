import UIKit

class ProfileViewController: UIViewController {
    
    var user: Profile?
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func changePassword(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.text! = user?.firstName ?? ""
        lastName.text! = user?.lastName ?? ""
        email.text = user?.email ?? ""
        
        let requestURL = URL(string: "http://54.197.29.213/fitness/uploads/account/\(user!.id!)")
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard let data = data, error == nil, response != nil else { return }
            
            if let myImage = UIImage(data: data) {
                DispatchQueue.main.async(execute: {
                    self.profilePic.image = myImage
                })
            } else {
                print("NOPE")
            }
        }.resume()
        
        firstName.isUserInteractionEnabled = false
        lastName.isUserInteractionEnabled = false
        email.isUserInteractionEnabled = false
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
