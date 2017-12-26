//
//  SignUpViewController.swift
//  coffee<br>
//
//  Created by Chris Thompson on 12/24/17.
//  Copyright © 2017 Chris Thompson. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var loginOutlet: UIButton!
    @IBAction func loginAction(_ sender: Any) {
        if PFUser.current() == nil {
        let user = PFUser()
        user.username = UserDefaults.standard.object(forKey: "profileLink") as? String
        user["firstName"] = (UserDefaults.standard.object(forKey: "firstName") as? String)!
        user["lastName"] = (UserDefaults.standard.object(forKey: "lastName") as? String)!
        user["accessToken"] = UserDefaults.standard.object(forKey: "LIAccessToken") as? String
        user.password = "linkedInAccess"
        

        user.signUpInBackground(block: { (success, errorMessage) in
            
            if success == true && errorMessage == nil {
                self.dismiss(animated: true, completion: nil)
                let imageData = UIImagePNGRepresentation(self.imageView.image!)
                let file = PFFile(name: "img.png", data: imageData!)
                
                PFUser.current()!["profilePic"] = file
                PFUser.current()?.saveInBackground()
                
            } else {

                
                
                let errorAlert = UIAlertController(title: "Login Problem", message: errorMessage as? String, preferredStyle: UIAlertControllerStyle.alert)
                
                
                errorAlert.addAction(UIAlertAction(title: "tryAgain", style: UIAlertActionStyle.default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                
            }
        })
        
        } else {
            let imageData = UIImagePNGRepresentation(self.imageView.image!)
            let file = PFFile(name: "img.png", data: imageData!)

            PFUser.current()!["profilePic"] = file
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if success == true && error == nil {
                    self.performSegue(withIdentifier: "loggedIn", sender: Any?.self)
                }
            })


        }
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    let imagePicker = UIImagePickerController()

    @IBAction func pickAction(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imageView.contentMode = .scaleAspectFill //3
        imageView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
        loginOutlet.isHidden = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imageView.layer.cornerRadius = 100.0
        imageView.clipsToBounds = true

        


        titleOutlet.text = "Welcome " + (UserDefaults.standard.object(forKey: "firstName") as? String)!

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
