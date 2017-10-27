import UIKit

let fitBlue = UIColor(displayP3Red: 24/256, green: 184/256, blue: 215/256, alpha: 1)
let fitGray = UIColor(displayP3Red: 188/256, green: 186/256, blue: 190/256, alpha: 1)

class LoginViewController: UIViewController, HomeModelDelegate {
    
    var user: Profile?
    var fromRegister: Bool?
    let loginModel = LoginModel()

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBAction func login(_ sender: Any) {
        let email = userEmail.text ?? ""
        let password = userPassword.text ?? ""
        
        loginModel.loadProfile(email: email, password: password)
    }
    
    func showError(){
        let alert = UIAlertController(title: "Error", message: "Please enter valid email and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion:nil)
    }
    
    func profileLoaded(profile: Profile?) {
        if(profile != nil) {
            user = profile
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
        }
        else{
            showError()
            userEmail.text! = ""
            userPassword.text! = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "loginToHome") {
            let tabs = segue.destination as! UITabBarController
            let nav = tabs.childViewControllers[0] as! UINavigationController
            let profileView = nav.childViewControllers[0] as! ProfileViewController
            profileView.user = user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginModel.delegate = self
        userEmail.layer.borderColor = fitBlue.cgColor
        userEmail.layer.borderWidth = 1.0
        
        userPassword.layer.borderColor = fitBlue.cgColor
        userPassword.layer.borderWidth = 1.0
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        if let value = fromRegister {
            if value {
                performSegue(withIdentifier: "loginToHome", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

