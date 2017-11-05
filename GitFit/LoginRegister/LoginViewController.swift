import UIKit

class LoginViewController: UIViewController, HomeModelDelegate, UITextFieldDelegate {
    let loginModel = LoginModel()
    var move: CGFloat = 0
    
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
        userEmail.returnKeyType = .next
        userPassword.delegate = self
        userPassword.returnKeyType = .go
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userEmail:
            userPassword.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            loginUser()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textPos = (textField.superview?.superview?.frame.origin.y)! + (textField.superview?.frame.origin.y)! + textField.frame.origin.y
        let halfScreen = UIScreen.main.bounds.height / 2
        if halfScreen < (textPos + 50) {
            move = 50 + textPos - halfScreen
            moveTextField(textField: textField, distance: -move)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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
    
    fileprivate func loginUser() {
        let email = userEmail.text ?? ""
        let password = userPassword.text ?? ""
        
        loginModel.loadProfile(email: email, password: password)
    }
    
    @IBAction func login(_ sender: Any) {
        loginUser()
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
        view.endEditing(true)
        userEmail.text! = ""
        userPassword.text! = ""
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.endEditing(true)
    }
}

