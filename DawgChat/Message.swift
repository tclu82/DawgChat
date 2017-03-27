//
//  Message.swift
//  DawgChat
//
//  Created by Zac on 2/28/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromID: String?
    var toID: String?
    var text: String?
    var timeStamp: String?
    
    /// Check message determine the chat partner
    ///
    /// - Returns: Partner ID
    func chatParterID() -> String?
    {
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
}
