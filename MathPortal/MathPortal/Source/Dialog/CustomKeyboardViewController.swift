//
//  CustomKeyboardViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 19/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
protocol CustomKeyboardViewControllerDelegate: class {
    func customKeyboardViewController(sender: CustomKeyboardViewController, didChoseKey key: KeyboardButtons)
}
class CustomKeyboardViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView?
    
    weak var delegate: CustomKeyboardViewControllerDelegate?
    
    let keyboardButtons: [KeyboardButtons] = [.one,.two,.three,.four,.plus,.minus,.levelDownArrow,.levelUpArrow, .back, .front, .delete, .leftBracket, .rightBracket]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension CustomKeyboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyboardButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.keyboardCell, for: indexPath) as! CustomKeyboardCollectionViewCell
        cell.setKey(name: keyboardButtons[indexPath.row].string)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(keyboardButtons[indexPath.row].string)
        delegate?.customKeyboardViewController(sender: self, didChoseKey: keyboardButtons[indexPath.row])
    }
    
}
