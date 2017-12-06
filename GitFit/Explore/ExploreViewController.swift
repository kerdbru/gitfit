//
//  ExploreViewController.swift
//  GitFit
//
//  Created by Sumaiya Asif on 11/29/17.
//  Copyright © 2017 Team3. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, CreateModelDelegate {
    @IBOutlet weak var featuredExercise: UIImageView!
    @IBOutlet weak var featuredUser: UIImageView!
    let createModel = CreateModel()
    var exercises: [Exercise] = []
    
    func exercisesLoaded(exercises: [Exercise]) {
        self.exercises = exercises
    }
    
    func getRandomExercise() -> Exercise? {
        if exercises.count <= 0 { return nil }
        let rand = Int(arc4random_uniform(UInt32(exercises.count)))
        return exercises[rand]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createModel.loadExercises(search: "")
        createModel.delegate = self
        let tapToExercise = UITapGestureRecognizer(target: self, action: #selector(handleTapToExercise(sender:)))
        let tapToUser = UITapGestureRecognizer(target: self, action: #selector(handleTapToUser(sender:)))
        featuredExercise.addGestureRecognizer(tapToExercise)
        featuredUser.addGestureRecognizer(tapToUser)
        featuredUser.isUserInteractionEnabled = true
        featuredExercise.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTapToExercise(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
//            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
//                self.featuredExercise.alpha = 0.0
//            }, completion: nil)
            // handling code
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
            dest.creatorId = 1
            dest.profilePic = #imageLiteral(resourceName: "profile_pic_placeholder")
        }
        else if segue.identifier == "exploreToExercises"{
            let dest = segue.destination as! ExerciseViewController
            if let exercise = getRandomExercise() {
                dest.descripe = exercise.exerciseDescription
                dest.id = exercise.id
                dest.name = exercise.name
                dest.information = ""
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
