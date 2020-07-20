//
//  SignupController.swift
//  Instagram
//
//  Created by Shrey Gupta on 20/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
import Firebase

class SignupController: UIViewController {
    //MARK: - Properties
    private let instagramLogo: UIImageView = {
        let iv =  UIImageView()
        iv.image = UIImage(imageLiteralResourceName: "instagram_logo_black")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let profilePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(imageLiteralResourceName: "profile").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField().textField(withPlaceholder: "Email", isSecureText: false)
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        
        return tf
    }()
    
    private let fullnameTextField: UITextField = {
        let tf = UITextField().textField(withPlaceholder: "Full Name", isSecureText: false)
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = UITextField().textField(withPlaceholder: "Username", isSecureText: false)
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField().textField(withPlaceholder: "Password", isSecureText: true)
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        
        return tf
    }()
    
    private let signupButton:  UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.dullBlueColor
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleCreateUser), for: .touchUpInside)
        
        return button
    }()
    
    let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.blueTint]))
        
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleShowSignIn(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleCreateUser(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        
        
    }
    
    @objc func formValidation(){
        guard emailTextField.hasText, fullnameTextField.hasText,
            usernameTextField.hasText, passwordTextField.hasText else {
                signupButton.isEnabled = false
                signupButton.backgroundColor = UIColor.dullBlueColor
                return
        }
        signupButton.isEnabled = true
        signupButton.backgroundColor = UIColor.blueTint
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        self.setupToHideKeyboardOnTapOnView()
        
        view.addSubview(instagramLogo)
        instagramLogo.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: view.frame.height - (view.frame.height * 0.98))
        instagramLogo.setDimensions(height: 50, width: view.frame.width)
        
        view.addSubview(profilePhotoButton)
        profilePhotoButton.anchor(top: instagramLogo.bottomAnchor, paddingTop: 50)
        profilePhotoButton.centerX(inView: view)
        profilePhotoButton.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [fullnameTextField, emailTextField, usernameTextField,
                                                   passwordTextField, signupButton])
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.anchor(top: profilePhotoButton.bottomAnchor, paddingTop: 40, width: 350)
        stack.centerX(inView: view)
        
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        alreadyHaveAnAccountButton.centerX(inView: view)
    }
}
