//
//  UserTweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Michael Fletes on 3/11/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class UserTweetCell: UITableViewCell {

    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var buttonImage: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var buttonRetweetImage: UIButton!
    var picture: UIImage!
    var pictureUrl: String?
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            pictureUrl = tweet.user.profile_image_url_https
            let imageURL = URL(string: self.pictureUrl!)!
            //cell.posterImageView.af_setImage(withURL: posterURL
            profilePicture.af_setImage(withURL: imageURL)
            timeStamp.text = tweet.createdAtString
            screenName.text = "@" + tweet.user.screenName!
            username.text = tweet.user.name
            favoriteCount.text = tweet.favoriteCount?.description
            retweetCount.text = String(describing: tweet.retweetCount)
            if(tweet.retweeted) {
                buttonRetweetImage.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            }
            else {
                buttonRetweetImage.setImage(#imageLiteral(resourceName: "retweet-icon") ,for: .normal)
            }
            if(tweet.favorited)! {
                buttonImage.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            }
            else{
                buttonImage.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            }
        }
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if(!tweet.retweeted) {
            buttonRetweetImage.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            tweet.retweeted = true
            tweet.retweetCount+=1
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                }
            }
            self.retweetCount.text = String(tweet.retweetCount)
        }
        else {
            buttonRetweetImage.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            tweet.retweeted = false
            tweet.retweetCount-=1
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                }
            }
            self.retweetCount.text = String(tweet.retweetCount)
        }
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        // TODO: Update the local tweet model
        // TODO: Update cell UI
        // TODO: Send a POST request to the POST favorites/create endpoint
        
        if(tweet.favorited != true) {
            buttonImage.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            tweet.favorited = true
            tweet.favoriteCount = tweet.favoriteCount! + 1
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
            self.favoriteCount.text = tweet.favoriteCount?.description
        }
            
        else {
            buttonImage.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            tweet.favorited = false
            tweet.favoriteCount = tweet.favoriteCount! - 1
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            }
            self.favoriteCount.text = tweet.favoriteCount?.description
            
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
