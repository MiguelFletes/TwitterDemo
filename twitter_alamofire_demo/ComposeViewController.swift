//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Michael Fletes on 3/9/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

protocol ComposeViewControllerDelegate:NSObjectProtocol{
    func did(post: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetText: RSKPlaceholderTextView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var atLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        let pictureUrl = User.current?.profile_image_url_https
        if(pictureUrl != nil) {
            let imageURL = URL(string: pictureUrl!)!
            profilePic.af_setImage(withURL: imageURL)
        }
        
        //self.tweetText.placeholder = "What do you want to say?"
        //self.view.addSubview(self.tweetText)
        tweetText.delegate = self
        tweetText.layer.borderWidth = 2.0
        tweetText.layer.cornerRadius = 8
        usernameLabel.text = User.current?.name
        atLabel.text = User.current?.screenName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("goBack"), object: nil)
    }
    @IBAction func onPost(_ sender: Any) {
        APIManager.shared.composeTweet(with: tweetText.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                NotificationCenter.default.post(name: NSNotification.Name("goBack"), object: nil)
                print("Compose Tweet Success!")
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // TODO: Check the proposed new text character count
        // Allow or disallow the new text
        // Set the max character limit
        let characterLimit = 140
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        countLabel.text = String(characterLimit - newText.characters.count)
        
        
        // The new text should be allowed? True/False
        return newText.characters.count < characterLimit
    }
    
}
