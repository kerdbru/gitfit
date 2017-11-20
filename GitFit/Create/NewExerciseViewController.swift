import UIKit

protocol NewExerciseDelegate {
    func updateArray(_ exercises: [ExerciseOrder?])
}

class NewExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CreateModelDelegate, UISearchBarDelegate, ImageModelDelegate, FitPickerDelegate {
    
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var units: UITextField!
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var exerciseDescription: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weight: FitTextField!
    @IBOutlet weak var sets: FitTextField!
    @IBOutlet weak var descripe: UILabel!
    
    var exerciseId: Int?
    var pickLabel: FitPicker?
    var exercises: [ExerciseOrder?]?
    var selected: Int?
    var searchController: UISearchController?
    var exerciseList: [Exercise] = []
    var move: CGFloat = 0
    var createModel = CreateModel()
    var imageModel = ImageModel()
    var delegate: NewExerciseDelegate?
    var exerciseSelected = false

    fileprivate func loadInformation() {
        exerciseSelected = true
        let exercise = exercises![selected!]!
        //let id = exercise.exerciseId
        exerciseId = exercise.exerciseId
//        imageModel.loadImage(urlString: LOAD_EXERCISE_IMAGE_URL + "\(id ?? 0)")
        descripe.text = "Description"
        self.title = exercise.name
        exerciseDescription.text = exercise.description
        if let value = exercise.amount {
            units.text = "\(value)"
        }
        if let value = exercise.label {
            label.text = "\(value)"
            pickLabel?.set(with: "\(value)")
        }
        if let value = exercise.sets {
            sets.text = "\(value)"
        }
        if let value = exercise.weight {
            weight.text = "\(value)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextStyle()
        self.title = "Exercise"
        
        createModel.delegate = self
        imageModel.delegate = self
        
        let resultsController = UITableViewController(style: .plain)
        resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
        resultsController.tableView.tableFooterView = UIView()
        resultsController.tableView.contentInsetAdjustmentBehavior = .never
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchBar.placeholder = "Search exercises"
        searchController?.searchBar.autocapitalizationType = .none
        searchController?.searchBar.delegate = self
        searchController?.hidesNavigationBarDuringPresentation = false
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        addRightView(textfield: sets, string: "sets")
        addRightView(textfield: weight, string: "lbs")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeExercise))
        tapGesture.numberOfTapsRequired = 1
        self.navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        
        if selected! > -1 {
            loadInformation()
        }
        else {
            self.present(searchController!, animated: true, completion: nil)
        }
        
    }
    
    @objc func changeExercise(_ sender: Any) {
        self.present(searchController!, animated: true, completion: nil)
    }
    
    @objc func save() {
        var valid = true
        if label.text == "" {
            valid = false
            label.layer.borderColor = fitRed.cgColor
        }
        if units.text == "" {
            valid = false
            units.layer.borderColor = fitRed.cgColor
        }
        
        if valid && exerciseSelected {
            let exercise = getExercise()
            if selected! < 0 {
                exercises?.append(exercise)
            }
            else {
                exercises![selected!] = exercise
            }
            delegate?.updateArray(exercises!)
            dismiss(animated: true, completion: nil)
        }
        else {
            showError(message: "Please select an exercise and fill out all required fields")
        }
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func exercisesLoaded(exercises: [Exercise]) {
        DispatchQueue.main.async {
            self.exerciseList = exercises
            let tableViewController = self.searchController?.searchResultsController as! UITableViewController
            tableViewController.tableView.reloadData()
        }
    }
    
    func loadedImage(image: UIImage?) {
        DispatchQueue.main.async {
            self.exerciseImageView.image = image
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        createModel.loadExercises(search: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = fitBlue.cgColor
        var textPos:CGFloat = 0
        textPos = (textField.superview?.superview?.frame.origin.y)! + textField.frame.origin.y

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
        pickLabel = FitPicker(textfield: label, pickerData: [FitPickerItem(text: "reps", id: 1), FitPickerItem(text: "mins", id: 2)])
        pickLabel?.fitDelegate = self
        setDefaultTextFieldStyle(weight, fitGray)
        weight.delegate = self
        setToolBar(textfield: weight)
        setDefaultTextFieldStyle(sets, fitGray)
        sets.delegate = self
        setToolBar(textfield: sets)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let id = exerciseList[indexPath.row].id
        // imageModel.loadImage(urlString: LOAD_EXERCISE_IMAGE_URL + "\(id ?? 0)")
        descripe.text = "Description"
        self.title = exerciseList[indexPath.row].name
        exerciseId = exerciseList[indexPath.row].id
        exerciseSelected = true
        exerciseDescription.text = exerciseList[indexPath.row].description
        resizeScrollView()
        self.searchController?.searchBar.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    
    func showError(message: String){
        view.endEditing(true)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion:nil)
    }
    
    func getExercise() -> ExerciseOrder {
        var sets: Int? = nil, weight: Int? = nil
        let pos = (exercises?.count)! + 1
        let amount = Int(units.text!)
        if self.weight.text != "" {
            weight = Int(self.weight.text!)!
        }
        if self.sets.text != "" {
            sets = Int(self.sets.text!)!
        }
        let label = pickLabel?.pickerData[(pickLabel?.selected)!].text
        let name = self.title
        let exerciseDescription = self.exerciseDescription.text
        
        return ExerciseOrder(id: -1, position: pos, amount: amount, weight: weight, sets: sets, label: label, name: name, description: exerciseDescription, exerciseId: exerciseId)
    }
    
    func resizeScrollView() {
        exerciseDescription.sizeToFit()
        var contentRect = CGRect.zero;
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame);
        }
        self.scrollView.contentSize = contentRect.size;
    }
    
    func addRightView(textfield: UITextField, string: String) {
        let myLabel = UILabel()
        myLabel.text = string
        myLabel.sizeToFit()
        let labelSize = myLabel.frame.size
        textfield.rightViewMode = .always
        myLabel.frame = CGRect(x: 0.0, y: 0.0, width: labelSize.width + 10.0, height: labelSize.height)
        myLabel.contentMode = .center
        myLabel.font = UIFont(name: "Avenir", size: 18.0)
        textfield.rightView = myLabel
    }
    
    func userHitDone(selectedRow: Int) {
        units.placeholder = "*\(pickLabel?.pickerData[selectedRow].text?.firstUpper ?? "Value")"
    }
}
