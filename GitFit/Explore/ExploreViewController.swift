//
//  ExploreViewController.swift
//  GitFit
//
//  Created by Sumaiya Asif on 11/29/17.
//  Copyright © 2017 Team3. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    @IBOutlet weak var featuredExercise: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        featuredExercise.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                self.featuredExercise.alpha = 0.0
            }, completion: nil)
            // handling code
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
