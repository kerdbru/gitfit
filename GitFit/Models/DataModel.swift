import Foundation

protocol DataModelDelegate {
    func labelsLoaded(labels: [FitPickerItem])
}

class DataModel: NSObject {
    var delegate: DataModelDelegate?

    let URL_LOAD_LABELS = "http://54.197.29.213/fitness/api/getlabels.php"
    
    func loadLabels() {
        let requestUrl = URL(string: URL_LOAD_LABELS)
        var request = URLRequest(url: requestUrl!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil, response != nil else {
                print("error in url session")
                DispatchQueue.main.async {
                    self.delegate?.labelsLoaded(labels: [])
                }
                return
            }
            
            if let labels = self.parseLabel(data: data) {
                DispatchQueue.main.async {
                    self.delegate?.labelsLoaded(labels: labels)
                }
            }
        }.resume()
    }

    func parseLabel(data: Data) -> [FitPickerItem]? {
        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode([FitPickerItem].self, from: data)
            return json
        } catch {
            print(error)
            return []
        }
    }
}
