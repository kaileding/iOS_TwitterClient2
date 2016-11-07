//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by DINGKaile on 10/30/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit
import AFNetworking

class ComposeViewController: UIViewController {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var tweetField: UITextView!
    
    var isReplying: Bool = false
    var replyToTweetId: String?
    var replyToUserName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let avatarUrl = User.currentUser?.profileUrl
        self.userAvatar.setImageWith(avatarUrl!, placeholderImage: UIImage(named: "noavatar"))
        self.name.text = User.currentUser?.name!
        self.screenName.text = "@".appending((User.currentUser?.screenName)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isReplying {
            self.navigationItem.title = "Replying"
            self.tweetField.text = self.replyToUserName!.appending(" ")
        } else {
            self.navigationItem.title = "Compose"
        }
        self.tweetField.becomeFirstResponder()
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

    @IBAction func finishComposeTweet(_ sender: Any) {
        if self.isReplying {
            TwitterClient.sharedInstance?.replyToTweet(tweetText: self.tweetField.text!, replyTo: self.replyToTweetId!, success: { (response) in
                
                let tweetID = response["id_str"] as! String
                print("Successfully replied to a tweet (id: \(tweetID))")
                
                let vcstack = self.navigationController?.viewControllers
                let tweetTableVC = vcstack?[(vcstack?.count)!-3] as! TweetsViewController
                tweetTableVC.shouldReLoad = false
                tweetTableVC.tweets.insert(Tweet(dictionary: response), at: 0)
                
                _ = self.navigationController?.popViewController(animated: true)
                
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.composeTweet(tweetText: self.tweetField.text!, success: { (response) in
                
                let tweetID = response["id_str"] as! String
                print("Successfully created a tweet (id: \(tweetID))")
                
                let vcstack = self.navigationController?.viewControllers
                let tweetTableVC = vcstack?[(vcstack?.count)!-2] as! TweetsViewController
                tweetTableVC.shouldReLoad = false
                tweetTableVC.tweets.insert(Tweet(dictionary: response), at: 0)
                
                _ = self.navigationController?.popViewController(animated: true)
                
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
    }
    
    
    
}
