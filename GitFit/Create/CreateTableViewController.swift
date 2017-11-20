import UIKit

class CreateTableViewController: UITableViewController, UITextFieldDelegate, NewExerciseDelegate {
    @IBOutlet weak var workoutName: UITextField!
    var exercises: [ExerciseOrder?] = [nil]
    var selected: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutName.delegate = self
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.leftBarButtonItem = saveButton
        
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination.childViewControllers[0] as! NewExerciseViewController
        dest.exercises = exercises
        dest.selected = selected
        dest.delegate = self
    }

    @objc func add() {
        selected = -1
        performSegue(withIdentifier: "createToExercise", sender: self)
    }

    @objc func save() {
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50.0
        }
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "type", for: indexPath)
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "createExercise", for: indexPath)
            let exercise = exercises[indexPath.row]!
            
            let name = cell.viewWithTag(1) as! UILabel
            name.text! = "\(indexPath.row)) \(exercise.name!)"
            
            var weight = ""
            if let lbs = exercise.weight {
                weight = "\n\(lbs) lbs"
            }
            let label = "\(exercise.amount!) \(exercise.label!)"
            var set = ""
            if let sets = exercise.sets, sets > 1 {
                set = ", \(sets) sets"
            }
            
            let detail = cell.viewWithTag(2) as! UILabel
            detail.text! = "\(label)\(set)\(weight)"
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            selected = indexPath.row
            performSegue(withIdentifier: "createToExercise", sender: self)
        }
    }
    
    func updateArray(_ exercises: [ExerciseOrder?]) {
        self.exercises = exercises
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
