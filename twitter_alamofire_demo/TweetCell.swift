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
    var picture: UIImage!
    var pictureUrl: String?
    
    var imageString: String = ""
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            pictureUrl = tweet.user.profile_image_url_https
            let imageURL = URL(string: self.pictureUrl!)!
            //cell.posterImageView.af_setImage(withURL: posterURL
            profileImage.af_setImage(withURL: imageURL)
            timeStampLabel.text = tweet.createdAtString
            screenNameLabel.text = tweet.user.screenName
            usernameLabel.text = tweet.user.name
            favoriteCountLabel.text = tweet.favoriteCount?.description
            retweetsCountLabel.text = String(describing: tweet.retweetCount)
            if(tweet.retweeted) {
                retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            }
            else {
                retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon") ,for: .normal)
            }
            if(tweet.favorited)! {
                favorButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            }
            else{
                favorButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            }
        }
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        // TODO: Update the local tweet model
        // TODO: Update cell UI
        // TODO: Send a POST request to the POST favorites/create endpoint
        
        if(tweet.favorited != true) {
            favorButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            tweet.favorited = true
            tweet.favoriteCount = tweet.favoriteCount! + 1
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
            self.favoriteCountLabel.text = tweet.favoriteCount?.description
        }
            
        else {
            favorButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            tweet.favorited = false
            tweet.favoriteCount = tweet.favoriteCount! - 1
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            }
            self.favoriteCountLabel.text = tweet.favoriteCount?.description
            
        }
        
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        
        if(!tweet.retweeted) {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            tweet.retweeted = true
            tweet.retweetCount+=1
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                }
            }
            self.retweetsCountLabel.text = String(tweet.retweetCount)
        }
        else {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            tweet.retweeted = false
            tweet.retweetCount-=1
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                }
            }
            self.retweetsCountLabel.text = String(tweet.retweetCount)
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
