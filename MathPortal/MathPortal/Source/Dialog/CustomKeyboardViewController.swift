//
//  CustomKeyboardViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 19/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
protocol CustomKeyboardViewControllerDelegate: class {
    func customKeyboardViewController(sender: CustomKeyboardViewController, didChoseKey key: Button.ButtonType)
}
class CustomKeyboardViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView?
    
    weak var delegate: CustomKeyboardViewControllerDelegate?
    
    let keyboardButtons: [Button.ButtonType] = Button.ButtonType.integers + [.plus, .minus, .back, .forward, .delete, .brackets, .done, .levelIn, .levelOut, .fraction]
}

extension CustomKeyboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyboardButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.keyboardCell, for: indexPath)!
        cell.setKey(key: keyboardButtons[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.customKeyboardViewController(sender: self, didChoseKey: keyboardButtons[indexPath.row])
    }
}
