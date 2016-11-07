//
//  Tweet.swift
//  TwitterClient
//
//  Created by DINGKaile on 10/29/16.
//  Copyright © 2016 myPersonalProjects. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var tweetuser: User!
    
    var avatarUrlStr: String?
    var avatarUrl: URL?
    var screenName: String?
    var name: String?
    var favoraitesCount: Int = 0
    
    var text: String?
    var retweetCount: Int = 0
    var timestamp: Date?
    var statusID: String?
    var favorited: Bool?
    var retweeted: Bool?
    
    init(dictionary: NSDictionary) {
        if let user = dictionary["user"] as? NSDictionary {
            self.tweetuser = User(dictionary: user)
            
            if let imgUrl = user["profile_image_url"] as? String {
                self.avatarUrlStr = imgUrl
                self.avatarUrl = URL(string: imgUrl)!
            } else {
                self.avatarUrlStr = ""
                self.avatarUrl = nil
            }
            
            self.screenName = user["screen_name"] as? String
            self.name = user["name"] as? String
            self.favoraitesCount = (user["favourites_count"] as? Int) ?? 0
        }
        
        self.text = dictionary["text"] as? String
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        let timeStampStr = dictionary["created_at"] as? String
        if timeStampStr != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            self.timestamp = formatter.date(from: timeStampStr!)
        }
        
        self.statusID = dictionary["id_str"] as? String
        self.favorited = dictionary["favorited"] as? Bool
        self.retweeted = dictionary["retweeted"] as? Bool
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
