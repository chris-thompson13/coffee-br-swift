//
//  MeetViewController.swift
//  coffee<br>
//
//  Created by chris thompson on 12/31/17.
//  Copyright © 2017 Chris Thompson. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
import GooglePlaces
import GooglePlacePicker


class MeetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    private let refreshControl = UIRefreshControl()

    
    
    @IBOutlet weak var back: UIButton!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var contact: UIButton!
    
    @IBAction func backAction(_ sender: Any) {
        webView.isHidden = true
        back.isHidden = true
        contact.isHidden = true
    }
    
    @IBAction func contactAction2(_ sender: Any) {
    }
    @IBOutlet weak var contactAction: UIButton!
    var customIndex = 6
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.table.dequeueReusableCell(withIdentifier: "cell1") as UITableViewCell!
        let pCell = self.table.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MeetTableViewCell
        pCell.profilePic.layer.cornerRadius = 20
        pCell.profilePic.clipsToBounds = true
        let location1 = point

        var query = PFQuery(className:"meeting")
        query.whereKey("location", nearGeoPoint:location1)
        query.whereKey("location", nearGeoPoint: point, withinMiles: 5)

        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                print(objects!)
                self.meetings = objects!
                self.activity.stopAnimating()
                
                pCell.name.text =  objects![indexPath.row]["healdline"] as? String
                pCell.topic.text = "hello"
                
                pCell.currentLink = (objects![indexPath.row]["link"] as? String)!
                
                //pCell.location.text = String(self.point.distanceInMiles(to: (objects![indexPath.row]["location"] as! PFGeoPoint))) + " miles away"
                
                pCell.location.text = "about " + String((Double(round(10000 * (self.point.distanceInMiles(to: (objects![indexPath.row]["location"] as! PFGeoPoint))))))/1) + " miles away"
                pCell.topic.text = objects![indexPath.row]["description"] as? String
                if objects![indexPath.row]["profilePic"] != nil {
                (objects![indexPath.row]["profilePic"] as! PFFile).getDataInBackground(block: { (data, error) in
                    if error == nil && data != nil {
                        
                        if data != nil{
                            let image = UIImage(data: data!)
                            pCell.profilePic.image = image
                        } else {
                            print(error!)
                        
                    }
                    }
                })
                    
                
                }
                print("table")
                
            }
        }
        
        
        // set the text from the data model
        
        return pCell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if meetings.count > 0  {
            customIndex = meetings.count
        }

        return customIndex
    }
    var test = ["1","2","3","4","5","6"]
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        
        webView.isHidden = false
        back.isHidden = false
        if meetings[indexPath.row]["link"] != nil {
        let url = URL(string: meetings[indexPath.row]["link"] as! String)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)

        }

        
    }

    
    @IBOutlet weak var headline: UILabel!
    let locationManager = CLLocationManager()
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var topic: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    var meetings = [PFObject]()
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var activity: NVActivityIndicatorView!
    
    var point = PFGeoPoint()
    
    @IBOutlet weak var newHeadline: UILabel!
    @IBAction func meetAction(_ sender: Any) {
        activity.startAnimating()
        if text.text != "" && text.text != " " {
            let meetUp = PFObject(className: "meeting")
            meetUp["description"] = text.text
            meetUp["location"] = point
            meetUp["userID"] = PFUser.current()
            meetUp["healdline"] = UserDefaults.standard.object(forKey: "headline") as? String
            meetUp["name"] = PFUser.current()!["firstName"]
            meetUp["link"] = PFUser.current()!["username"]
            meetUp["profilePic"] = PFUser.current()!["profilePic"]


            meetUp.saveInBackground(block: { (success, error) in
                if success == true && error == nil {
                    self.activity.stopAnimating()
                    self.table.reloadData()
                    self.fetch()
                    self.text.text = ""

                    
                } else {
                    self.activity.stopAnimating()
                    self.fetch()
                    self.table.reloadData()

                }
            })
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        point = PFGeoPoint(latitude: locValue.latitude, longitude: locValue.longitude)
        return
    }
    @objc private func refresh(_ sender: Any) {
        // Fetch Weather Data
        fetch()
    }
    private func fetch() {
        activity.startAnimating()
            DispatchQueue.main.async {
                self.table.reloadData()
                self.refreshControl.endRefreshing()
                self.activity.stopAnimating()
            }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating()

        // Do any additional setup after loading the view.

        

        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        point = PFGeoPoint(latitude: locValue.latitude, longitude: locValue.longitude)
        
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        table.delegate = self
        table.dataSource = self
        table.reloadData()
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        self.refreshControl.attributedTitle = NSAttributedString(string: "loading...", attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 255.0/255.0, green: 182.0/255.0, blue: 8.0/255.0, alpha: 1.0)])

        var timer = Timer()
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: false)

    }
    

    
    @objc func timerAction() {
        fetch()
    }
    
    // number of rows in table view
    

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
