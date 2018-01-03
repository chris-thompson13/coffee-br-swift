//
//  ProfileViewController.swift
//  coffee<br>
//
//  Created by Chris Thompson on 12/25/17.
//  Copyright © 2017 Chris Thompson. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBAction func viewProfile(_ sender: Any) {
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    @IBAction func logOut(_ sender: Any) {
        if PFUser.current() != nil {
            PFUser.logOutInBackground(block: { (error) in
                if error == nil {
                    self.performSegue(withIdentifier: "logOut", sender: Any?.self)
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageData = PFUser.current()!["profilePic"] as! PFFile
        
        imageData.getDataInBackground { (success, error) in
            
            if success != nil && error == nil {
                self.profilePic.image = UIImage(data: success!)
            }
        }
        name.text = PFUser.current()?["firstName"] as? String
        profilePic.layer.cornerRadius = profilePic.bounds.height/5
        profilePic.clipsToBounds = true
        profilePic.layer.borderColor = UIColor.white.cgColor
        profilePic.layer.borderWidth = 5
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        buttonOutlet.layer.cornerRadius = 15
        buttonOutlet.clipsToBounds = true

        
        if UserDefaults.standard.object(forKey: "headline") as? String != nil {
            label.text = UserDefaults.standard.object(forKey: "headline") as? String
            PFUser.current()!["headline"] = UserDefaults.standard.object(forKey: "profileLink") as? String
            PFUser.current()?.saveInBackground()
        }
        
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
