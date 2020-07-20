//
//  LoginController.swift
//  Instagram
//
//  Created by Shrey Gupta on 20/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    
    //MARK: - Properties
    private let instagramLogo: UIImageView = {
        let iv =  UIImageView()
        iv.image = UIImage(imageLiteralResourceName: "instagram_logo_black")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField().textField(withPlaceholder: "Email", isSecureText: false)
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
    
    private let loginButton:  UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.dullBlueColor
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.blueTint]))
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    //MARK: - Selectors
    
    @objc func handleShowSignUp(){
        let vc = SignupController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("DEBUG: Error from handleLogin: \(error.localizedDescription)")
                return
            }
            print("DEBUG: handleLogin Successful for : \(email)")
        }
    }
    
    @objc func formValidation(){
        guard emailTextField.hasText, passwordTextField.hasText else {
                loginButton.isEnabled = false
                loginButton.backgroundColor = UIColor.dullBlueColor
                return
        }
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor.blueTint
    }
    
    //MARK: - Helper Functions
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        self.setupToHideKeyboardOnTapOnView()
        
        view.addSubview(instagramLogo)
        instagramLogo.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: view.frame.height - (view.frame.height * 0.8))
        instagramLogo.setDimensions(height: 80, width: view.frame.width)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.anchor(top: instagramLogo.bottomAnchor, paddingTop: 40, width: 350)
        stack.centerX(inView: view)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        dontHaveAccountButton.centerX(inView: view)
    }
    
}
