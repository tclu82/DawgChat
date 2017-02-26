//
//  ViewController.swift
//  DawgChat
//
//  Created by Zac on 2/25/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Logout button upper left
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(logoutHandler))
        
        // user is not logged in
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            // Perform logoutHandler after 0 sec
            perform(#selector(logoutHandler), with: nil, afterDelay: 0)
        }
        
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
