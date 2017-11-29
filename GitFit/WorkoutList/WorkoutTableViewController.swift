import UIKit

class WorkoutTableViewController: UITableViewController, WorkoutDescriptionModelDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    var workouts: [WorkoutDescription] = []
    let workoutDescriptionModel = WorkoutDescriptionModel()
    var workout: WorkoutDescription?
    var accountId = 0
    @IBOutlet weak var workoutType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutDescriptionModel.delegate = self
        workoutDescriptionModel.loadWorkouts(search: "", type: workoutType.selectedSegmentIndex, accountId: accountId)
        tableView.tableFooterView = UIView()
        self.title = "Workouts"
        addSearchBar()
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        workoutType.addTarget(self, action: #selector(reload), for: .valueChanged)
        workoutType.tintColor = UIColor.gray
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reload()
    }
    
    fileprivate func addSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        let search = searchController.searchBar
        search.delegate = self
        search.placeholder = "Search"
        search.autocapitalizationType = .none
        search.enablesReturnKeyAutomatically = false
        
        self.navigationItem.searchController = searchController
    }
    
    func workoutsLoaded(workouts: [WorkoutDescription]) {
        DispatchQueue.main.async {
            self.workouts = workouts
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workout", for: indexPath)
        let workout = workouts[indexPath.row]
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = workout.name
        let type = cell.viewWithTag(2) as! UIImageView
        switch workout.type! {
        case "Intermediate":
            type.image = #imageLiteral(resourceName: "rating-icon-temp-medium")
        case "Advanced":
            type.image = #imageLiteral(resourceName: "rating-icon-temp-hard")
        default:
            type.image = #imageLiteral(resourceName: "rating-icon-temp-easy")
        }
        
        let review = cell.viewWithTag(8) as! UILabel
        review.text = "(\(workout.ratingCount ?? 0))"
        
        var tag = 3
        var stars: Double = 0.0
        if workout.ratingCount! != 0 {
            stars = Double(workout.ratingSum!) / Double(workout.ratingCount!)
            stars.round()
        }
        
        while stars > 0 {
            let star = cell.viewWithTag(tag) as! UIImageView
            star.image = #imageLiteral(resourceName: "blue_full_star")
            stars -= 1
            tag += 1
        }
        while tag < 8 {
            let star = cell.viewWithTag(tag) as! UIImageView
            star.image = #imageLiteral(resourceName: "blue_empty_star")
            tag += 1
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        workout = workouts[indexPath.row]
        performSegue(withIdentifier: "workoutToExercises", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ExercisesTableViewController
        dest.accountId = workout?.accountId
        dest.workoutId = workout?.id
        dest.name = workout?.name
        dest.creatorId = workout?.accountId
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    @objc func reload() {
        var search = ""
        let searchBar = self.navigationItem.searchController?.searchBar
        if let value = searchBar?.text {
            search = value
        }
        workoutDescriptionModel.loadWorkouts(search: search, type: workoutType.selectedSegmentIndex, accountId: accountId)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        workoutDescriptionModel.loadWorkouts(search: "", type: workoutType.selectedSegmentIndex, accountId: accountId)
    }
}
