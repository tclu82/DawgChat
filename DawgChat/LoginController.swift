//
//  LoginController.swift
//  DawgChat
//
//  Created by Zac on 2/25/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    // An input container for user credential
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        // make corner rounded
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    // An login button
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        // Gold color
        button.backgroundColor = UIColor(r:240, g:215, b: 0)
        button.setTitle("Welcome New Dawg!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func handleRegister()
    {   // guard catch the wrong email input
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
            let ref = FIRDatabase.database().reference(fromURL: "https://dawgchat.firebaseio.com/")
            // Create child node reference for each new account
            // Assign user id in Firebase
            let userReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                
                if error != nil
                {
                    print(error!)
                    return
                }
                
                print("User is saved to Firebase database successfully")
            })
            
        })
    }
    
    // Textfields for user name input
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // Separator between name and email
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // Emailfields for user name input
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // Separator between name and email
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // Passwordfields for user name input
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    // Login image
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dawg2")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Change fill style
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // background color
//        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        // Purple color
        view.backgroundColor = UIColor(r: 128, g: 0, b: 128) // constructor overload

        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        
        setupInputContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
    }
    
    private func setupInputContainerView()
    {
        // x, y, width, height constraints
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // left and right, each side has 12 pixel space
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // Add TextField and Separator to inputContainerView
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeparatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordTextField)
        
        setupUserInputTextField()
    
        
    }

    private func setupLoginRegisterButton()
    {
        // x, y, width, height of constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // 12 pixel under inputContainerView bottom
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        // same width as inputContainerView
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupProfileImageView()
    {
        // x, y, width, height of constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func setupUserInputTextField()
    {
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
    }
  
    private func setupNameTextField()
    {
        // x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        // x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setupEmailTextField()
    {
        // x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        // x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setupPasswordTextField()
    {
        // x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}

extension UIColor
{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat)
    {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
