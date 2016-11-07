//
//  UserProfileViewController.swift
//  TwitterClient2
//
//  Created by DINGKaile on 11/6/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit
import AFNetworking
import LCLoadingHUD

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var profileTable: UITableView!
    
    
    var user: User!
    var tweets: [Tweet] = []
    var shouldReLoad: Bool = false
    var isMoreDataLoading: Bool = false
    var canLoadMore: Bool = true
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.profileTable.dataSource = self
        self.profileTable.delegate = self
        self.profileTable.estimatedRowHeight = 50.0
        self.profileTable.rowHeight = UITableViewAutomaticDimension
        self.refreshControl.addTarget(self, action: #selector(requestMoreTweets(_:)), for: UIControlEvents.valueChanged)
        self.profileTable.insertSubview(self.refreshControl, at: 0)
        
        self.requestMoreTweets(self.refreshControl)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.shouldReLoad {
            self.requestMoreTweets(self.refreshControl)
        }
        self.profileTable.reloadData()
        
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
        
        if segue.identifier == "ShowDetailsFromProfile" {
            if let cell = sender as? UITableViewCell {
                let indexPath = self.profileTable.indexPath(for: cell)!
                if indexPath.section == 1 {
                    let selectedIndex = indexPath.row
                    let detailsVC = segue.destination as! TweetDetailsViewController
                    detailsVC.tweet = self.tweets[selectedIndex]
                }
            }
        } else if segue.identifier == "ComposeFromProfilePage" {
            let composeVC = segue.destination as! ComposeViewController
            composeVC.isReplying = false
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.tweets.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! UserProfileHeaderCell
            cell.user = self.user
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTweetCell", for: indexPath)
            (cell as! TweetTableViewCell).tweetData = self.tweets[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else {
            return 1.0
        }
    }
    
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > 0.0 {
            if !(self.isMoreDataLoading) && self.canLoadMore {
                let scrollViewContentHeight = self.profileTable.contentSize.height
                let scrollOffsetThreshold = scrollViewContentHeight - self.profileTable.bounds.size.height
                
                if offsetY > scrollOffsetThreshold && self.profileTable.isDragging {
                    self.isMoreDataLoading = true
                    self.loadMoreData(self.refreshControl)
                }
            }
        } else if offsetY < 0.0 {
            // pull down the table
            /*
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self.profileTable.cellForRow(at: indexPath) as! UserProfileHeaderCell
            
            cell.bkImgHeightConstraint.constant = cell.bkImgOriginalHeight - offsetY
            cell.layoutIfNeeded()
            self.profileTable.layoutIfNeeded()
            self.profileTable.reloadData()
            print("\n ------")
            */
        }
        
    }
    
    
    // MARK: - helper functions
    func requestMoreTweets(_ refreshControl: UIRefreshControl) {
        LCLoadingHUD.showLoading("Loading", in: self.view)
        
        
        TwitterClient.sharedInstance?.userTimeline(screenName: self.user.screenName!, success: { (tweets) in
            self.tweets = tweets
            LCLoadingHUD.hide(in: self.view)
            refreshControl.endRefreshing()
            self.shouldReLoad = false
            self.isMoreDataLoading = false
            self.profileTable.reloadData()
            
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
        
        TwitterClient.sharedInstance?.olderUserline(maxId: maxid, screenName: self.user.screenName!, success: { (response) in
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
            self.profileTable.reloadData()
            
        }, failure: { (error) in
            LCLoadingHUD.hide(in: self.view)
            refreshControl.endRefreshing()
            self.isMoreDataLoading = false
            print(error.localizedDescription)
        })
        
    }

}
