//
//  UserProfileHeaderCell.swift
//  TwitterClient2
//
//  Created by DINGKaile on 11/6/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit

class UserProfileHeaderCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var profileBackgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetsNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bkImgHeightConstraint: NSLayoutConstraint!
    var bkImgOriginalHeight: CGFloat!
    
    var user: User! {
        didSet {
            let bkImgUrl = user.profileBkImageUrl
            self.profileBackgroundImage.setImageWith(bkImgUrl!, placeholderImage: UIImage(named: "building"))
            let avatarUrl = user.profileUrl
            self.profileImage.setImageWith(avatarUrl!, placeholderImage: UIImage(named: "noavatar"))
            self.nameLabel.text = user.name!
            self.screenNameLabel.text = "@".appending(user.screenName!)
            
            self.tweetsNumberLabel.text = user.statusesNum!
            self.followingNumberLabel.text = user.followingNum!
            self.followersNumberLabel.text = user.followersNum!
            
            self.descriptionLabel.text = user.tagline!
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height
        self.scrollView.contentSize = CGSize(width: scrollViewWidth*2, height: scrollViewHeight)
        self.scrollView.delegate = self
        self.pageIndicator.currentPage = 0
        
        self.bkImgOriginalHeight = self.bkImgHeightConstraint.constant
        
        /*
        self.view1.frame = CGRect(x: 0.0, y: 0.0, width: scrollViewWidth, height: scrollViewHeight)
        self.view2.frame = CGRect(x: scrollViewWidth, y: 0.0, width: scrollViewWidth, height: scrollViewHeight)
        self.scrollView.addSubview(self.view1)
        self.scrollView.addSubview(self.view2)
        */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func onSettingButton(_ sender: UIButton) {
    }
    
    @IBAction func onAddFriendButton(_ sender: UIButton) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.width
        var moved: CGFloat = scrollView.contentOffset.x/pageWidth - 0.5
        if moved < 0 {
            moved = 0.0-moved
        }
        self.profileBackgroundImage.alpha = 0.5 + moved
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2.0)/pageWidth)+1
        self.pageIndicator.currentPage = Int(currentPage)
    }
    
    
}
