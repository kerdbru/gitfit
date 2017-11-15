import UIKit

class WorkoutTableViewController: UITableViewController, WorkoutDescriptionModelDelegate, UISearchBarDelegate {
    var workouts: [WorkoutDescription] = []
    let workoutDescriptionModel = WorkoutDescriptionModel()
    var workout: WorkoutDescription?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutDescriptionModel.delegate = self
        workoutDescriptionModel.loadWorkouts(search: "")
        tableView.tableFooterView = UIView()
        addSearchBar()
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text {
            workoutDescriptionModel.loadWorkouts(search: search)
        }
        searchBar.resignFirstResponder()
    }
    
    fileprivate func addSearchBar() {
        let search = UISearchBar()
        search.delegate = self
        search.placeholder = "Search Workouts"
        self.navigationItem.titleView = search
        search.autocapitalizationType = .none
        search.enablesReturnKeyAutomatically = false
    }
    
    @objc func refresh(sender:AnyObject) {
        workoutDescriptionModel.loadWorkouts(search: "")
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
        let type = cell.viewWithTag(2) as! UILabel
        type.text = workout.type
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
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
