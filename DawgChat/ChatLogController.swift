//
//  ChatLogController.swift
//  DawgChat
//
//  Created by Zac on 2/27/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    // Create text field for input message
    lazy var inputTextField: UITextField = {
        let input = UITextField()
        input.placeholder = "Say something..."
        input.translatesAutoresizingMaskIntoConstraints = false
        // So "enter" can sent the messge directly
        input.delegate = self
        return input
    }()
    
    /// Chat with this user, and set its name to Navigation tile
    var user: User? {
        didSet { navigationItem.title = user?.name }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.title = "Chat log"
        collectionView?.backgroundColor = UIColor.white
        setupInputComponents()
    }

    
    private func setupInputComponents()
    {
        let containerView = UIView()
//        containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // Add x, y, width and height constraint anchors
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Create Send button for message
        let sendButton = UIButton(type: .system)  // for system interaction
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        containerView.addSubview(sendButton)
        // Add x, y, width and height constraint anchors
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
     
//        // Create text field for input message
//        let inputTextField = UITextField()
//        inputTextField.placeholder = "Say something..."
//        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(inputTextField)
        // Add x, y, width and height constraint anchors
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10)
            .isActive = true // 10 pixels away from left anchor
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        inputTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    
        // Create a separator for input text and users
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(separatorLineView)
        // Add x, y, width and height constraint anchors
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: inputTextField.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        
    }
    
    /// Trigger when send button is touched
    func handleSend()
    {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        // name can be changed, use uid
        let toID = user!.id!
        let fromID = FIRAuth.auth()?.currentUser?.uid
        // For time
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy HH:mm:a"
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone!
        let timeStamp = dateFormatter.string(from: date as Date)
        
        let values = ["text": inputTextField.text!, "toID": toID, "FromID": fromID,
                      "timeStamp": timeStamp]
        childRef.updateChildValues(values)
    
//        print(inputTextField.text!)
    }
    
    /// Send messge with enter key
    ///
    /// - Parameter textField: <#textField description#>
    /// - Returns: <#return value description#>
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        handleSend()
        return true
    }
}
