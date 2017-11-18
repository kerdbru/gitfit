
import UIKit

class FavoritesTableViewController: UITableViewController, FavoriteModelDelegate {
    var favoriteModel = FavoriteModel()
    var workouts: [Favorite] = []
    var workout: Favorite?

    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteModel.delegate = self
        favoriteModel.loadWorkouts(user!.id!)
        tableView.tableFooterView = UIView()
    }

    func favoritesLoaded(favorites: [Favorite]) {
        DispatchQueue.main.async {
            self.workouts = favorites
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite", for: indexPath)

        cell.textLabel?.text = workouts[indexPath.row].name
        cell.detailTextLabel?.text = workouts[indexPath.row].type
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        workout = workouts[indexPath.row]
        performSegue(withIdentifier: "favoriteToExercises", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ExercisesTableViewController
        dest.accountId = user!.id!
        dest.workoutId = workout?.id
        dest.name = workout?.name
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteModel.removeFavorite(user!.id!, workouts[indexPath.row].id!)
            self.workouts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteModel.loadWorkouts(user!.id!)
    }
}
