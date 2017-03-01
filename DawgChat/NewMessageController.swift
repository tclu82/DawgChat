//
//  NewMessageController.swift
//  DawgChat
//
//  Created by Zac on 2/26/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase

/// NewMessageController class for new message view
class NewMessageController: UITableViewController {
    // a cellId for each cell
    let cellId = "cellId"
    // An array to contain all the user from Firebase db
    var users = [User]()
    
    /// Call super init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                                           action: #selector(cancelHandler))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    /// Fetch user from Firebase db
    private func fetchUser()
    {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                // Use snapshot's key as user id (UUID)
                user.id = snapshot.key
//                user.setValuesForKeys(dictionary)
                user.name = dictionary["name"] as! String?
                user.email = dictionary["email"] as! String?
                user.profileImageUrl = dictionary["profileImageUrl"] as! String?
//                print(user.name, user.email)
                
                // put user into user array
                self.users.append(user)
     
                // Put threads into dispatch queue
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
     
//            print("User found")
//            print(snapshot)
            
        }, withCancel: nil)
    }
    
    /// Handle cancel and jump back to the caller
    func cancelHandler()
    {
        dismiss(animated: true, completion: nil)
    }

    /// Return how many users in Firebase db
    ///
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: section description
    /// - Returns: return user number
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    /// Display name and email in each cell
    ///
    /// - Parameters:
    ///   - tableView: tableView description
    ///   - indexPath: indexPath description
    /// - Returns: return value description
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
//        // Load image for each user
//        cell.imageView?.image = UIImage(named: "cat")
//        // Ratio is not fit for profile
//        cell.imageView?.contentMode = .scaleAspectFill
        
        // Use image from Firebase for user profile display
        if let profileImageUrl = user.profileImageUrl
        {
            // Load image from Extensions.swift for cache handling
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            
            // Need to use cache to reduce data usage
//            let url = NSURL(string: profileImageUrl)
//            URLSession.shared.dataTask(with: url as! URL, completionHandler: { (data, response, err) in
//                
//                // Download failed!
//                if err != nil
//                {
//                    print(err!)
//                    return
//                }
//                DispatchQueue.main.async {
//                    cell.profileImageView.image = UIImage(data: data!)
////                    cell.imageView?.image = UIImage(data: data!)
//                }
//              
//            }).resume()
        }
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

    var messageController: MessageController?
    
    /// Dismiss for new chat
    ///
    /// - Parameters:
    ///   - tableView: tableView description
    ///   - indexPath: indexPath description
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { 
//            print("Finished!")
            let user = self.users[indexPath.row]
            self.messageController?.showChatControllerForUser(user: user)
        }
    }
}

