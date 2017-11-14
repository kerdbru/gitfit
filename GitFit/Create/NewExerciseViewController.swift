//
//  NewExerciseViewController.swift
//  GitFit
//
//  Created by Ubicomp3 on 11/14/17.
//  Copyright © 2017 Team3. All rights reserved.
//

import UIKit

class NewExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var exercises: [ExerciseOrder]?
    var selected: Int?
    let resultsController = UITableViewController(style: .plain)
    var exerciseList = ["Pull-up", "Push-up"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let edit = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = edit
        
        resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
        
        let searchController = UISearchController(searchResultsController: resultsController)
        self.present(searchController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "newExercise")
        
        cell.textLabel?.text = exerciseList[indexPath.row]
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
