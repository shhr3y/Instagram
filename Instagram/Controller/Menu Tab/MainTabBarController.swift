//
//  HomeController.swift
//  Instagram
//
//  Created by Shrey Gupta on 22/07/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    //MARK: - Properties
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Checking Authetication Status
        checkIfTheUserIsLoggedIn()
        
        //UITabBarController Delegate
        self.delegate = self
    }

    //MARK: - Helper Functions
    
    // Function to create ViewControllers that exists within TabBarController
    func configureTabBarViewControlllers() {
        
        // FeedViewController
        let feedVC = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feedNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: feedVC)
        
        // Search Feed Controller
        let searchVC = SearchController()
        let searchNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: searchVC)
        
        // Select Image Post Controller
        let uploadPostNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        // Notification Controller
        let notificationVC = NotificationController()
        let notificationNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: notificationVC)
        
        // Profile Controller
        let profileVC = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let profileNC = constructNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileVC)
        
        // VC to be added to TabMenu Bar
         viewControllers = [feedNC, searchNC, uploadPostNC, notificationNC, profileNC]
        
        // Tab Bar Tint color
        tabBar.tintColor = .black
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            let uploadPostVC = SelectImageViewController(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: uploadPostVC)
            navController.modalPresentationStyle = .fullScreen
            navController.navigationBar.tintColor = .black
            
            present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> (UINavigationController){
        // Construct NavController
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        navController.navigationBar.tintColor = .black
        
        // Return NavController
        return navController
    }
    
    func checkIfTheUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            //User not logged in
            DispatchQueue.main.async {
                let loginVC = LoginController()
                let navigationVC = UINavigationController(rootViewController: loginVC)
                navigationVC.modalPresentationStyle = .fullScreen
                self.present(navigationVC, animated: true, completion: nil)
            }
        }else{
            //User is logged In
            configureTabBarViewControlllers()
        }
    }
}


