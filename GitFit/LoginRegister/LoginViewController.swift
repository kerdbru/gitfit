import UIKit

class LoginViewController: UIViewController, HomeModelDelegate, UITextFieldDelegate {
    let loginModel = LoginModel()
    var currentOffset: CGFloat = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
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
        userPassword.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userEmail:
            userPassword.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0, y: currentOffset), animated: true)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentOffset = scrollView.contentOffset.y
        print((textField.superview?.superview?.frame.origin.y)! + (textField.superview?.frame.origin.y)!  + textField.frame.origin.y)
                print(scrollView.frame.height)
        let textPos = (textField.superview?.superview?.frame.origin.y)! + (textField.superview?.frame.origin.y)! + textField.frame.origin.y
        let halfScreen = scrollView.frame.height / 2
        if halfScreen < (textPos + 100) {
            scrollView.setContentOffset(CGPoint(x: 0, y: 100 + textPos - halfScreen), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0)  , animated: true)
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

