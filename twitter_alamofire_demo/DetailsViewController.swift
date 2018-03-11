//
//  DetailsViewController.swift
//  twitter_alamofire_demo
//
//  Created by Michael Fletes on 3/11/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var numberOfRetweets: UILabel!
    @IBOutlet weak var numberOfFavorites: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tweetLabel.text = tweet.text
        let pictureURL = tweet.user.profile_image_url_https
        let imageURL = URL(string: pictureURL!)
        profilePicture.af_setImage(withURL: imageURL!)
        timeStamp.text = tweet.createdAtString
        screenName.text = tweet.user.screenName
        userName.text = tweet.user.name
        numberOfRetweets.text = tweet.retweetCount.description
        numberOfFavorites.text = tweet.favoriteCount?.description
        if(tweet.retweeted) {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
        }
        else {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon") ,for: .normal)
        }
        if(tweet.favorited)! {
            favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
        }
        else{
            favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func didRetweet(_ sender: Any) {
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
            self.numberOfRetweets.text = String(tweet.retweetCount)
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
            self.numberOfRetweets.text = String(tweet.retweetCount)
        }
    }
    
    @IBAction func didFavorite(_ sender: Any) {
        if(tweet.favorited != true) {
            favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            tweet.favorited = true
            tweet.favoriteCount = tweet.favoriteCount! + 1
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
            self.numberOfFavorites.text = tweet.favoriteCount?.description
        }
            
        else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            tweet.favorited = false
            tweet.favoriteCount = tweet.favoriteCount! - 1
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            }
            self.numberOfFavorites.text = tweet.favoriteCount?.description
            
        }
    }
    
    @IBAction func didReply(_ sender: Any) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tweet = self.tweet
        let replyViewController = segue.destination as! ReplyViewController
        replyViewController.tweet = tweet
    }

}
