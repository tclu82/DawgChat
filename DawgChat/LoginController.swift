//
//  LoginController.swift
//  DawgChat
//
//  Created by Zac on 2/25/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import Firebase







import UIKit
import Firebase

class LoginController: UIViewController {
    
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleLoginRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
            }
            // Successfullu logged in our user
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones_splash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // Change height of inputContainerView
        inputsContainterViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // Change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameTextFieldHeightAnchor?.isActive = true
        
        // Change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Change height of passwordTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainterView()
        setupLoginRegisterButton()
        setupProfileimageView()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLoginRegisterSegmentedControl() {
        // Need x, y, width and height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier : 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    var inputsContainterViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainterView() {
        // Need x, y, width and height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainterViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainterViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // Need x, y, width and height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // Need x, y, width and height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Need x, y, width and height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Need x, y, width and height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Need x, y, width and height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        // Need x, y, width and height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileimageView() {
        // Need x, y, width and height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}











///// This class handles login
//class LoginController: UIViewController {
//    
//    // An input container for user credential
//    let inputContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        // make corner rounded
//        view.layer.cornerRadius = 5
//        view.layer.masksToBounds = true
//        return view
//    }()
//    
//    // An login button
//    lazy var loginRegisterButton: UIButton = {
//        let button = UIButton(type: .system)
//        // Gold color
//        button.backgroundColor = UIColor(r:240, g:215, b: 0)
//        button.setTitle("Welcome New Dawg!", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        // Determine login or register
//        button.addTarget(self, action: #selector(handleLoginOrRegister), for: .touchUpInside)
//        return button
//    }()
//    
//    /// Handle login or register
//    internal func handleLoginOrRegister()
//    {   // login is selected
//        if loginRegisterSegmentedControl.selectedSegmentIndex == 0
//        {
//            handleLogin()
//        }
//        // register is selected
//        else
//        {
//            handleRegister()
//        }
//    }
//    
//    /// Handle login
//    private func handleLogin()
//    {
//        // guard catch the wrong email input
//        guard let email = emailTextField.text, let password = passwordTextField.text else
//        {
//            print("Form is not valid")
//            return
//        }
//        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
//       
//            if err != nil
//            {
//                print(err!)
//                return
//            }
//            // Successfully login
//            self.dismiss(animated: true, completion: nil)
//        })
//    }
//    
//    /// Handle register
//    private func handleRegister()
//    {   // guard catch the email user input
//        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else
//        {
//            print("Form is not valid")
//            return
//        }
//        
//        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, err) in
//            
//            if err != nil
//            {
//                print(err!)
//                return
//            }
//            
//            guard let uid = user?.uid else
//            {
//                return
//            }
//            // User authenticated successfully
//            let ref = FIRDatabase.database().reference(fromURL: "https://dawgchat.firebaseio.com/")
//            
//            // Create child node reference for each new account, assign user id in Firebase
//            let userReference = ref.child("users").child(uid)
//            let values = ["name": name, "email": email]
//            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
//                
//                if error != nil
//                {
//                    print(error!)
//                    return
//                }
//                print("User is saved to Firebase database successfully")
//                self.dismiss(animated: true, completion: nil)
//            })
//        })
//    }
//    
//    // Textfields for user name input
//    let nameTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Name"
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        return tf
//    }()
//    
//    // Separator between name and email
//    let nameSeparatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    // Emailfields for user name input
//    let emailTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Email address"
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        return tf
//    }()
//    
//    // Separator between name and email
//    let emailSeparatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    // Passwordfields for user name input
//    let passwordTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Password"
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.isSecureTextEntry = true
//        return tf
//    }()
//    
//    // Login image
//    lazy var profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "dawg3")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        // Change fill style
//        imageView.contentMode = .scaleAspectFill
//        // Change profile image
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
//                                                              action: #selector(handleSelectProfileImageView)))
//        // Default false
//        imageView.isUserInteractionEnabled = true
//        return imageView
//    }()
//    
//    // Toggle button for switch between Login / Register
//    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
//        let sc = UISegmentedControl(items: ["Login", "Register"])
//        sc.translatesAutoresizingMaskIntoConstraints = false
//        // Set up the tint color, gold
//        sc.tintColor = UIColor(r: 240, g: 215, b: 0)
//        // Highlight the 2nd element in dictionary
//        sc.selectedSegmentIndex = 1
//        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
//        return sc
//    }()
//    
//    /// Handle the inputContainerView size change when switch between login and register
////    internal func handleLoginRegisterChange()
//    {   // Get title from selected toggle button name
//        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
//        loginRegisterButton.setTitle(title, for: .normal)
//        
//        // If 0 (login), set height 100, else (1, register) set to 150
//        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
//    
//        // If 0, take off name, else show name
//        nameTextFieldHeightAnchor?.isActive = false
//        nameTextFieldHeightAnchor = nameTextField.heightAnchor
//            .constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl
//                .selectedSegmentIndex == 0 ? 0 : 1/3)
//        // Update for Xcode 8 and Swift 3
//        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
//        nameTextFieldHeightAnchor?.isActive = true
//        
//        // Adjust email height
//        emailTextFieldHeightAnchor?.isActive = false
//        emailTextFieldHeightAnchor = emailTextField.heightAnchor
//            .constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl
//                .selectedSegmentIndex == 0 ? 1/2 : 1/3)
//        emailTextFieldHeightAnchor?.isActive = true
//        
//        // Adjust password height
//        passwordTextFieldHeightAnchor?.isActive = false
//        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor
//            .constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl
//                .selectedSegmentIndex == 0 ? 1/2 : 1/3)
//        passwordTextFieldHeightAnchor?.isActive = true
//    }
//    
//    /// Call super init
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // background color, purple
//        view.backgroundColor = UIColor(r: 128, g: 0, b: 128) // constructor overload
//        
//        view.addSubview(inputContainerView)
//        view.addSubview(loginRegisterButton)
//        view.addSubview(profileImageView)
//        view.addSubview(loginRegisterSegmentedControl)
//        
//        setupInputContainerView()
//        setupLoginRegisterButton()
//        setupProfileImageView()
//        setupLoginRegisterSegmentedControl()
//        
//    }
//    
//    /// Status bar style
//    override var preferredStatusBarStyle: UIStatusBarStyle
//    {
//        return .lightContent
//    }
//
//    // Variables for changing the height of text field
//    var inputContainerViewHeightAnchor: NSLayoutConstraint?
//    var nameTextFieldHeightAnchor: NSLayoutConstraint?
//    var emailTextFieldHeightAnchor: NSLayoutConstraint?
//    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
//    
//    /// Helper method for inputContainView
//    private func setupInputContainerView()
//    {
//        // x, y, width, height constraints
//        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        // left and right, each side has 12 pixel space
//        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
//        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
//        inputContainerViewHeightAnchor?.isActive = true
//        
//        // Add TextField and Separator to inputContainerView
//        inputContainerView.addSubview(nameTextField)
//        inputContainerView.addSubview(nameSeparatorView)
//        inputContainerView.addSubview(emailTextField)
//        inputContainerView.addSubview(emailSeparatorView)
//        inputContainerView.addSubview(passwordTextField)
//
//        setupUserInputTextField()
//    }
//    
//    /// Setup Login register button
//    private func setupLoginRegisterButton()
//    {
//        // x, y, width, height of constraints
//        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        // 12 pixel under inputContainerView bottom
//        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
//        // same width as inputContainerView
//        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
//        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
//    
//    /// Setup profile image
//    private func setupProfileImageView()
//    {
//        // x, y, width, height of constraints
//        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -20).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//    }
//    
//    /// Setup user login / register
//    private func setupUserInputTextField()
//    {
//        setupNameTextField()
//        setupEmailTextField()
//        setupPasswordTextField()
//    }
//    
//    /// Setup name TextField
//    private func setupNameTextField()
//    {
//        // x, y, width, height constraints
//        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
//        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
//        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
//        nameTextFieldHeightAnchor =
//            nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
//        nameTextFieldHeightAnchor?.isActive = true
//        
//        // x, y, width, height constraints
//        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
//        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
//        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
//        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//    }
//    
//    /// Setup email TextField
//    private func setupEmailTextField()
//    {
//        // x, y, width, height constraints
//        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
//        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
//        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
//        emailTextFieldHeightAnchor =
//            emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
//        emailTextFieldHeightAnchor?.isActive = true
//        
//        // x, y, width, height constraints
//        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
//        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
//        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
//        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//    }
//    
//    /// Setup password TextField
//    private func setupPasswordTextField()
//    {
//        // x, y, width, height constraints
//        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
//        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
//        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
//        passwordTextFieldHeightAnchor =
//            passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
//        passwordTextFieldHeightAnchor?.isActive = true
//    }
//
//    /// Setup Toggle button for user Loing / Register
//    private func setupLoginRegisterSegmentedControl()
//    {
//        // x, y, width, height constraints
//        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
//        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 1).isActive = true
//        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
//    }
//}
//
//// MARK: - helper class for UIColor
//extension UIColor
//{
//    convenience init(r: CGFloat, g: CGFloat, b: CGFloat)
//    {
//        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
//    }
//}
