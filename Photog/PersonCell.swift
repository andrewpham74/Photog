//
//  PersonCell.swift
//  Photog
//
//  Created by One Month on 9/17/14.
//  Copyright (c) 2014 One Month. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet var followButton: UIButton?
    
    var user: PFUser?
    {
        didSet
        {
            self.configure()
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.followButton?.hidden = true
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
    
        self.followButton?.hidden = true
        self.textLabel?.text = ""
        self.user = nil
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure()
    {
        if let constUser = user
        {
            self.textLabel?.text = constUser.username

            // are we following this person?

            NetworkManager.sharedInstance.isFollowing(constUser, completionHandler: {
                (isFollowing, error) -> () in
                
                if let constError = error
                {
                    // Alert the user, or otherwise modify the UI
                }
                else
                {
                    if isFollowing == true
                    {
                        self.followButton?.backgroundColor = UIColor.redColor()
                    }
                    else
                    {
                        self.followButton?.backgroundColor = UIColor.blueColor()
                    }
                    
                    self.followButton?.hidden = false
                }
                
            })
            
            // if so: configure the button to unfollow
            
            // else: configure the button to follow
        }
    }
    
}
