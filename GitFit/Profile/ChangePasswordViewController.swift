
import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var currPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var verifyPass: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    var id: Int?
    var move: CGFloat = 0
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var verifyPassword: String?
    var oldPass: String?
    let changePasswordModel = ChangePasswordModel()
    
    fileprivate func changePassword() {
        loadValues()
        if oldPass! == user?.password && password! == verifyPassword! {
            changePasswordModel.changePassword(id: id!, firstName: firstName!, lastName: lastName!, emailAddress: email!, password: password!)
            user!.password = newPass.text
            self.navigationController?.popViewController(animated: true)
        }
        else {
            showError()
            currPass.layer.borderColor = fitRed.cgColor
            newPass.layer.borderColor = fitRed.cgColor
            verifyPass.layer.borderColor = fitRed.cgColor
            currPass.text! = ""
            newPass.text! = ""
            verifyPass.text! = ""
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        changePassword()
    }
    
    func showError(){
        if oldPass! != user?.password {
            view.endEditing(true)
            let alert = UIAlertController(title: "Error", message: "Current password does not match the existing password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion:nil)
        }
        else {
            view.endEditing(true)
            let alert = UIAlertController(title: "Error", message: "New password and verify password does not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion:nil)
        }
    }
    
    func setButtonStyle() {
        setDefaultButtonStyle(submitButton, fitBlue)
    }
    
    func setTextFieldStyle() {
        setDefaultTextFieldStyle(currPass, fitBlue)
        setDefaultTextFieldStyle(newPass, fitBlue)
        setDefaultTextFieldStyle(verifyPass, fitBlue)
    }

    func loadValues() {
        id = user?.id ?? 0
        firstName = user?.firstName ?? ""
        lastName = user?.lastName ?? ""
        email = user?.email ?? ""
        password = newPass.text!
        verifyPassword = verifyPass.text!
        oldPass = currPass.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldStyle()
        setButtonStyle()
        currPass.delegate = self
        currPass.returnKeyType = .next
        newPass.delegate = self
        newPass.returnKeyType = .next
        verifyPass.delegate = self
        verifyPass.returnKeyType = .go
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case currPass:
            newPass.becomeFirstResponder()
        case newPass:
            verifyPass.becomeFirstResponder()
        case verifyPass:
            changePassword()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = fitBlue.cgColor
        let textPos = (textField.superview?.frame.origin.y)! + textField.frame.origin.y
        let halfScreen = UIScreen.main.bounds.height / 2
        if halfScreen < (textPos + 50) {
            move = 50 + textPos - halfScreen
            moveTextField(textField: textField, distance: -move)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = fitGray.cgColor
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.endEditing(true)
    }
}
