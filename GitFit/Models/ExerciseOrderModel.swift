import UIKit

protocol ExerciseOrderModelDelegate {
    func exerciseLoaded(exercise: [ExerciseOrder])
}

class ExerciseOrderModel: NSObject {
    var delegate: ExerciseOrderModelDelegate?
    
    let URL_LOAD_EXERCISES_ORDER = "http://54.197.29.213/fitness/api/getexerciseorder.php"
    
    func loadWorkouts(_ workoutId: Int, _ accountId: Int) {
        let params = "workoutId=\(workoutId)&accountId=\(accountId)"
        let requestUrl = URL(string: URL_LOAD_EXERCISES_ORDER + "?" + params)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                DispatchQueue.main.async {
                    self.delegate?.exerciseLoaded(exercise: [])
                }
                return
            }
            
            if let exercises = self.parseJson(data: data) {
                DispatchQueue.main.async {
                    self.delegate?.exerciseLoaded(exercise: exercises)
                }
            }
            }.resume()
    }
    
    func parseJson(data: Data) -> [ExerciseOrder]? {
        do {
            let decoder = JSONDecoder()
            let exercises = try decoder.decode([ExerciseOrder].self, from: data)
            return exercises
        } catch {
            print(error)
            return []
        }
    }
}
