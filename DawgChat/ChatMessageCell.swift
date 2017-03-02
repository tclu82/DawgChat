//
//  ChatMessageCell.swift
//  DawgChat
//
//  Created by Zac on 3/1/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit

/// This class arragnes message in each cell
class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
//        tv.text = "Fake one"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        // To show the backgroud color
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        return tv
    }()
    
    static let midPurpleColor = UIColor(r: 147, g: 112, b: 219)
    
    static let goldColor = UIColor(r: 255, g: 215, b: 0)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = midPurpleColor
        view.translatesAutoresizingMaskIntoConstraints = false
        // Make the corner round
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "cat")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Make the imageView rounded
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Add buubleView then textView
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        // Add x, y, width, and height constraint to textView
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                                  constant: -10)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor
            .constraint(equalTo: profileImageView.rightAnchor, constant: 10)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Add x, y, width, and height constraint to textView
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Add x, y, width, and height constraint to textView
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
