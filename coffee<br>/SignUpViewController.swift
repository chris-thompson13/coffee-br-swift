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
        let user = PFUser()
        user.username = UserDefaults.standard.object(forKey: "profileLink") as? String
        user["firstName"] = (UserDefaults.standard.object(forKey: "firstName") as? String)!
        user["lastName"] = (UserDefaults.standard.object(forKey: "lastName") as? String)!
        user.password = UserDefaults.standard.object(forKey: "LIAccessToken") as? String
        

        user.signUpInBackground(block: { (success, errorMessage) in
            
            if success == true && errorMessage == nil {
                self.dismiss(animated: true, completion: nil)
                let imageData = UIImageJPEGRepresentation(self.imageView.image!, 0.1)
                let profilePic = PFFile(data: imageData!)
                profilePic?.saveInBackground(block: { (success, error) in
                    
                    
                })
            } else {
                
                let errorAlert = UIAlertController(title: "Login Problem", message: errorMessage as! String, preferredStyle: UIAlertControllerStyle.alert)
                
                
                errorAlert.addAction(UIAlertAction(title: "tryAgain", style: UIAlertActionStyle.default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                
            }
        })
        
        
        
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
