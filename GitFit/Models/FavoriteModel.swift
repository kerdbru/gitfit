import UIKit

protocol FavoriteModelDelegate {
    func favoritesLoaded(favorites: [Favorite])
}

class FavoriteModel: NSObject {
    var delegate: FavoriteModelDelegate?
    
    let URL_FAVORITES = "http://54.197.29.213/fitness/api/getfavorites.php"
    
    func loadWorkouts(_ accountId: Int) {
        let params = "accountId=\(accountId)"
        let requestUrl = URL(string: URL_FAVORITES + "?" + params)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                DispatchQueue.main.async {
                    self.delegate?.favoritesLoaded(favorites: [])
                }
                return
            }
            
            if let favorites = self.parseJson(data: data) {
                DispatchQueue.main.async {
                    self.delegate?.favoritesLoaded(favorites: favorites)
                }
            }
        }.resume()
    }
    
    func parseJson(data: Data) -> [Favorite]? {
        do {
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([Favorite].self, from: data)
            return workouts
        } catch {
            print(error)
            return []
        }
    }
}

