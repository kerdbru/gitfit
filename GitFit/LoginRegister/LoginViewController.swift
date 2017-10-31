import UIKit

let fitBlue = UIColor(displayP3Red: 24/256, green: 184/256, blue: 215/256, alpha: 1)
let fitGray = UIColor(displayP3Red: 188/256, green: 186/256, blue: 190/256, alpha: 1)
var user: Profile?

class LoginViewController: UIViewController, HomeModelDelegate {
    let loginModel = LoginModel()

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
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
    
    fileprivate func setButtonStyle() {
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.clipsToBounds = true
        loginButton.backgroundColor = fitBlue
        
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        registerButton.clipsToBounds = true
        registerButton.backgroundColor = fitGray
    }
    
    fileprivate func setTextFieldStyle() {
        userEmail.layer.borderColor = fitBlue.cgColor
        userEmail.layer.borderWidth = 1.0
        
        userPassword.layer.borderColor = fitBlue.cgColor
        userPassword.layer.borderWidth = 1.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginModel.delegate = self
        setTextFieldStyle()
        setButtonStyle()
    }

    override func viewDidAppear(_ animated: Bool) {
        if user != nil {
            performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
}

