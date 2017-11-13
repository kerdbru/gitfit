//
//  ExerciseViewController.swift
//  GitFit
//
//  Created by Keith Erdbruegger on 11/12/17.
//  Copyright © 2017 Team3. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
    var descripe: String?
    var name: String?
    var id: Int?

    @IBOutlet weak var exerciseImageView: UIImageView!
    
    @IBOutlet weak var exerciseDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        exerciseDescription.text = descripe
        exerciseDescription.sizeToFit()
        // Do any additional setup after loading the view.
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
