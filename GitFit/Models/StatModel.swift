import UIKit

protocol StatModelDelegate {
    func statsLoaded(stats: Stats?)
}

class StatModel: NSObject {
    var delegate: StatModelDelegate?
    
    let URL_LOAD_STATS = "http://54.197.29.213/fitness/api/getstats.php"
    
    func loadStats(id: Int) {
        let params = "id=\(id)"
        let requestUrl = URL(string: URL_LOAD_STATS + "?" + params)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                self.delegate?.statsLoaded(stats: nil)
                return
            }
            
            let stats = self.parseJson(data: data) 
            DispatchQueue.main.async {
                self.delegate?.statsLoaded(stats: stats)
            }
        }.resume()
    }
    
    func parseJson(data: Data) -> Stats? {
        do {
            let decoder = JSONDecoder()
            let stats = try decoder.decode(Stats.self, from: data)
            return stats
        } catch {
            print(error)
            return nil
        }
    }
}
