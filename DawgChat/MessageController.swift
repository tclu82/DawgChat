//
//  ViewController.swift
//  DawgChat
//
//  Created by Zac on 2/25/17.
//  Copyright © 2017 Zac. All rights reserved.


import UIKit
import Firebase


///// This class shows message and has a logout UIBarButtonItem for logout
//class MessageController: UITableViewController {
//    
//    /// Call super init
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Logout button upper left
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
//                                                           action: #selector(logoutHandler))
//        
//        let image = UIImage(named: "new_message")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self,
//                                                            action: #selector(newMessageHandler))
//        checkIfUserLogin()
//    }
//    
//    /// Handle new message
//    func newMessageHandler()
//    {   // call NewMessageController for new message
//        let newMessageController = NewMessageController()
//        let navController = UINavigationController(rootViewController: newMessageController)
//        present(navController, animated: true, completion: nil)
//    }
//    
//    /// This func is added for Xcode 8 and Swift 3
//    ///
//    /// - Parameter animated: animated description
//    override func viewWillAppear(_ animated: Bool) {
//        checkIfUserLogin()
//    }
//    
//    /// Check if user login
//    func checkIfUserLogin()
//    {
//        // user is not login
//        if FIRAuth.auth()?.currentUser?.uid == nil
//        {
//            // Perform logoutHandler after 0 sec
//            perform(#selector(logoutHandler), with: nil, afterDelay: 0)
//        }
//        else {
//            let uid = FIRAuth.auth()?.currentUser?.uid
//            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
////                print(snapshot)
//                if let dictionary = snapshot.value as? [String: Any] {
//                    self.navigationItem.title = dictionary["name"] as? String
//                }
//            }, withCancel: nil)
//        }
//    }
//
//    /// Handle logout
//    func logoutHandler()
//    {
//        do {
//            try FIRAuth.auth()?.signOut()
//        }
//        catch let logoutErr {
//            print(logoutErr)
//        }
//
//        // Go back to LoginController
//        let loginController = LoginController()
//        present(loginController, animated: true, completion: nil)
//    }
//}





class MessagesController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            }, withCancel: nil)
        }
    }
<<<<<<< HEAD

    /// Handle logout
    func logoutHandler()
    {
=======
    
    func handleLogout() {
        
>>>>>>> a140ba4d2f22259f597849c8c0a82aed3cb8180c
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}


