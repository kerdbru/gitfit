import UIKit

class NewExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CreateModelDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var units: UITextField!
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var sets: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var exerciseDescription: UILabel!
    
    var pickLabel: UIPickerView?
    var exercises: [ExerciseOrder]?
    var selected: Int?
    let resultsController = UITableViewController(style: .plain)
    var exerciseList: [Exercise] = []
    var move: CGFloat = 0
    var createModel = CreateModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextStyle()
        self.title = "Exercise"
        
        createModel.delegate = self
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        self.navigationItem.rightBarButtonItem = searchButton
        
        resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
        resultsController.tableView.tableFooterView = UIView()
        
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.placeholder = "Search exercises"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    func exercisesLoaded(exercises: [Exercise]) {
        DispatchQueue.main.async {
            self.exerciseList = exercises
            self.resultsController.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        createModel.loadExercises(search: searchText)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = fitBlue.cgColor
        var textPos:CGFloat = 0
        if textField != weight {
            textPos = (textField.superview?.superview?.frame.origin.y)! + textField.frame.origin.y
        }
        else {
            textPos = (textField.superview?.frame.origin.y)! + textField.frame.origin.y
        }
        let halfScreen = UIScreen.main.bounds.height / 2
        if halfScreen < (textPos + 50) {
            move = 50 + textPos - halfScreen
            moveTextField(textField: textField, distance: -move)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = fitGray.cgColor
        if move != 0 {
            moveTextField(textField: textField, distance: move)
            move = 0
        }
    }
    
    func moveTextField(textField: UITextField, distance: CGFloat) {
        let moveDuration = 0.3
        
        UIView.beginAnimations("animageTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: distance)
        UIView.commitAnimations()
    }
    
    func setToolBar(textfield: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        //toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(done))
        
        toolBar.setItems([spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        textfield.inputAccessoryView = toolBar
    }
    
    @objc func done() {
        view.endEditing(true)
    }
    
    func setTextStyle() {
        setDefaultTextFieldStyle(units, fitGray)
        units.delegate = self
        setToolBar(textfield: units)
        setDefaultTextFieldStyle(label, fitGray)
        label.delegate = self
        pickLabel = FitPicker(textfield: label, pickerData: [topping(text: "Reps", id: 1)])
        setDefaultTextFieldStyle(weight, fitGray)
        weight.delegate = self
        setToolBar(textfield: weight)
        setDefaultTextFieldStyle(sets, fitGray)
        sets.delegate = self
        setToolBar(textfield: sets)
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
        
        cell.textLabel?.text = exerciseList[indexPath.row].name
        
        return cell
    }
}
