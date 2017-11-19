import UIKit

protocol ImageModelDelegate {
    func loadedImage(image: UIImage?)
}

let LOAD_PROFILE_IMAGE_URL = "http://54.197.29.213/fitness/uploads/account/"
let LOAD_EXERCISE_IMAGE_URL = "http://54.197.29.213/fitness/uploads/exercises/"

class ImageModel: NSObject {
    var delegate: ImageModelDelegate?
    
    func loadImage(urlString: String) {
        let requestURL = URL(string: urlString)
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard let data = data, error == nil, response != nil else {
                print("No image")
                self.delegate?.loadedImage(image: nil)
                return
            }
            
            if let myImage = UIImage(data: data) {
                DispatchQueue.main.async(execute: {
                    self.delegate?.loadedImage(image: myImage)
                })
            } else {
                print("NOPE")
                self.delegate?.loadedImage(image: nil)
            }
        }.resume()
    }
}
