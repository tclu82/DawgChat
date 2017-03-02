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
    
    let bubbleView: UIView = {
        let view = UIView()
        // Mediumpurple
        view.backgroundColor = UIColor(r: 147, g: 112, b: 219)
        view.translatesAutoresizingMaskIntoConstraints = false
        // Make the corner round
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Add buubleView then textView
        addSubview(bubbleView)
        addSubview(textView)
        // Add x, y, width, and height constraint to textView
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
//        bubbleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Add x, y, width, and height constraint to textView
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
