import UIKit

class NewExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CreateModelDelegate, UISearchBarDelegate, ImageModelDelegate {
    
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var units: UITextField!
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var exerciseDescription: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weight: FitTextField!
    @IBOutlet weak var sets: FitTextField!
    
    var pickLabel: UIPickerView?
    var exercises: [ExerciseOrder]?
    var selected: Int?
    var searchController: UISearchController?
    var exerciseList: [Exercise] = []
    var move: CGFloat = 0
    var createModel = CreateModel()
    var imageModel = ImageModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextStyle()
        self.title = "Exercise"
        
        createModel.delegate = self
        imageModel.delegate = self
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        self.navigationItem.rightBarButtonItem = searchButton
        
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
        
        // This code is dumb, but fixes issue with when search controller not showing correctly
        self.present(searchController!, animated: false, completion: nil)
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.present(searchController!, animated: true, completion: nil)
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
        self.present(searchController!, animated: true, completion: nil)
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
        self.title = exerciseList[indexPath.row].name
        self.exerciseDescription.text = exerciseList[indexPath.row].description
        exerciseDescription.sizeToFit()
        var contentRect = CGRect.zero;
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame);
        }
        self.scrollView.contentSize = contentRect.size;
        self.searchController?.searchBar.text = ""
        let id = exerciseList[indexPath.row].id
        // imageModel.loadImage(urlString: LOAD_EXERCISE_IMAGE_URL + "\(id ?? 0)")
        dismiss(animated: true, completion: nil)
    }
}
