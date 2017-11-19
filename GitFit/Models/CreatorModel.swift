import UIKit

protocol CreatorModelDelegate {
    func creatorLoaded(user: Creator?)
}

class CreatorModel: NSObject {
    var delegate: CreatorModelDelegate?
    
    let URL_LOAD_PROFILE = "http://54.197.29.213/fitness/api/getcreator.php"
    
    func loadCreator(id: Int) {
        let params = "id=\(id)"
        let requestUrl = URL(string: URL_LOAD_PROFILE + "?" + params)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                self.dispatchNoProfile()
                return
            }
            
            if let user = self.parseJson(data: data) {
                DispatchQueue.main.async {
                    self.delegate?.creatorLoaded(user: user)
                }
            }
            else {
                self.dispatchNoProfile()
            }
        }.resume()
    }
    
    func dispatchNoProfile() {
        DispatchQueue.main.async {
            self.delegate?.creatorLoaded(user: nil)
        }
    }
    
    func parseJson(data: Data) -> Creator? {
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Creator.self, from: data)
            
            return user
        } catch {
            print(error)
            return nil
        }
    }
}

