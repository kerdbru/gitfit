import UIKit

class ExerciseProfileViewController: UIViewController, StatModelDelegate {
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var viewWorkoutsButton: UIButton!
    @IBOutlet weak var rating: UIStackView!
    @IBOutlet weak var workoutsCreated: UILabel!
    @IBOutlet weak var totalFavorites: UILabel!
    
    var creatorId: Int?
    var profilePic: UIImage?
    var statModel = StatModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statModel.delegate = self
        statModel.loadStats(id: creatorId!)
        setProfilePic()
        setDefaultButtonStyle(viewWorkoutsButton, fitBlue)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewWorkouts(_ sender: Any) {
        let storyboard = UIStoryboard(name: "WorkoutList", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "workouts") as? UINavigationController
        let controller = navController?.childViewControllers[0] as! WorkoutTableViewController
        controller.accountId = creatorId!
        controller.title = "My Workouts"
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func setProfilePic() {
        profilePicView.contentMode = .scaleAspectFill
        profilePicView.layer.cornerRadius = profilePicView.frame.height / 2
        profilePicView.layer.masksToBounds = false
        profilePicView.clipsToBounds = true
        profilePicView.image = profilePic
    }
    
    func statsLoaded(stats: Stats?) {
        var stars: Double = 0.0, i = 0
        if let stats = stats, stats.number! != 0 {
            stars = Double(stats.total!) / Double(stats.number!)
            stars.round()
            let label = rating.arrangedSubviews[5] as! UILabel
            label.text = "(\(stats.number!))"
        }
        
        while stars > 0 {
            let star = rating.arrangedSubviews[i] as! UIImageView
            star.image = #imageLiteral(resourceName: "blue_full_star")
            stars -= 1
            i += 1
        }
        while i < 5 {
            let star = rating.arrangedSubviews[i] as! UIImageView
            star.image = #imageLiteral(resourceName: "blue_empty_star")
            i += 1
        }
        
        workoutsCreated.text = "Workouts created: \(stats?.creations! ?? 0)"
        if let fav = stats?.favorites {
            var time = "times"
            if fav == 1 {
                time = "time"
            }
            totalFavorites.text = "Favorited \(fav) \(time)!"
        }
    }
}
