//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by DINGKaile on 10/29/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "jR23zXY9eLKgcA5PkW1s0Yx1A", consumerSecret: "w58OWDlD9oGfFFmnn04ypuKU3v41jW4gev8SQ4myzJs8xqF5Cn")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        self.loginSuccess = success
        self.loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth")!, scope: nil, success: { (requestCredential) in
            print("I got a token!")
            
            let urlstr = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestCredential!.token!)"
            let url = URL(string: urlstr)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            
        }, failure: { (error) in
            self.loginFailure!(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance?.deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotifcation), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query!)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            print("I got the access token!")
            
            self.currentAccount(success: { (user) in
                // User.currentUserAccessToken = accessToken
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error) in
                self.loginFailure?(error)
            })
            
        }, failure: { (error) in
            self.loginFailure?(error!)
        })
        
    }
    
    func composeTweet(tweetText: String, success: @escaping ((NSDictionary) -> ()), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/update.json", parameters: ["status": tweetText], progress: nil, success: { (task, response) in
            let dictionary = response as! NSDictionary
            success(dictionary)
            
        }, failure: { (task, error) in
            failure(error)
        })
        
    }
    
    func replyToTweet(tweetText: String, replyTo: String, success: @escaping ((NSDictionary) -> ()), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/update.json", parameters: ["status": tweetText, "in_reply_to_status_id": replyTo], progress: nil, success: { (task, response) in
            let dictionary = response as! NSDictionary
            success(dictionary)
            
        }, failure: { (task, error) in
            failure(error)
        })
        
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            print("account: \(user.name!)")
            success(user)
            
        }, failure: { (task, error) in
            failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task, error) in
            failure(error)
        })
    }
    
    func olderHomeline(maxId: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: ["max_id": maxId], progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task, error) in
            failure(error)
        })
    }
    
    func userTimeline(screenName: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/user_timeline.json", parameters: ["screen_name": screenName], progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task, error) in
            failure(error)
        })
    }
    
    func olderUserline(maxId: String, screenName: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/user_timeline.json", parameters: ["screen_name": screenName, "max_id": maxId], progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task, error) in
            failure(error)
        })
    }
    
    func favoriteATweet(tweetId: String, success: @escaping ((NSDictionary) -> ()), failure: @escaping ((Error) -> ())) {
        post("1.1/favorites/create.json", parameters: ["id": tweetId], progress: nil, success: {(task, response) in
            let dictionary = response as! NSDictionary
            success(dictionary)
            
        }, failure: {(task, error) in
            failure(error)
        })
    }
    
    func defavoriteTweet(tweetId: String, success: @escaping ((NSDictionary) -> ()), failure: @escaping ((Error) -> ())) {
        post("1.1/favorites/destroy.json", parameters: ["id": tweetId], progress: nil, success: {(task, response) in
            let dictionary = response as! NSDictionary
            success(dictionary)
            
        }, failure: {(task, error) in
            failure(error)
        })
    }
    
    func checkTweet(tweetId: String, success: @escaping (([NSDictionary]) -> ()), failure: @escaping ((Error) -> ())) {
        get("1.1/statuses/lookup.json", parameters: ["id": tweetId], progress: nil, success: {(task, response) in
            let dictionary = response as! [NSDictionary]
            success(dictionary)
            
        }, failure: {(task, error) in
            failure(error)
        })
    }
    
    func retweet(tweetId: String, success: @escaping ((NSDictionary) -> ()), failure: @escaping ((Error) -> ())) {
        post("1.1/statuses/retweet/\(tweetId).json", parameters: ["id": tweetId], progress: nil, success: {(task, response) in
            let dictionary = response as! NSDictionary
            success(dictionary)
            
        }, failure: {(task, error) in
            failure(error)
        })
    }
    
    func unretweet(tweetId: String, success: @escaping ((NSDictionary) -> ()), failure: @escaping ((Error) -> ())) {
        post("1.1/statuses/unretweet/\(tweetId).json", parameters: ["id": tweetId], progress: nil, success: {(task, response) in
            let dictionary = response as! NSDictionary
            success(dictionary)
            
        }, failure: {(task, error) in
            failure(error)
        })
    }
    
}
