import UIKit

class CreateTableViewController: UITableViewController, UITextFieldDelegate, NewExerciseDelegate, CreateModelDelegate {
    
    var exercises: [ExerciseOrder] = []
    var selected: Int?
    var createModel = CreateModel()
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var workoutType: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createModel.delegate = self
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addButton
        workoutName.delegate = self
        setDefaultTextFieldStyle(workoutName, fitGray)
        
        self.navigationItem.leftBarButtonItem = editButtonItem

        self.navigationItem.title = "Create Workout"
        workoutType.tintColor = UIColor.gray
        
        setDefaultButtonStyle(submitButton, fitBlue)
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
        super.setEditing(false, animated: true)
        selected = -1
        performSegue(withIdentifier: "createToExercise", sender: self)
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
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createExercise", for: indexPath)
        let exercise = exercises[indexPath.row]
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text! = "\(indexPath.row + 1)) \(exercise.name!)"
        
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
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "createToExercise", sender: self)
    }
    
    func updateArray(_ exercises: [ExerciseOrder]) {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = fitBlue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = fitGray.cgColor
    }
    
    func workoutCreated(id: Int) {
        for index in 0...exercises.count - 1 {
            let exercise = exercises[index]
            var weight = 0, sets = 0
            if let value = exercise.weight {
                weight = value
            }
            if let value = exercise.sets {
                sets = value
            }
            let labelId = getIndex(with: exercise.label!, data: fitLabels)
            createModel.createWorkoutItem(workoutId: id, accountId: user!.id!, position: index + 1, exerciseId: exercise.exerciseId!, labelId: labelId, amount: exercise.amount!, weight: weight, sets: sets)
        }
    }
    
    func getIndex(with value: String, data: [FitPickerItem]) -> Int {
        for i in 0...data.count - 1{
            if data[i].text == value {
                return data[i].id!
            }
        }
        return -1
    }
    
    func showError(){
        let alert = UIAlertController(title: "Error", message: "Please enter valid workout name and at least one exercise", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion:nil)
    }
    
    func exercisesAdded() {
        self.workoutName.text = ""
        self.exercises = []
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.exercises[sourceIndexPath.row]
        exercises.remove(at: sourceIndexPath.row)
        exercises.insert(movedObject, at: destinationIndexPath.row)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            submitButton.isHidden = true
        }
        else {
            submitButton.isHidden = false
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        var valid = true
        
        view.endEditing(true)
        if workoutName.text == "" {
            workoutName.layer.borderColor = fitRed.cgColor
            valid = false
        }
        if exercises.count == 0 {
            valid = false
        }
        
        if valid {
            createModel.createWorkout(name: workoutName.text!, workoutTypeId: workoutType.selectedSegmentIndex + 1, accountId: user!.id!)
        }
        else {
            showError()
        }
    }
}
