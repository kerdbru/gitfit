import UIKit

protocol RegisterModelDelegate {
    func createdProfile(profile: Profile?)
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

class RegisterModel: NSObject {
    var delegate: RegisterModelDelegate?
    
    let URL_CREATE_PROFILE = "http://54.197.29.213/fitness/api/createaccount.php"
    
    func createProfile(firstName: String, lastName: String, emailAddress: String, password: String) {
        let requestUrl = URL(string: URL_CREATE_PROFILE)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "POST"
        let postParameters = "firstName=" + firstName + "&lastName=" + lastName + "&email=" + emailAddress + "&password=" + password
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
                    self.delegate?.createdProfile(profile: user)
                }
            }
            else {
                self.dispatchNoProfile()
            }
        }.resume()
        
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
    
    func dispatchNoProfile() {
        DispatchQueue.main.async {
            self.delegate?.createdProfile(profile: nil)
        }
    }
}
