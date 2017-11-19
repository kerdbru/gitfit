import UIKit

@objc protocol ImageModelDelegate {
    @objc optional func loadedImage(image: UIImage?)
    @objc optional func profilePicUploaded()
}

let LOAD_PROFILE_IMAGE_URL = "http://54.197.29.213/fitness/uploads/account/"
let LOAD_EXERCISE_IMAGE_URL = "http://54.197.29.213/fitness/uploads/exercises/"

class ImageModel: NSObject {
    var delegate: ImageModelDelegate?
    
    func loadImage(urlString: String) {
        print(urlString)
        let requestURL = URL(string: urlString)
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard let data = data, error == nil, response != nil else {
                print("No image")
                self.delegate?.loadedImage!(image: nil)
                return
            }
            
            if let myImage = UIImage(data: data) {
                DispatchQueue.main.async(execute: {
                    self.delegate?.loadedImage!(image: myImage)
                })
            } else {
                print("NOPE")
                self.delegate?.loadedImage!(image: nil)
            }
        }.resume()
    }
    
    
    func uploadProfilePic(_ id: String, _ image: UIImage) {
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
                return
            }
            
            let message = String(data: data, encoding: String.Encoding.utf8)
            print(message!)
            self.delegate?.profilePicUploaded!()
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
