import UIKit

class ExercisesTableViewController: UITableViewController, ExerciseOrderModelDelegate {
    var exercises: [ExerciseOrder] = []
    var exerciseOrderModel = ExerciseOrderModel()
    var workoutId: Int?
    var accountId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseOrderModel.delegate = self
        exerciseOrderModel.loadWorkouts(workoutId!, accountId!)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func exerciseLoaded(exercise: [ExerciseOrder]) {
        DispatchQueue.main.async {
            self.exercises = exercise
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exercises.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercise", for: indexPath)
        let exercise = exercises[indexPath.row]
        
        
        let order = cell.viewWithTag(1) as! UILabel
        order.text = "\(exercise.position!)"
        
        let name = cell.viewWithTag(2) as! UILabel
        name.text = exercise.name!
        
        let weight = cell.viewWithTag(3) as! UILabel
        if let lbs = exercise.weight {
            weight.text = "(\(lbs) lbs)"
        }
        
        let label = cell.viewWithTag(4) as! UILabel
        label.text = "\(exercise.amount!) \(exercise.label!)"
        
        let sets = cell.viewWithTag(5) as! UILabel
        sets.text = "\(exercise.sets!) sets"
        
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
