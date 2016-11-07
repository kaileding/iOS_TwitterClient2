//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by DINGKaile on 10/30/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timeBefore: UILabel!
    
    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var favoriteImg: UIImageView!
    @IBOutlet weak var retweetImg: UIImageView!
    
    
    var tweetData: Tweet? {
        didSet {
            self.avatarImage.setImageWith(tweetData!.avatarUrl!, placeholderImage: UIImage(named: "noavatar")!)
            
            self.screenName.text = tweetData?.name!
            self.name.text = "@".appending(tweetData!.screenName!)
            
            let nowDate = Date()
            let calender = Calendar.current
            let currentTime = calender.dateComponents([.year, .month, .day, .hour, .minute], from: nowDate)
            let createdTime = calender.dateComponents([.year, .month, .day, .hour, .minute], from: (tweetData?.timestamp)!)
            if currentTime.year != createdTime.year || currentTime.month != createdTime.month || currentTime.day != createdTime.day {
                self.timeBefore.text = "\(createdTime.month!)/\(createdTime.day!)/\(createdTime.year!)"
            } else {
                let diff = currentTime.hour! - createdTime.hour!
                self.timeBefore.text = "\(diff)h"
            }
            
            self.textContent.text = tweetData?.text!
            self.retweetCount.text = "\(tweetData!.retweetCount)"
            self.likeCount.text = "\(tweetData!.favoraitesCount)"
            
            if tweetData!.favorited! {
                self.favoriteImg.image = UIImage(named: "like")
            } else {
                self.favoriteImg.image = UIImage(named: "unlike")
            }
            if tweetData!.retweeted! {
                self.retweetImg.image = UIImage(named: "shared")
            } else {
                self.retweetImg.image = UIImage(named: "share")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.avatarImage.layer.cornerRadius = 3
        self.avatarImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
