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
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
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
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

/// Inner class for UITableViewCell for User
class UserCell: UITableViewCell {

    var profileImageViewRadius: Int = { return 20 }()
    
    // A property for customize profile image view
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "cat")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Radius = height / 2
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    /// This func set profileImageView anchors
    ///
    /// - Parameters:
    ///   - style: style description
    ///   - reuseIdentifier: reuseIdentifier description
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        
        // Add constrait anchors for x, y, width and height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 7).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    /// Set text label and detail text label layout
    override func layoutSubviews() {
        super.layoutSubviews()
        // Text label starts 7 pixels after image (64 - 7(leftAnchor) - 50(width) = 7)
        // -/+ 2 creates gap between text label and detail text lable
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2,
                                  width: textLabel!.frame.width,
                                  height: textLabel!.frame.height)
        // Details follows text label
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2,
                                        width: detailTextLabel!.frame.width,
                                        height: detailTextLabel!.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) failed!")
    }
}
