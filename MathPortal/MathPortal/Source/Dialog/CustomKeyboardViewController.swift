//
//  CustomKeyboardViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 19/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class CustomKeyboardViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView?
    
    let keyboardButtons: [KeyboardButtons] = [.one,.two,.three,.four,.plus,.minus]
    
    enum KeyboardButtons {
        case one
        case two
        case three
        case four
        case plus
        case minus
        
        var string: String {
            switch self {
            case .one: return "1"
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            case .plus: return "+"
            case .minus: return "-"
            }
        }
    }

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
    
}
