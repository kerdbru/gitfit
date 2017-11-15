import UIKit

class NewExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var exercises: [ExerciseOrder]?
    var selected: Int?
    let resultsController = UITableViewController(style: .plain)
    var exerciseList = ["Pull-up", "Push-up"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let edit = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        self.navigationItem.rightBarButtonItem = edit
        
        resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
        resultsController.tableView.tableFooterView = UIView()
        
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.placeholder = "Search exercises"
        searchController.searchBar.autocapitalizationType = .none
        self.present(searchController, animated: true, completion: nil)
    }
    
    @objc func search() {
        let searchController = UISearchController(searchResultsController: resultsController)
        self.present(searchController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "newExercise")
        
        cell.textLabel?.text = exerciseList[indexPath.row]
        
        return cell
    }
}
