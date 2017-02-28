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
    
    /// Call super init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Logout button upper left
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
                                                           action: #selector(logoutHandler))
        
        let image = UIImage(named: "new_message")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self,
                                                            action: #selector(newMessageHandler))
        checkIfUserLogin()
    }
    
    /// Handle new message
    func newMessageHandler()
    {   // call NewMessageController for new message
        let newMessageController = NewMessageController()
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
    
        titleView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action:#selector(showChatController)))
    
    }
    
    func showChatController()
    {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
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
