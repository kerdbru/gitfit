import UIKit

class ExerciseProfileViewController: UIViewController {
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var viewWorkoutsButton: UIButton!
    var creatorId: Int?
    var profilePic: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
