import UIKit

class ExploreViewController: UIViewController, CreateModelDelegate, ImageModelDelegate {
    @IBOutlet weak var featuredExercise: UIImageView!
    @IBOutlet weak var featuredUser: UIImageView!
    @IBOutlet weak var exerciseName: UILabel!
    let createModel = CreateModel()
    var exercises: [Exercise] = []
    var users: [Users] = []
    var imageModel = ImageModel()
    var featuredPerson: Users?
    var featuredExercises: Exercise?
    var lastExercise = -1
    var imageType = 0
    var featuredTimer: Timer?
    
    func exercisesLoaded(exercises: [Exercise]) {
        self.exercises = exercises
        if self.featuredExercises == nil {
            setFeaturedExercise()
        }
    }
    
    func getRandomExercise() -> Exercise? {
        if exercises.count <= 0 { return nil }
        if exercises.count == 1 { return exercises[0] }
        var rand = lastExercise
        while rand == lastExercise {
            rand = Int(arc4random_uniform(UInt32(exercises.count)))
        }
        return exercises[rand]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createModel.getUsers()
        createModel.delegate = self
        imageModel.delegate = self
        
        let tapToExercise = UITapGestureRecognizer(target: self, action: #selector(handleTapToExercise(sender:)))
        let tapToUser = UITapGestureRecognizer(target: self, action: #selector(handleTapToUser(sender:)))
        
        featuredExercise.addGestureRecognizer(tapToExercise)
        featuredUser.addGestureRecognizer(tapToUser)
        featuredUser.isUserInteractionEnabled = true
        featuredExercise.isUserInteractionEnabled = true
    }
    
    @objc func handleTapToExercise(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            performSegue(withIdentifier: "exploreToExercises", sender: self)
        }
    }
    
    @objc func handleTapToUser(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            performSegue(withIdentifier: "exploreToUsers", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exploreToUsers"{
            let dest = segue.destination as! ExerciseProfileViewController
            if let featured = featuredPerson {
                dest.creatorId = featured.id
                let first = featured.firstName
                let last = featured.lastName?.first
                
                if let first = first, let last = last {
                    dest.title = "\(first) \(last)."
                }
                dest.profilePic = featuredUser.image
            }
        }
        else if segue.identifier == "exploreToExercises"{
            let dest = segue.destination as! ExerciseViewController
            if let exercise = featuredExercises {
                dest.descripe = exercise.exerciseDescription
                dest.id = exercise.id
                dest.name = exercise.name
                dest.information = ""
            }
        }
    }
    
    func usersLoaded(users: [Users]) {
        self.users = users
        if self.featuredPerson == nil {
            self.featuredPerson = self.getRandomUser()
            if let id = featuredPerson?.id {
                self.imageType = 0
                self.imageModel.loadImage(urlString: LOAD_PROFILE_IMAGE_URL + "\(id)")
            }
        }
    }
    
    func getRandomUser() -> Users? {
        if users.count <= 0 { return nil }
        let rand = Int(arc4random_uniform(UInt32(users.count)))
        return users[rand]
    }
    
    func loadedImage(image: UIImage?) {
        DispatchQueue.main.async {
            if self.imageType == 0 {
                self.featuredUser.contentMode = .scaleAspectFill
                self.featuredUser.layer.cornerRadius = self.featuredUser.frame.height / 2
                self.featuredUser.layer.masksToBounds = false
                self.featuredUser.clipsToBounds = true
                if let image = image {
                    self.featuredUser.image = image
                }
                else {
                    self.featuredUser.image = #imageLiteral(resourceName: "profile_pic_placeholder")
                }
                self.createModel.loadExercises(search: "")
            }
            else if self.imageType == 1 {
                UIView.transition(with: self.featuredExercise,
                                  duration: 0.8,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.featuredExercise.image = image
                }, completion: nil)
                
                self.featuredExercise.roundCornersForAspectFit(radius: 5.0)
            }
        }
    }
    
    @objc func setFeaturedExercise() {
        self.featuredExercises = self.getRandomExercise()
        self.exerciseName.text = self.featuredExercises?.name
        if let id = self.featuredExercises?.id {
            self.imageType = 1
            self.imageModel.loadImage(urlString: LOAD_EXERCISE_IMAGE_URL + "\(id)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        featuredTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(setFeaturedExercise), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        featuredTimer?.invalidate()
    }
}
