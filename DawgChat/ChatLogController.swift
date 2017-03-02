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
    private func observeMessages()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let userMessagesRef = FIRDatabase.database().reference()
            .child("user-messages").child(uid)
        
        // Fetch info from user-messages, observe all children are messages of the current user
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
//            print(snapshot)
            let messageID = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageID)
            
            // From user-messages, fetch single message
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                 print(snapshot)
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let message = Message()
                // Crash if keys don't match
                message.setValuesForKeys(dictionary)
                
                // Check if message belongs to current user
                if message.chatParterID() == self.user?.id
                {
                    self.messages.append(message)
                    // Do it in background threads
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    let cellID = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 10 pixels from top, 60 from bottom
        collectionView?.contentInset = UIEdgeInsetsMake(10, 0, 60, 0)
        // Chane the scroll indicator as well (top can be 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 60, 0)

        // Vertical drawable
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.black
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        setupInputComponents()
        setupKeyboardObservers()
    }

    /// Observe keyboard scrolling
    private func setupKeyboardObservers()
    {   // Keyboard up
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        // Keyboard down
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(notification: NSNotification)
    {
//        print(notification.userInfo!)
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue
//        print(keyboardFrame?.height)
        // Move input area above keyboard
        containerViewBottomAnchor?.constant = -(keyboardFrame!.height)
    }
    
    func handleKeyboardWillHide(notification: NSNotification)
    {
        containerViewBottomAnchor?.constant = 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID,
                                                      for: indexPath) as! ChatMessageCell
        // Fetch messges then show them
        let message = messages[indexPath.item]
        cell.textView.text = message.text

        setupCell(cell: cell, message: message)
        
        // Modify bubbleView's width
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 30
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message)
    {   // Set up profile image inside chat log
        if let profileImageUrl = self.user?.profileImageUrl
        {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        // user message
        if message.fromID == FIRAuth.auth()?.currentUser?.uid
        {
            cell.bubbleView.backgroundColor = ChatMessageCell.midPurpleColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }
        // partner message
        else
        {
            cell.bubbleView.backgroundColor = ChatMessageCell.goldColor
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    /// Handle rotation resize
    ///
    /// - Parameters:
    ///   - size: size description
    ///   - coordinator: coordinator description
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    /// Return the height of textField
    ///
    /// - Parameters:
    ///   - collectionView: collectionView description
    ///   - collectionViewLayout: collectionViewLayout description
    ///   - indexPath: indexPath description
    /// - Returns: return value description
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height:CGFloat = 80
        
        if let text = messages[indexPath.item].text
        {
            height = estimateFrameForText(text: text).height + 20
        }
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect
    {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options,
                                                   attributes: [NSFontAttributeName:
                                                    UIFont.systemFont(ofSize: 16)],
                                                   context: nil)
    }
    
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
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
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        
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
            // Remove text after input
            self.inputTextField.text = nil
            
            // Save messages according to user id
            let userMessageRef = FIRDatabase.database().reference()
                .child("user-messages").child(fromID!)
            
            let messageID = childRef.key
            userMessageRef.updateChildValues([messageID: 1])
            
            // Put messages under assigned user
            let recipientUserMessageRef = FIRDatabase.database().reference()
                .child("user-messages").child(toID)
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
