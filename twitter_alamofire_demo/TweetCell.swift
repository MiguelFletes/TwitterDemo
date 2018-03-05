//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var favorButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    
    var imageString: String = ""
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            usernameLabel.text = tweet.user.name
            screenNameLabel.text = tweet.user.screenName
            timeStampLabel.text = tweet.createdAtString
            let retweets = String(tweet.retweetCount)
            let favorites = tweet.favoriteCount?.description
            retweetsCountLabel.text = retweets
            favoriteCountLabel.text = favorites
            imageString = tweet.user.profile_image_url_https!
            let imageURL = URL(string: self.imageString)!
            profileImage.af_setImage(withURL: imageURL)
            
            
            
            
        }
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        // TODO: Update the local tweet model
        // TODO: Update cell UI
        // TODO: Send a POST request to the POST favorites/create endpoint
        if tweet.favorited == true {
            tweet.favorited = false
            favorButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            tweet.favoriteCount! -= 1
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            }
        }
        else {
            favorButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            tweet.favorited = true
            tweet.favoriteCount! += 1
            
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        }
        
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        
        //retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
        if tweet.retweeted == true {
            tweet.retweeted = false
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            tweet.retweetCount -= 1
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                }
            }
        }
        else {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            tweet.retweeted = true
            tweet.retweetCount += 1
            
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
