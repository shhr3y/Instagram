//
//  UploadPostController.swift
//  Instagram
//
//  Created by Shrey Gupta on 22/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit


class UploadPostController: UIViewController {

    //MARK: - Properties
    let postImage: UIImage
    
    lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 10
        iv.image = postImage
        return iv
    }()
    
    lazy var captionTextView: UITextView = {
        let tv = UITextView()
        let attributedString = NSAttributedString(string: "Enter Caption", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
//        tf.leftView = paddingView
//        tf.leftViewMode = .always

//        tv.attributedPlaceholder = attributedString
        tv.backgroundColor = UIColor.systemGroupedBackground
        tv.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tv.layer.cornerRadius = 7
        return tv
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blueTint
        button.setTitle("Post", for: .normal)
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(handleUploadPost), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    init(image: UIImage) {
        self.postImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleUploadPost() {
        let caption = captionTextView.text ?? ""
        
        Service.shared.uploadPost(postImage, caption: caption) { (status) in
            if status {
                print("DEBUG: POST UPLOAD SUCCESSFULL!")
                self.dismiss(animated: true) {
                    self.tabBarController?.selectedIndex = 0
                }
            }else{
                print("DEBUG: POST UPLOAD FAILED!")
            }
        }
    }
    
    //MARK: - Helper Functions
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(postImageView)
        postImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 15)
        postImageView.setDimensions(height: 100, width: 100)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(left: postImageView.rightAnchor, right: view.rightAnchor, paddingLeft: 6, paddingRight: 15, height: 100)
        captionTextView.centerY(inView: postImageView)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: captionTextView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 6, paddingLeft: 15, paddingRight: 15, height: 50)
    }
}
