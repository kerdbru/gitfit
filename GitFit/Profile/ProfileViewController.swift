import UIKit

class ProfileViewController: UIViewController, ImageModelDelegate, StatModelDelegate {
    let imageModel = ImageModel()
    @IBOutlet weak var workoutsCreated: UILabel!
    @IBOutlet weak var ratings: UIStackView!
    @IBOutlet weak var totalFavorites: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var myWorkouts: UIButton!
    var statModel = StatModel()
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        let navController = UINavigationController(rootViewController: controller)
        user = nil
        self.present(navController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(true)
        if segue.identifier == "editProfile" {
            let dest = segue.destination.childViewControllers[0] as! EditProfileViewController
            dest.profileImage = profilePic.image!
        }
    }
    
    func loadLabelData() {
        let first = user?.firstName ?? ""
        let last = user?.lastName ?? ""
        self.title = "\(first) \(last)"
    }
    
    func loadedImage(image: UIImage?) {
        if let image = image {
            DispatchQueue.main.async {
                self.profilePic.contentMode = .scaleAspectFill
                self.profilePic.layer.cornerRadius = self.profilePic.frame.height / 2
                self.profilePic.layer.masksToBounds = false
                self.profilePic.clipsToBounds = true
                self.profilePic.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.image = #imageLiteral(resourceName: "profile_pic_placeholder")
        imageModel.delegate = self
        setDefaultButtonStyle(myWorkouts, fitBlue)
        statModel.delegate = self
        statModel.loadStats(id: user!.id!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadLabelData()
//        if let id = user!.id {
//            imageModel.loadImage(urlString: LOAD_PROFILE_IMAGE_URL+"\(id)")
//        }
    }
    
    @IBAction func viewMyWorkouts(_ sender: Any) {
        let storyboard = UIStoryboard(name: "WorkoutList", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "workouts") as? UINavigationController
        let controller = navController?.childViewControllers[0] as! WorkoutTableViewController
        controller.accountId = user!.id!
        controller.title = "My Workouts"
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func statsLoaded(stats: Stats?) {
        var stars: Double = 0.0, i = 0
        if let stats = stats, stats.number! != 0 {
            stars = Double(stats.total!) / Double(stats.number!)
            stars.round()
            let label = ratings.arrangedSubviews[5] as! UILabel
            label.text = "(\(stats.number!))"
        }
        
        while stars > 0 {
            let star = ratings.arrangedSubviews[i] as! UIImageView
            star.image = #imageLiteral(resourceName: "blue_full_star")
            stars -= 1
            i += 1
        }
        while i < 5 {
            let star = ratings.arrangedSubviews[i] as! UIImageView
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
