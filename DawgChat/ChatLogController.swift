//
//  ChatLogController.swift
//  DawgChat
//
//  Created by Zac on 2/27/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
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
        didSet {
            navigationItem.title = user?.name
        
            observeMessages()
        }
    }
    // An array of messages
    var messages = [Message]()
    
    /// Get messges from current user
    func observeMessages()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        
        // Fetch info from user-messages, all children are messages of the current user
        userMessagesRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            // print(snapshot)
            
            let messageID = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageID)
            
            // From user-messages, fetch each message
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // print(snapshot)
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let message = Message()
                // Crash if keys don't match
                message.setValuesForKeys(dictionary)
                // Check if message belongs to current user
                if message.chatParterID() == self.user?.id
                {
                    self.messages.append(message)
                    // Do it in threads
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
                // print(message.text)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.title = "Chat log"
        
        // Vertical drawable
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        
        setupInputComponents()
    }

    let cellID = "cellID"
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID,
                                                      for: indexPath) as! ChatMessageCell
//        cell.backgroundColor = UIColor.blue
        
        // Fetch messges then show them
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    /// Helper func to set up componenets for chat controller
    private func setupInputComponents()
    {
        let containerView = UIView()
//        containerView.backgroundColor = UIColor.red
        containerView.backgroundColor = UIColor.white
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
        let toID = user?.id!
        let fromID = FIRAuth.auth()?.currentUser?.uid
        // For time
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy HH:mm:ss a"
        dateFormatter.timeZone = NSTimeZone(name: "PST") as TimeZone!
        let timeStamp = dateFormatter.string(from: date as Date)
        
        let values = ["text": inputTextField.text!, "toID": toID, "FromID": fromID,
                      "timeStamp": timeStamp]
//        childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { (err, ref) in
            if err != nil
            {
                print(err!)
                return
            }
            // Save messages according to user id
            let userMessageRef = FIRDatabase.database().reference()
                .child("user-messages").child(fromID!)
            
            let messageID = childRef.key
            userMessageRef.updateChildValues([messageID: 1])
            
            // Put messages under assigned user
            let recipientUserMessageRef = FIRDatabase.database().reference()
                .child("user-messages").child(toID!)
            recipientUserMessageRef.updateChildValues([messageID: 1])
            
        }
        
        
        
    
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
