import UIKit

@objc protocol CreateModelDelegate {
    @objc optional func exercisesLoaded(exercises: [Exercise])
    @objc optional func workoutCreated(id: Int)
    @objc optional func exercisesAdded()
}

class CreateModel: NSObject {
    var delegate: CreateModelDelegate?
    
    let URL_CREATE_WORKOUT = "http://54.197.29.213/fitness/api/createworkout.php"
    let URL_LOAD_EXERCISES = "http://54.197.29.213/fitness/api/getexercises.php"
    let URL_CREATE_WORKOUT_ITEM = "http://54.197.29.213/fitness/api/addworkoutitem.php"
    
    func createWorkout(name: String, workoutTypeId: Int, accountId: Int) {
        let requestUrl = URL(string: URL_CREATE_WORKOUT)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "POST"
        let postParameters = "name=\(name)&type=\(workoutTypeId)&accountId=\(accountId)"
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                return
            }
            
            DispatchQueue.main.async {
                let workoutId = String(data: data, encoding: .utf8)
                self.delegate?.workoutCreated!(id: Int(workoutId!)!)
            }
        }.resume()
    }
    
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
                    self.delegate?.exercisesLoaded!(exercises: [])
                }
                return
            }
            
            if let exercises = self.parseJson(data: data) {
                DispatchQueue.main.async {
                    self.delegate?.exercisesLoaded!(exercises: exercises)
                }
            }
            }.resume()
    }
    
    func createWorkoutItem(workoutId: Int, accountId: Int, position: Int, exerciseId: Int, labelId: Int, amount: Int, weight: Int, sets: Int) {
        let requestUrl = URL(string: URL_CREATE_WORKOUT_ITEM)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "POST"
        let postParameters = "workoutId=\(workoutId)&accountId=\(accountId)&position=\(position)&exerciseId=\(exerciseId)&labelId=\(labelId)&amount=\(amount)&weight=\(weight)&sets=\(sets)"
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                return
            }
            
            DispatchQueue.main.async {
                let _ = String(data: data, encoding: .utf8)
                self.delegate?.exercisesAdded!()
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
