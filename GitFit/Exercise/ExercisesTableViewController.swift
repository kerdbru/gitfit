import UIKit

class ExercisesTableViewController: UITableViewController, ExerciseOrderModelDelegate, RatingModelDelegate, FavoriteModelDelegate, CreatorModelDelegate, ImageModelDelegate {
    var exercises: [ExerciseOrder?] = []
    var exerciseOrderModel = ExerciseOrderModel()
    var workoutId: Int?
    var accountId: Int?
    var creatorId: Int?
    var name: String?
    var starViews: [UIImageView] = []
    let ratingModel = RatingModel()
    let favoriteModel = FavoriteModel()
    var favorite = false
    var exerciseIndex: Int?
    var creatorModel = CreatorModel()
    var imageModel = ImageModel()
    var creator: Creator?
    var creatorPic = #imageLiteral(resourceName: "profile_pic_placeholder")
    var creatorLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteModel.delegate = self
        exerciseOrderModel.delegate = self
        exerciseOrderModel.loadWorkouts(workoutId!, accountId!)
        favoriteModel.checkFavorite(user!.id!, workoutId!)
        tableView.tableFooterView = UIView()
        self.title = name
        ratingModel.delegate = self
        creatorModel.delegate = self
        imageModel.delegate = self
    }
    
    func creatorLoaded(user: Creator?) {
        self.creator = user
        let first = creator?.firstName
        let last = creator?.lastName?.first
    
        if let first = first, let last = last {
            creatorLabel?.text! = "\(first) \(last)."
        }
    }
    
    func loadedImage(image: UIImage?) {
        if let image = image {
            DispatchQueue.main.async {
                self.creatorPic = image
            }
        }
    }
    
    func isFavorite(favorite: Int) {
        var image = #imageLiteral(resourceName: "empty_heart")
        self.favorite = false
        if favorite == 1 {
            image = #imageLiteral(resourceName: "full_heart")
            self.favorite = true
        }
        let fav = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addFav))
        self.navigationItem.rightBarButtonItem = fav
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteModel.checkFavorite(user!.id!, self.workoutId!)
//        imageModel.loadImage(urlString: LOAD_PROFILE_IMAGE_URL + "\(creatorId!)")
    }
    
    @objc func addFav() {
        if favorite {
            favoriteModel.removeFavorite(user!.id!, workoutId!)
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "empty_heart")
            favorite = false
        }
        else {
            favoriteModel.addFavorite(user!.id!, workoutId!, accountId!)
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "full_heart")
            favorite = true
        }
    }
    
    func ratingLoaded(_ rating: Int) {
        self.setRating(rating)
    }

    func exerciseLoaded(exercise: [ExerciseOrder]) {
        DispatchQueue.main.async {
            self.exercises = exercise
            self.exercises.append(nil)
            self.exercises.insert(nil, at: 0)
            self.ratingModel.getRating(user!.id!, self.workoutId!)
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
        var cell: UITableViewCell
        if indexPath.row == exercises.count - 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "rating", for: indexPath)
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            
            for i in 1...5 {
                let star = cell.viewWithTag(i) as! UIImageView
                star.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                star.addGestureRecognizer(tapRecognizer)
                starViews.append(star)
            }
            
            for i in 1...5 {
                let star = cell.viewWithTag(i) as! UIImageView
                star.image = #imageLiteral(resourceName: "blue_empty_star_bigger")
            }
        }
        else if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "creator", for: indexPath)
            cell.accessoryType = .disclosureIndicator
    
            creatorLabel = cell.viewWithTag(2) as? UILabel
            creatorModel.loadCreator(id: creatorId!)
            
            let picView = cell.viewWithTag(1) as! UIImageView
            picView.contentMode = .scaleAspectFill
            picView.layer.cornerRadius = (picView.frame.height) / 2
            picView.layer.masksToBounds = false
            picView.clipsToBounds = true
            picView.image = creatorPic
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "exercise", for: indexPath)
            let exercise = exercises[indexPath.row]!
            cell.accessoryType = .disclosureIndicator
            
            let name = cell.viewWithTag(1) as! UILabel
            name.text! = "\(indexPath.row)) \(exercise.name!)"
            
            var weight = ""
            if let lbs = exercise.weight {
                weight = "\n\(lbs) lbs"
            }
            let label = "\(exercise.amount!) \(exercise.label!)"
            var set = ""
            if exercise.sets! > 1 {
                set = ", \(exercise.sets!) sets"
            }
            
            let detail = cell.viewWithTag(2) as! UILabel
            detail.text! = "\(label)\(set)\(weight)"
        }
        
        return cell
    }
    
    fileprivate func setRating(_ rating: Int) {
        if rating < 1 || rating > 5 {
            return
        }
        let rate = rating - 1
        for i in 0...4 {
            starViews[i].image = #imageLiteral(resourceName: "blue_empty_star_bigger")
        }
        for i in 0...rate {
            starViews[i].image = #imageLiteral(resourceName: "blue_full_star_bigger")
        }
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        let rating = (sender.view?.tag)!
        setRating(rating)
        ratingModel.rateWorkout(user!.id!, workoutId!, rating)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != exercises.count - 1 {
            exerciseIndex = indexPath.row
            performSegue(withIdentifier: "exerciseToDescription", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getInfo() -> String {
        guard let exercise = exercises[exerciseIndex!] else { return "" }
        var weight = ""
        var set = ""
        let label = "\(exercise.amount!) \(exercise.label!)"
        
        if let lbs = exercise.weight {
            weight = ", \(lbs) lbs"
        }
        if exercise.sets! > 1 {
            set = ", \(exercise.sets!) sets"
        }
        
        return "\(label)\(set)\(weight)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ExerciseViewController
        dest.descripe = exercises[exerciseIndex!]?.description
        dest.name = exercises[exerciseIndex!]?.name
        dest.id = exercises[exerciseIndex!]?.exerciseId
        dest.information = getInfo()
    }
}
