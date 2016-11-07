//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by DINGKaile on 10/30/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit
import AFNetworking
import LCLoadingHUD

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tweetsTable: UITableView!
    var tweets = [Tweet]()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var shouldReLoad: Bool = false
    var canLoadMore: Bool = true
    var isMoreDataLoading: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tweetsTable.dataSource = self
        self.tweetsTable.delegate = self
        self.tweetsTable.rowHeight = UITableViewAutomaticDimension
        self.tweetsTable.estimatedRowHeight = 50.0
        self.refreshControl.addTarget(self, action: #selector(requestMoreTweets(_:)), for: UIControlEvents.valueChanged)
        self.tweetsTable.insertSubview(self.refreshControl, at: 0)
        
        self.navigationItem.titleView?.tintColor = UIColor.white
        
        self.requestMoreTweets(self.refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.shouldReLoad {
            self.requestMoreTweets(self.refreshControl)
        }
        self.tweetsTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation+
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetailSegue" {
            if let cell = sender as? UITableViewCell {
                let selectedIndex = self.tweetsTable.indexPath(for: cell)!.row
                let detailsVC = segue.destination as! TweetDetailsViewController
                detailsVC.tweet = self.tweets[selectedIndex]
            }
        } else if segue.identifier == "ComposeSegue" {
            let composeVC = segue.destination as! ComposeViewController
            composeVC.isReplying = false
        }
    }
    
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        cell.tweetData = self.tweets[indexPath.row]
        
        cell.avatarImage.tag = indexPath.row
        cell.avatarImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onAvatarTapped))
        cell.avatarImage.addGestureRecognizer(tapGestureRecognizer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !(self.isMoreDataLoading) && self.canLoadMore {
            let scrollViewContentHeight = self.tweetsTable.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.tweetsTable.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && self.tweetsTable.isDragging {
                self.isMoreDataLoading = true
                self.loadMoreData(self.refreshControl)
            }
        }
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    
    // Helper functions
    func requestMoreTweets(_ refreshControl: UIRefreshControl) {
        LCLoadingHUD.showLoading("Loading", in: self.view)
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets) in
            self.tweets = tweets
            
            LCLoadingHUD.hide(in: self.view)
            refreshControl.endRefreshing()
            self.shouldReLoad = false
            self.isMoreDataLoading = false
            self.tweetsTable.reloadData()
            
        }, failure: { (error) in
            
            LCLoadingHUD.hide(in: self.view)
            refreshControl.endRefreshing()
            self.isMoreDataLoading = false
            print(error.localizedDescription)
        })
        
    }
    
    func loadMoreData(_ refreshControl: UIRefreshControl) {
        LCLoadingHUD.showLoading("Loading", in: self.view)
        let tweetsCount = self.tweets.count
        let maxid = self.tweets[tweetsCount-1].statusID!
        
        TwitterClient.sharedInstance?.olderHomeline(maxId: maxid, success: { (response) in
            let extraNum = response.count
            if extraNum > 1 {
                for tweet in response[1...(extraNum-1)] {
                    self.tweets.append(tweet)
                }
            } else {
                self.canLoadMore = false
            }
            LCLoadingHUD.hide(in: self.view)
            refreshControl.endRefreshing()
            self.shouldReLoad = false
            self.isMoreDataLoading = false
            self.tweetsTable.reloadData()
            
        }, failure: { (error) in
            LCLoadingHUD.hide(in: self.view)
            refreshControl.endRefreshing()
            self.isMoreDataLoading = false
            print(error.localizedDescription)
        })
        
    }
    
    func onAvatarTapped(tapGesture: UITapGestureRecognizer) {
        let avatar = tapGesture.view as! UIImageView
        print("---  tapped on image \(avatar.tag)")
        let user = self.tweets[avatar.tag].tweetuser!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileView") as! UserProfileViewController
        userProfileVC.user = user
        // userProfileVC.navigationItem.title = "Me"
        self.navigationController?.pushViewController(userProfileVC, animated: true)
        
    }

}
