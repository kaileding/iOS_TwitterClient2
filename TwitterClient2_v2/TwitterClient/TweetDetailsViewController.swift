//
//  TweetDetailsViewController.swift
//  TwitterClient
//
//  Created by DINGKaile on 10/30/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var tweetTime: UILabel!
    
    @IBOutlet weak var retweetCount: UILabel!
    var retweetCountNum: Int?
    @IBOutlet weak var favoriteCount: UILabel!
    var favoriteCountNum: Int?
    
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    
    var tweet: Tweet?
    var tweetID: String?
    var favorited: Bool?
    var retweeted: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.avatarImg.setImageWith(self.tweet!.avatarUrl!, placeholderImage: UIImage(named: "noavatar")!)
        self.name.text = self.tweet?.name!
        self.screenName.text = "@".appending(self.tweet!.screenName!)
        
        self.tweetContent.text = self.tweet?.text!
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "d/M/yy, h:m a."
        let dateStr = myFormatter.string(from: self.tweet!.timestamp!)
        self.tweetTime.text = dateStr
        
        self.retweetCount.text = "\(self.tweet!.retweetCount)"
        self.retweetCountNum = self.tweet!.retweetCount
        self.favoriteCount.text = "\(self.tweet!.favoraitesCount)"
        self.favoriteCountNum = self.tweet!.favoraitesCount
        
        self.tweetID = self.tweet?.statusID!
        self.favorited = self.tweet?.favorited!
        self.retweeted = self.tweet?.retweeted!
        
        self.updateTweet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.favorited! {
            self.favoriteBtn.setImage(UIImage(named: "like")!, for: UIControlState.normal)
        } else {
            self.favoriteBtn.setImage(UIImage(named: "unlike")!, for: UIControlState.normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ReplySegue" {
            let replyVC = segue.destination as! ComposeViewController
            replyVC.isReplying = true
            replyVC.replyToTweetId = self.tweetID!
            replyVC.replyToUserName = self.screenName.text!
            
        }
    }
    
    @IBAction func onReplyButton(_ sender: Any) {
        self.performSegue(withIdentifier: "ReplySegue", sender: self)
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        if self.retweeted! {
            TwitterClient.sharedInstance?.unretweet(tweetId: self.tweetID!, success: { (response) in
                DispatchQueue.main.async {
                    self.retweeted = false
                    self.retweetBtn.setImage(UIImage(named: "share"), for: UIControlState.normal)
                    self.retweetCountNum! -= 1
                    self.retweetCount.text = "\(self.retweetCountNum!)"
                }
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweetId: self.tweetID!, success: { (response) in
                DispatchQueue.main.async {
                    self.retweeted = true
                    self.retweetBtn.setImage(UIImage(named: "shared"), for: UIControlState.normal)
                    self.retweetCountNum! += 1
                    self.retweetCount.text = "\(self.retweetCountNum!)"
                }
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
        // self.updateTweet()
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        if self.favorited! {
            TwitterClient.sharedInstance?.defavoriteTweet(tweetId: self.tweetID!, success: { (response) in
                DispatchQueue.main.async {
                    self.favorited = false
                    self.favoriteBtn.setImage(UIImage(named: "unlike"), for: UIControlState.normal)
                    self.favoriteCountNum! -= 1
                    self.favoriteCount.text = "\(self.favoriteCountNum!)"
                }
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.favoriteATweet(tweetId: self.tweetID!, success: { (response) in
                DispatchQueue.main.async {
                    self.favorited = true
                    self.favoriteBtn.setImage(UIImage(named: "like"), for: UIControlState.normal)
                    self.favoriteCountNum! += 1
                        self.favoriteCount.text = "\(self.favoriteCountNum!)"
                }
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
        // self.updateTweet()
    }
    
    @IBAction func onMessageButton(_ sender: Any) {
        
    }
    
    
    func updateTweet() {
        TwitterClient.sharedInstance?.checkTweet(tweetId: self.tweetID!, success: { (response) in
            if response.count == 1 {
                self.tweet = Tweet(dictionary: response[0])
                DispatchQueue.main.async {
                    
                    self.retweetCount.text = "\(self.tweet!.retweetCount)"
                    self.retweetCountNum = self.tweet!.retweetCount
                    self.favoriteCount.text = "\(self.tweet!.favoraitesCount)"
                    self.favoriteCountNum = self.tweet!.favoraitesCount
                    
                    self.tweetID = self.tweet?.statusID!
                    self.favorited = self.tweet?.favorited!
                    self.retweeted = self.tweet?.retweeted!
                    
                    if self.favorited! {
                        self.favoriteBtn.setImage(UIImage(named: "like")!, for: UIControlState.normal)
                    } else {
                        self.favoriteBtn.setImage(UIImage(named: "unlike")!, for: UIControlState.normal)
                    }
                    
                    if self.retweeted! {
                        self.retweetBtn.setImage(UIImage(named: "shared"), for: UIControlState.normal)
                    } else {
                        self.retweetBtn.setImage(UIImage(named: "share"), for: UIControlState.normal)
                    }
                    
                }
            }
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    

}
