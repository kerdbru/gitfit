import UIKit

protocol WorkoutDescriptionModelDelegate {
    func workoutsLoaded(workouts: [WorkoutDescription])
}

class WorkoutDescriptionModel: NSObject {
    var delegate: WorkoutDescriptionModelDelegate?
    
    let URL_LOAD_WORKOUTS = "http://54.197.29.213/fitness/api/getworkoutdescriptions.php"
    
    func loadWorkouts(search: String) {
        let params = "search=\(search)"
        let requestUrl = URL(string: URL_LOAD_WORKOUTS + "?" + params)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                DispatchQueue.main.async {
                    self.delegate?.workoutsLoaded(workouts: [])
                }
                return
            }
            
            if let workouts = self.parseJson(data: data) {
                DispatchQueue.main.async {
                    self.delegate?.workoutsLoaded(workouts: workouts)
                }
            }
        }.resume()
    }
    
    func parseJson(data: Data) -> [WorkoutDescription]? {
        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([WorkoutDescription].self, from: data)
            return workouts
        } catch {
            print(error)
            return []
        }
    }
}
