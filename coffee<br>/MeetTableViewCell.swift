//
//  MeetTableViewCell.swift
//  coffee<br>
//
//  Created by chris thompson on 1/2/18.
//  Copyright © 2018 Chris Thompson. All rights reserved.
//

import UIKit
import Parse

class MeetTableViewCell: UITableViewCell {

    @IBOutlet weak var topic: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    
    
    
    
    
    var meetings = [PFObject]()
    var currentLink = ""
    var locationSetting = PFGeoPoint()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let data = UIImagePNGRepresentation(profilePic.image!) as NSData?
        var currentImage = PFFile(data: data as! Data )
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

