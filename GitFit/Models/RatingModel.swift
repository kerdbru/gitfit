import UIKit

protocol RatingModelDelegate {
    func ratingLoaded(_ rating: Int)
}

class RatingModel: NSObject {
    var delegate: RatingModelDelegate?
    
    let URL_RATE_WORKOUT = "http://54.197.29.213/fitness/api/rateworkout.php"
    let URL_GET_RATING = "http://54.197.29.213/fitness/api/getrating.php"
    
    func rateWorkout(_ accountId: Int, _ workoutId: Int, _ rating: Int) {
        let requestUrl = URL(string: URL_RATE_WORKOUT)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "POST"
        let postParameters = "accountId=\(accountId)&workoutId=\(workoutId)&rating=\(rating)"
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                return
            }
            
            print("Rated: \(String(data: data, encoding: .utf8) ?? "")")
        }.resume()
    }
    
    func getRating(_ accountId: Int, _ workoutId: Int) {
        let params = "accountId=\(accountId)&workoutId=\(workoutId)"
        let requestUrl = URL(string: URL_GET_RATING + "?" + params)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                return
            }
            
            DispatchQueue.main.async {
                let rating = String(data: data, encoding: .utf8)
                self.delegate?.ratingLoaded(Int(rating!)!)
            }
        }.resume()
    }
}

