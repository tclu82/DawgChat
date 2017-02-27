//
//  ViewController.swift
//  DawgChat
//
//  Created by Zac on 2/25/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Logout button upper left
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,
                                                           action: #selector(logoutHandler))
        checkIfUserLogin()
    }
    
    private func checkIfUserLogin()
    {
        // user is not logged in
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            // Perform logoutHandler after 0 sec
            perform(#selector(logoutHandler), with: nil, afterDelay: 0)
        }
//        else {
//            
//            let uid = FIRAuth.auth()?.currentUser?.uid
//            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
//               
//                print(snapshot)
//                
////                if let dictionary = snapshot.value as? [String: AnyObject] {
////                    self.navigationItem.title = dictionary["name"] as? String
////                }
//                
//            }, withCancel: nil)
//        }
        
    }
    
    @objc private func logoutHandler()
    {
        do {
            try FIRAuth.auth()?.signOut()
        }
        catch let logoutErr {
            print(logoutErr)
        }

        // Go back to LoginController
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}
