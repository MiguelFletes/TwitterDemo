//
//  ReplyViewController.swift
//  twitter_alamofire_demo
//
//  Created by Michael Fletes on 3/11/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

class ReplyViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    var tweet: Tweet!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.textView.placeholder = "What do you want to reply?"
        //self.view.addSubview(self.textView)
        textView.delegate = self
        textView.layer.borderWidth = 2.0
        textView.layer.cornerRadius = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func didTapReply(_ sender: Any) {
        APIManager.shared.composeReply(with: textView.text, with: tweet) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if tweet != nil {
                NotificationCenter.default.post(name: NSNotification.Name("goBack"), object: nil)
                print("Compose Tweet Success!")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
