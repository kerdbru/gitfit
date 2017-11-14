import UIKit

class ExercisesTableViewController: UITableViewController, ExerciseOrderModelDelegate, RatingModelDelegate, FavoriteModelDelegate {
    var exercises: [ExerciseOrder] = []
    var exerciseOrderModel = ExerciseOrderModel()
    var workoutId: Int?
    var accountId: Int?
    var name: String?
    var starViews: [UIImageView] = []
    let ratingModel = RatingModel()
    let favoriteModel = FavoriteModel()
    var favorite = false
    var exerciseIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteModel.delegate = self
        exerciseOrderModel.delegate = self
        exerciseOrderModel.loadWorkouts(workoutId!, accountId!)
        favoriteModel.checkFavorite(user!.id!, workoutId!)
        tableView.tableFooterView = UIView()
        self.title = name
        ratingModel.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        favoriteModel.checkFavorite(user!.id!, workoutId!)
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
            self.exercises.append(ExerciseOrder())
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
        if indexPath.row != exercises.count - 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "exercise", for: indexPath)
            let exercise = exercises[indexPath.row]
        
            let name = cell.viewWithTag(1) as! UILabel
            name.text! = "\(indexPath.row + 1)) \(exercise.name!)"
        
            var weight = ""
            if let lbs = exercise.weight {
                weight = "\n\(lbs) lbs"
            }
            let label = "\(exercise.amount!) \(exercise.label!)"
            var set = ""
            if exercise.sets! > 1 {
                set = " / \(exercise.sets!) sets"
            }
        
            let detail = cell.viewWithTag(2) as! UILabel
            detail.text! = "\(label)\(set)\(weight)"
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "rating", for: indexPath)
            cell.selectionStyle = .none
            
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
        return 55.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exerciseIndex = indexPath.row
        performSegue(withIdentifier: "exerciseToDescription", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ExerciseViewController
        dest.descripe = exercises[exerciseIndex!].description
        dest.name = exercises[exerciseIndex!].name
        dest.id = exercises[exerciseIndex!].exerciseId
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
