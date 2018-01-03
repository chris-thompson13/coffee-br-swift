//
//  ViewController.swift
//  networkOndemand
//
//  Created by Chris Thompson on 12/1/17.
//  Copyright © 2017 Chris Thompson. All rights reserved.
//

import UIKit
import Parse
import Mapbox
import LinkedInSignIn
import CoreLocation
import NVActivityIndicatorView




class ViewController: UIViewController {
    let linkedinCredentilas = [
        "linkedInKey": "86fmghpz7abq5w",
        "linkedInSecret": "uO9W09mpz8PwvLxH",
        "redirectURL": "https://www.example.com/auth/linkedin"
    ]
    var locationManager = CLLocation()
    
    @IBOutlet weak var activity: NVActivityIndicatorView!
    
    @IBOutlet weak var loginOutlet: UIBarButtonItem!
    

    
    
    func checkForExistingAccessToken() {
        if UserDefaults.standard.object(forKey: "LIAccessToken") != nil {
            getProfileInfo()
            if CLLocationManager.locationServicesEnabled() {
                let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURL())
                mapView.showsUserLocation = true
                
                mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -63.98742), zoomLevel: 5, animated: true)
                
                view.addSubview(mapView)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    if mapView.userLocation?.coordinate != nil {
                        mapView.setCenter((mapView.userLocation?.coordinate)!, animated: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            mapView.setCenter((mapView.userLocation?.coordinate)!, zoomLevel: 16, animated: true)
                            
                            
                        })
                    }
                })
            }
            
            
        }
    }
    
    func getProfileInfo() {
        if let accessToken = UserDefaults.standard.object(forKey: "LIAccessToken") {
            // Specify the URL string that we'll get the profile info from.
            let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url,id,first-name,headline,positions,summary,industry,last-name,maiden-name,email-address,picture-urls::(original))?format=json"
            
            
            let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
            
            // Indicate that this is a GET request.
            request.httpMethod = "GET"
            
            // Add the access token as an HTTP header field.
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            // Make the request.
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                if statusCode == 200 {
                    // Convert the received JSON data into a dictionary.
                    do {
                        let dataDictionary = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String:Any]
                        
                        let profileURLString = dataDictionary!["publicProfileUrl"] as AnyObject
                        let firstName = dataDictionary!["firstName"] as AnyObject
                        let lastName = dataDictionary!["lastName"] as AnyObject
                        let headline = dataDictionary!["headline"] as AnyObject
                        
                        //let profilePic = dataDictionary!["pictureUrl"] as AnyObject
                        
                        UserDefaults.standard.set(profileURLString, forKey: "profileLink")
                        
                        UserDefaults.standard.set(firstName, forKey: "firstName")
                        UserDefaults.standard.set(lastName, forKey: "lastName")
                        
                        if headline as! String != "" {
                            UserDefaults.standard.set(headline, forKey: "headline")
                        }
                        
                        
                        //UserDefaults.standard.set(profilePic, forKey: "picUrl")
                        
                        
                        
                        
                        print("profile", profileURLString,"firstName", firstName,"lastName",lastName,"picUrl", dataDictionary)
                        
                        
                    }
                    catch {
                        print("Could not convert JSON data into a dictionary.")
                    }
                }
                
            }
            task.resume()
        }
    }
    
    
    @IBAction func login(_ sender: Any) {
        activity.startAnimating()

        
        if PFUser.current() != nil {
            print("currentUser",PFUser.current()!)
            if PFUser.current()!["profilePic"] != nil {
                self.performSegue(withIdentifier: "logger", sender: Any?.self)
            }
        }
        if  UserDefaults.standard.object(forKey: "LIAccessToken") == nil {
            
            let linkedInConfig = LinkedInConfig(linkedInKey: linkedinCredentilas["linkedInKey"]!, linkedInSecret: linkedinCredentilas["linkedInSecret"]!, redirectURL: linkedinCredentilas["redirectURL"]!)
            let linkedInHelper = LinkedinHelper(linkedInConfig: linkedInConfig)
            linkedInHelper.login(from: self,  completion: { (token) in
                UserDefaults.standard.set(token, forKey: "LIAccessToken")
                print(token)
                self.checkForExistingAccessToken()
                
            }, failure: { (error) in
                print(error.localizedDescription)
            }) {
                print("Cancel")
            }
            loginOutlet.title = "updateProfile"
        } else {
            PFUser.logInWithUsername(inBackground: (UserDefaults.standard.object(forKey: "profileLink") as? String)!, password: "linkedInAccess", block: { (User, error) in
                if User != nil && error == nil {
                    print("signing in")
                    self.performSegue(withIdentifier: "signedUp", sender: Any?.self)
                    
                } else {
                    self.performSegue(withIdentifier: "signedUp", sender: Any?.self)
                }
            })
        }
        
        
        activity.stopAnimating()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if  UserDefaults.standard.object(forKey: "LIAccessToken") != nil {
            loginOutlet.title = "updateProfile"
            
        }
        checkForExistingAccessToken()
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

