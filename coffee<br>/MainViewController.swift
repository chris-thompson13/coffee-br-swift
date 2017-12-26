//
//  MainViewController.swift
//  coffee<br>
//
//  Created by Chris Thompson on 12/25/17.
//  Copyright © 2017 Chris Thompson. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.current() == nil {
            performSegue(withIdentifier: "goLogin", sender: Any?.self)
        }
        performSegue(withIdentifier: "goLogin", sender: (Any).self)

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
