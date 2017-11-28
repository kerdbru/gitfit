
import UIKit

class ExerciseViewController: UIViewController, ImageModelDelegate {
    var imageModel = ImageModel()
    var descripe: String?
    var name: String?
    var id: Int?
    var information: String?

    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var exerciseDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        exerciseDescription.text = descripe
        exerciseDescription.sizeToFit()
        exerciseImageView.image = #imageLiteral(resourceName: "placeholder")
        exerciseImageView.roundCornersForAspectFit(radius: 5.0)
        imageModel.delegate = self
        info.text = information
//        imageModel.loadImage(urlString: LOAD_EXERCISE_IMAGE_URL + "\(id ?? 0)")
    }
    
    func loadedImage(image: UIImage?) {
        if let image = image {
            DispatchQueue.main.async {
                self.exerciseImageView.contentMode = .scaleAspectFit
                self.exerciseImageView.image = image
                self.exerciseImageView.roundCornersForAspectFit(radius: 5.0)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
