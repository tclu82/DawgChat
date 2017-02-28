//
//  LoginController.swift
//  DawgChat
//
//  Created by Zac on 2/25/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase

/// This class handles login
class LoginController: UIViewController {
    
    var messageController: MessageController?
    
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
    lazy var  loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        // Gold color
        button.backgroundColor = UIColor(r:240, g:215, b: 0)
        button.setTitle("Welcome New Dawg!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        // Determine login or register
        button.addTarget(self, action: #selector(handleLoginOrRegister), for: .touchUpInside)
        return button
    }()
    
    /// Handle login or register
    func handleLoginOrRegister()
    {   // login is selected
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0
        {
            handleLogin()
        }
        // register is selected
        else
        {
            handleRegister()
        }
    }
    
    /// Handle login
    private func handleLogin()
    {
        // guard catch the wrong email input
        guard let email = emailTextField.text, let password = passwordTextField.text else
        {
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
       
            if err != nil
            {
                print(err!)
                return
            }
            // Successfully login
            
            // Fetch current user and set its name to NavBarTitle
            self.messageController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
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
        tf.placeholder = "Email address"
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
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dawg3")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Change fill style
        imageView.contentMode = .scaleAspectFill
        // Triggle when touch profile image
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        // Default false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // Toggle button for switch between Login / Register
    lazy var  loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        // Set up the tint color, gold
        sc.tintColor = UIColor(r: 240, g: 215, b: 0)
        // Highlight the 2nd element in dictionary
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    /// Handle the inputContainerView size change when switch between login and register
    func handleLoginRegisterChange()
    {   // Get title from selected toggle button name
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // If 0 (login), set height 100, else (1, register) set to 150
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
    
        // If 0, take off name, else show name
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor
            .constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl
                .selectedSegmentIndex == 0 ? 0 : 1/3)
        // Update for Xcode 8 and Swift 3
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        nameTextFieldHeightAnchor?.isActive = true
        
        // Adjust email height
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor
            .constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl
                .selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Adjust password height
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor
            .constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl
                .selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    /// Call super init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color, purple
        view.backgroundColor = UIColor(r: 128, g: 0, b: 128) // constructor overload
        
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        
    }
    
    /// Status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    // Variables for changing the height of text field
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    /// Helper method for inputContainView
    private func setupInputContainerView()
    {
        // x, y, width, height constraints
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // left and right, each side has 12 pixel space
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive = true
        
        // Add TextField and Separator to inputContainerView
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeparatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordTextField)

        setupUserInputTextField()
    }
    
    /// Setup Login register button
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
    
    /// Setup profile image
    private func setupProfileImageView()
    {
        // x, y, width, height of constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    /// Setup user login / register
    private func setupUserInputTextField()
    {
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
    }
    
    /// Setup name TextField
    private func setupNameTextField()
    {
        // x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor =
            nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    /// Setup email TextField
    private func setupEmailTextField()
    {
        // x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor =
            emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    /// Setup password TextField
    private func setupPasswordTextField()
    {
        // x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor =
            passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }

    /// Setup Toggle button for user Loing / Register
    private func setupLoginRegisterSegmentedControl()
    {
        // x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

// MARK: - helper class for UIColor
extension UIColor
{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat)
    {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
