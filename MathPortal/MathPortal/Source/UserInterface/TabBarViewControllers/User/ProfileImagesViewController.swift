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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    weak var delegate: ProfileImagesViewControllerDelegate?
    
    @IBOutlet var profileImagesCollectionView: UICollectionView!
    
    let defaultImages = [R.image.einsteinBlack(), R.image.einsteinColor(), R.image.einsteinWhite(), R.image.girlBlack(), R.image.girlColor(), R.image.girlWhite(), R.image.boyBlack(), R.image.boyColor(), R.image.boyWhite()]
 
}
extension ProfileImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileImagesCollectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.imageCell, for: indexPath)!
        if let image = defaultImages[indexPath.item] {
            cell.setImage(image)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = defaultImages[indexPath.item] else { return }
        delegate?.profileImagesViewController(sender: self, didChoseImage: image)
    }
}
