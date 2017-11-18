import UIKit

protocol CreateModelDelegate {
    func exercisesLoaded(exercises: [Exercise])
}

class CreateModel: NSObject {
    var delegate: CreateModelDelegate?
    
    let URL_LOAD_EXERCISES = "http://54.197.29.213/fitness/api/getexercises.php"
    
    func loadExercises(search: String) {
        var params = "search=\(search)"
        params = params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let requestUrl = URL(string: URL_LOAD_EXERCISES + "?" + params)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                DispatchQueue.main.async {
                    self.delegate?.exercisesLoaded(exercises: [])
                }
                return
            }
            
            if let exercises = self.parseJson(data: data) {
                DispatchQueue.main.async {
                    self.delegate?.exercisesLoaded(exercises: exercises)
                }
            }
            }.resume()
    }
    
    func parseJson(data: Data) -> [Exercise]? {
        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode([Exercise].self, from: data)
            return json
        } catch {
            print(error)
            return []
        }
    }
}
