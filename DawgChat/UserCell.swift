//
//  UserCell.swift
//  DawgChat
//
//  Created by Zac on 2/28/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase

// This class inherit UITableViewCell for User
class UserCell: UITableViewCell {
    
    var profileImageViewRadius: Int = { return 20 }()
    
    // A property for customize profile image view
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        //        imageView.image = UIImage(named: "cat")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Radius = height / 2
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// A property to contain messge from user
    var message: Message? {
        didSet
        {
            
            setupNameAndProfileImage()
            
            //        cell.textLabel?.text = message.toID
            self.detailTextLabel?.text = message?.text
            
            // Time with string formatting
//            timeLabel.text = message?.timeStamp
            
            // String formatting
            let strArr = message?.timeStamp?.components(separatedBy: " ")
            var time = strArr?[3]
            let index = time?.index((time?.startIndex)!, offsetBy: 5)
            time = time?.substring(to: index!).appending(" ")
            let half = strArr?[4]
            timeLabel.text = time?.appending(half!)
        }
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    /// Helper func
    private func setupNameAndProfileImage()
    {
        if let id = message?.chatParterID()
        {   // Get message under user name
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]
                {   // Set name to cell's text label
                    self.textLabel?.text = dictionary["name"] as? String
                    // Set profile image
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String
                    {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
                //                print(snapshot)
                
            }, withCancel: nil)
        }
    }
    
    
    /// This func set profileImageView anchors
    ///
    /// - Parameters:
    ///   - style: style description
    ///   - reuseIdentifier: reuseIdentifier description
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        // Add constrait anchors for x, y, width and height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 7).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Add constrait anchors for x, y, width and height
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    /// Set text label and detail text label layout
    override func layoutSubviews() {
        super.layoutSubviews()
        // Text label starts 7 pixels after image (64 - 7(leftAnchor) - 50(width) = 7)
        // -/+ 2 creates gap between text label and detail text lable
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2,
                                  width: textLabel!.frame.width,
                                  height: textLabel!.frame.height)
        // Details follows text label
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2,
                                        width: detailTextLabel!.frame.width,
                                        height: detailTextLabel!.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) failed!")
    }
}
