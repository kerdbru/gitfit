import UIKit

class WorkoutTableViewController: UITableViewController, WorkoutDescriptionModelDelegate {
    var workouts: [WorkoutDescription] = []
    let workoutDescriptionModel = WorkoutDescriptionModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutDescriptionModel.delegate = self
        workoutDescriptionModel.loadWorkouts()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func workoutsLoaded(workouts: [WorkoutDescription]) {
        DispatchQueue.main.async {
            self.workouts = workouts
            self.tableView.reloadData()
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
            star.image = #imageLiteral(resourceName: "full_star")
            stars -= 1
            tag += 1
        }
        while tag < 8 {
            let star = cell.viewWithTag(tag) as! UIImageView
            star.image = #imageLiteral(resourceName: "empty_star")
            tag += 1
        }
        

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
