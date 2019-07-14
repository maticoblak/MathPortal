//
//  ProfileImagesCollectionViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/07/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class ProfileImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var profileImageView: UIImageView?
    
    func setImage(_ image: UIImage) {
        guard let profileImageView = profileImageView else { return }
        profileImageView.image = image
    }
}
