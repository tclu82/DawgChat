//
//  LoginController_Handler.swift
//  DawgChat
//
//  Created by Zac on 2/26/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// Handle select profile Image View
    func handleSelectProfileImageView()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        // Edit image
        picker.allowsEditing = true
        // Add "Privacy of Photo" in plist
        present(picker, animated: true, completion: nil)
    }
    
    /// Image picker for profile image replacement
    ///
    /// - Parameters:
    ///   - picker: picker description
    ///   - info: info description
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //        print(info)
        
        var selectedImageFromPicker: UIImage?
        // When editing image "Choose"
        if let editedImage = info["UIImagePickerControllerOriginalImage"] as! UIImage?
        {
            selectedImageFromPicker = editedImage
        }
        // When image is chosen, but no editing
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as! UIImage?
        {
            selectedImageFromPicker = originalImage
        }
        
        // This the chosen one for profile image
        if let selectedImage = selectedImageFromPicker
        {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    /// Cancel image picker
    ///
    /// - Parameter picker: <#picker description#>
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Handle register
    func handleRegister()
    {   // guard catch the email user input
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else
        {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, err) in
            
            if err != nil
            {
                print(err!)
                return
            }
            
            guard let uid = user?.uid else
            {
                return
            }
            
            // User authenticated successfully
            
            // UUID to store individual image
            let imageName = NSUUID().uuidString
            // Stores image inside "profile_images" with imageName (UUID)
            let storageRef = FIRStorage.storage().reference().child("profile_images")
                .child("\(imageName).png")
            // Upload image data
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email,
                                      "profileImageUrl": profileImageUrl]
                        self.registerUserInfoDatabaseWithUID(uid: uid, values: values)
                    }
                })
            }
        })
    }
    
    /// Register name, email, image to Firebase
    ///
    /// - Parameters:
    ///   - uid: <#uid description#>
    ///   - values: <#values description#>
    private func registerUserInfoDatabaseWithUID(uid: String, values: [String: Any])
    {
        let ref = FIRDatabase.database().reference(fromURL: "https://dawgchat.firebaseio.com/")
        
        // Create child node reference for each new account, assign user id in Firebase
        let userReference = ref.child("users").child(uid)
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            if error != nil
            {
                print(error!)
                return
            }
            print("User is saved to Firebase database successfully")
            self.dismiss(animated: true, completion: nil)
        })
    }
}
