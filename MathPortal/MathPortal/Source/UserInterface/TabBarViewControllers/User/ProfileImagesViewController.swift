//
//  ProfileImagesViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/07/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

protocol ProfileImagesViewControllerDelegate: class {
    func profileImagesViewController(sender: ProfileImagesViewController, didChoseImage image: UIImage)
}

class ProfileImagesViewController: UIViewController {

    weak var delegate: ProfileImagesViewControllerDelegate?
    
    @IBOutlet private var profileImagesCollectionView: UICollectionView!
    
    private var customImage: UIImage?
    private var imagePicker: UIImagePickerController = UIImagePickerController()
    private let defaultImages = [UIImage(), R.image.einsteinBlack(), R.image.einsteinColor(), R.image.einsteinWhite(), R.image.girlBlack(), R.image.girlColor(), R.image.girlWhite(), R.image.boyBlack(), R.image.boyColor(), R.image.boyWhite()]
    
    func openImageGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated:  true)
        }
    }
 
}
extension ProfileImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileImagesCollectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.imageCell, for: indexPath)!
        if let image = defaultImages[indexPath.item] {
            cell.setImage(image)
            if indexPath.row == 0 { cell.backgroundColor = .gray }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = defaultImages[indexPath.item] else { return }
        if indexPath.row == 0 {
            openImageGallery()
        } else {
            delegate?.profileImagesViewController(sender: self, didChoseImage: image)
        }
        
    }
}

extension ProfileImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /*
        TODO:
        - Images are to large and eather take too long or don't save
        - Add edit image before displaying it in the profile frame
         */
        if let image = info[.originalImage] as? UIImage {
            customImage = image
            delegate?.profileImagesViewController(sender: self, didChoseImage: image)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
