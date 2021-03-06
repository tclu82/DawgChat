//
//  ViewController.swift
//  DawgChat
//
//  Created by Zac on 2/25/17.
//  Copyright © 2017 Zac. All rights reserved.


import UIKit
import Firebase

/// This class shows message and has a logout UIBarButtonItem for logout
class MessageController: UITableViewController {
    
    var cellID = "cellID"
    
    /// Call super init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Logout button upper left
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain,
                                                           target: self,
                                                           action: #selector(logoutHandler))
        
        let image = UIImage(named: "new_message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain,
                                                            target: self,
                                                            action: #selector(newMessageHandler))
        checkIfUserLogin()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
//        observeMessages()
        
//        observeUserMessages()
    
    }
    
    // A message array contains all messages
    var messgaes = [Message]()
    // A dictionary mapping message and toID
    var messageDictionary = [String: Message]()
    
    // For reload to solve worng image loaded
    var timer: Timer?
    
    /// Obserseve messages accrording user
    private func observeUserMessages()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
//            print(snapshot)
            
            let messageID = snapshot.key
            let messageRef = FIRDatabase.database().reference().child("messages").child(messageID)
            
            messageRef.observe(.value, with: { (snapshot) in
//                print(snapshot)
                
                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    //                print(message.text!)
                    //                print(message.fromID!)
                    
                    //                self.messgaes.append(message)
                    
                    if let toID = message.toID
                    {
                        self.messageDictionary[toID] = message
                        // Set dictionary values set to messages array
                        self.messgaes = Array(self.messageDictionary.values)
                    }
                    
                    // Invalid all the timer, only the last one is valid
                    self.timer?.invalidate()
                    print("cancel timer")
                    
                    // After 0.1 sec, table reload
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                         selector: #selector(self.handleReloadTable),
                                         userInfo: nil, repeats: false)
                    print("scheduled table reload in 0.1 sec")
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    /// Helper func to reload image
    func handleReloadTable()
    {
        // Put into background thread, otherwise will crashed
        DispatchQueue.main.async{
             print("table reloaded")
            self.tableView.reloadData()
        }
    }
    
    
    /// Observe messages from Firebase DB
    private func observeMessages()
    {
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                if let chatParterID = message.chatParterID()
                {
                    self.messageDictionary[chatParterID] = message
                    // Set dictionary values set to messages array
                    self.messgaes = Array(self.messageDictionary.values)
                }
            
                // Put into background thread, otherwise will crashed
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    /// Use message count as row number
    ///
    /// - Parameters:
    ///   - tableView: tableView description
    ///   - section: section description
    /// - Returns: return value description
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messgaes.count
    }
    
    /// Display message in each cell
    ///
    /// - Parameters:
    ///   - tableView: tableView description
    ///   - indexPath: indexPath description
    /// - Returns: return value description
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath) as! UserCell
        let message = messgaes[indexPath.row]
        cell.message = message
        cell.detailTextLabel?.text = message.text
        return cell
    }
    
    /// Change the Row height
    ///
    /// - Parameters:
    ///   - tableView: tableView description
    ///   - indexPath: indexPath description
    /// - Returns: return value description
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let message = messgaes[indexPath.row]

        // Get partner id
        guard let chatPartnerID = message.chatParterID() else { return }
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot)
            
            // Parse JSON
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User()
            user.id = chatPartnerID
            user.setValuesForKeys(dictionary)
            // When chat partner is selected, pop-up chat controller
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
    }
    
    /// Handle new message
    func newMessageHandler()
    {   // call NewMessageController for new message
        let newMessageController = NewMessageController()
        newMessageController.messageController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    /// This func is added for Xcode 8 and Swift 3
    ///
    /// - Parameter animated: animated description
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserLogin()
    }
    
    /// Check if user login
    private func checkIfUserLogin()
    {
        // user is not login
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            // Perform logoutHandler after 0 sec
            perform(#selector(logoutHandler), with: nil, afterDelay: 0)
        }
        else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    /// Setup NaviBarTitle with current user
    func fetchUserAndSetupNavBarTitle()
    {   // Make sure uid is valid
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            // uid is nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            //                print(snapshot)
            if let dictionary = snapshot.value as? [String: Any]
            {
                self.navigationItem.title = dictionary["name"] as? String
                
                // Adjust length legnth, make sure inside the Navigation bar
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    /// Setup text label to fit in Navigation Bar
    ///
    /// - Parameter user: user description
    func setupNavBarWithUser(user: User)
    {
        // Whenever login, remove all messages
        messgaes.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
        // Load messages according login user
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        titleView.backgroundColor = UIColor.red
        
        let containerVeiw = UIView()
        containerVeiw.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerVeiw)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        // Half of width/height
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageUrl = user.profileImageUrl
        {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        // add to subview before adding anchors
        containerVeiw.addSubview(profileImageView)
        // Add x, y, width and height constraint anchors for titleView
        profileImageView.leftAnchor.constraint(equalTo: containerVeiw.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerVeiw.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Setup name label
        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        // add to subview before adding anchors
        containerVeiw.addSubview(nameLabel)
        // Add x, y, width and height constraint anchors for titleView
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerVeiw.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerVeiw.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerVeiw.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    
//        titleView
//            .addGestureRecognizer(UITapGestureRecognizer(target: self,
//                                                         action:#selector(showChatController)))
    
    }
    
    /// Show the chat controller to start a new chat
    func showChatControllerForUser(user: User)
    {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    /// Handle logout
    func logoutHandler()
    {
        do {
            try FIRAuth.auth()?.signOut()
        }
        catch let logoutErr {
            print(logoutErr)
        }

        // Go back to LoginController
        let loginController = LoginController()
        loginController.messageController = self
        present(loginController, animated: true, completion: nil)
    }
}
