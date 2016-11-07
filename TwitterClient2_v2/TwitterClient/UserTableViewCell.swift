//
//  UserTableViewCell.swift
//  TwitterClient2
//
//  Created by DINGKaile on 11/6/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let avatarUrl = User.currentUser?.profileUrl
        self.profileImage.setImageWith(avatarUrl!, placeholderImage: UIImage(named: "noavatar"))
        self.nameLabel.text = User.currentUser?.name!
        self.descriptionLabel.text = User.currentUser?.tagline!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
