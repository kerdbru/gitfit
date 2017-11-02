import UIKit

class LoginViewController: UIViewController, HomeModelDelegate, UITextFieldDelegate {
    let loginModel = LoginModel()

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginModel.delegate = self
        setTextFieldStyle()
        setButtonStyle()
        
        userEmail.delegate = self
        userPassword.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
        setDefaultButtonStyle(loginButton, fitBlue)
        setDefaultButtonStyle(registerButton, fitGray)
    }
    
    fileprivate func setTextFieldStyle() {
        setDefaultTextFieldStyle(userEmail, fitBlue)
        setDefaultTextFieldStyle(userPassword, fitBlue)
    }

    override func viewDidAppear(_ animated: Bool) {
        if user != nil {
            performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        userEmail.text! = ""
        userPassword.text! = ""
    }
}

