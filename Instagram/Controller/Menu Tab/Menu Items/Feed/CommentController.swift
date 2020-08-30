//
//  CommentController.swift
//  Instagram
//
//  Created by Shrey Gupta on 23/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit

private let resuseIdentitfier = "CommentCellIdentifier"

class CommentController: UICollectionViewController {
    //MARK: - Properties
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let stack = UIStackView(arrangedSubviews: [commentTextField, sendButton])
        stack.axis = .horizontal
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        containerView.addSubview(separatorView)
        separatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, height: 1)
        
        containerView.addSubview(stack)
        stack.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingLeft: 10)
        stack.centerY(inView: containerView)
        
        return containerView
    }()
    
    private let commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Comment.."
        tf.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return tf
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize:  14)
        button.setDimensions(height: 50, width: 70)
        return button
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell Class
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: resuseIdentitfier)
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG:- APPEAR CALLED")
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    // ALLOWS KEYBOARD AND VIEW NOT TO OVERLAP EACH OTHER
    override var inputAccessoryView: UIView? {
        get {
            containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    
    func configureUI() {
        self.navigationItem.title = "Comments"
        self.collectionView.backgroundColor = .white
    }
    
    //MARK: - UICollectionView
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
     
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentitfier, for: indexPath) as! CommentCell
        cell.commentLabel.text = "this is test : \(indexPath.row)"
        return cell
    }

}

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}
