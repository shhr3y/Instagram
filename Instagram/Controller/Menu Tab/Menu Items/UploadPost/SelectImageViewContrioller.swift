//
//  SelectImageViewContrioller.swift
//  Instagram
//
//  Created by Shrey Gupta on 09/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "SelectPhotoCell"
private let headerIdentifier = "SelectPhotoHeader"

class SelectImageViewController: UICollectionViewController {
    //MARK: - Properties
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImageThumbnail: UIImage?
    var selectedImage: UIImage?
    
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configuring nav buttons
        configureNavigationBar()
        
        //fetching photos
        fetchPhotos()
        
        //setting background color
        collectionView.backgroundColor = .white
        
        //register cells and headers
        collectionView.register(SelectPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(SelectPhotoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    //MARK: - Selectors
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        //check wheather there is a selected image, if not return out of the function
        guard let _ = self.selectedImage else { return }
        
        //if image is there, push UploadPostController to navigation controller
        let controller = UploadPostController(image: self.selectedImage!)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        //configure navigation bar title
        navigationItem.title = "Add Photo"
        
        //configure navigation bar buttons
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOption())
        
        //fetch images on background thread
        DispatchQueue.global(qos: .background).async {
            // enumerate objects
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                // request image representation for specified asset
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, info) in
                    guard let image = image else { return }
                    
                    //appending data to our datasource
                    self.images.append(image)
                    self.assets.append(asset)
                    
                    //set first image as selected image
                    if self.selectedImageThumbnail == nil {
                        
                        self.selectedImageThumbnail = image
                        
                    }
                    
                    //reload collection view once count has completed
                    if count == allPhotos.count - 1 {
                        //reload collection view on main thread
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func getAssetFetchOption() -> PHFetchOptions {
        let options = PHFetchOptions()
        //fetch limit
        options.fetchLimit = 30
        
        // sort photos by date
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        //set sort descriptor for options
        options.sortDescriptors = [sortDescriptor]
        
        return options
    }
    
    
    //MARK: - CollectionViewDataSource UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SelectPhotoHeader
        
        if let selectedImageThumbnail = self.selectedImageThumbnail {
            
            if let index = self.images.firstIndex(of: selectedImageThumbnail) {
                
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 1000, height: 1000)
                
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    guard let image = image else { return }
                    header.selectedImageView.image = image
                    self.selectedImage = image
                }
            }
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SelectPhotoCell
        cell.galleryImageView.image = images[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImageThumbnail = images[indexPath.row]
        
        self.collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
}


//MARK: - Delegaate UICollectionViewDelegateFlowLayout

extension SelectImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3)/4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
