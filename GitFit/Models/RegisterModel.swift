import UIKit

protocol RegisterModelDelegate {
    func createdProfile(profile: Profile?)
    func profilePicUploaded()
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
    
    func uploadImage(_ id: String, _ image: UIImage) {
        let param = ["id": id]
        var imageData: Data
        
        if let val = UIImageJPEGRepresentation(image, 0.5) {
            imageData = val
        }
        else { return }
        
        let requestURL = URL(string: "http://54.197.29.213/fitness/api/uploadprofilepic.php")
        var request = URLRequest(url: requestURL!)
        let boundary = generateBoundaryString()
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "image", imageDataKey: imageData, boundary: boundary) as Data
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                self.dispatchNoProfile()
                return
            }
            
            let message = String(data: data, encoding: String.Encoding.utf8)
            print(message!)
            self.delegate?.profilePicUploaded()
        }.resume()
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
