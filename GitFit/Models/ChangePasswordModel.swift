
import UIKit

protocol ChangePasswordModelDelegate {
    func passwordChanged(profile: Profile?)
}

class ChangePasswordModel: NSObject {
    var delegate: ChangePasswordModelDelegate?

    let URL_UPDATE_PROFILE = "http://54.197.29.213/fitness/api/updateaccount.php"

    func changePassword(id: Int, firstName: String, lastName: String, emailAddress: String, password: String) {
        let requestUrl = URL(string: URL_UPDATE_PROFILE)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "PUT"
        let postParameters = "id=" + String(id) + "&firstName=" + firstName + "&lastName=" + lastName + "&email=" + emailAddress + "&password=" + password
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                self.dispatchNoProfile()
                return
            }
            
            if let user = self.parseJson(data: data) {
                DispatchQueue.main.async {
                    self.delegate?.passwordChanged(profile: user)
                }
            }
            else {
                self.dispatchNoProfile()
            }
        }.resume()
    }
    
    func dispatchNoProfile() {
        DispatchQueue.main.async {
            self.delegate?.passwordChanged(profile: nil)
        }
    }
    
    func parseJson(data: Data) -> Profile? {
        do {
            let decoder = JSONDecoder()
            let users = try decoder.decode([Profile].self, from: data)
            
            if users.count > 0 {
                return users[0]
            }
            else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
}
