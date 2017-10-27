import UIKit

protocol HomeModelDelegate {
    func profileLoaded(profile: Profile?)
}

class LoginModel: NSObject {
    var delegate: HomeModelDelegate?
    
    let URL_LOAD_PROFILE = "http://54.197.29.213/fitness/api/getaccount.php"
    
    func loadProfile(email: String, password: String) {
        let params = "email=" + email + "&password=" + password
        let requestUrl = URL(string: URL_LOAD_PROFILE + "?" + params)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                self.dispatchNoProfile()
                return
            }
            
            if let user = self.parseJson(data: data) {
                DispatchQueue.main.async {
                    self.delegate?.profileLoaded(profile: user)
                }
            }
            else {
                self.dispatchNoProfile()
            }
        }.resume()
    }
    
    func dispatchNoProfile() {
        DispatchQueue.main.async {
            self.delegate?.profileLoaded(profile: nil)
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
