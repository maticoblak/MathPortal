//
//  ViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 11/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Rswift


class ViewController: UIViewController {
    
    
    @IBOutlet private var introText: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.introText?.alpha = 0
        fadeInFadeOutAnimation()
    }
    
    func goToLogInViewController() {
        
        let controller = R.storyboard.main.logInViewController()!
        let navigationController = UINavigationController.init(rootViewController: controller)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func fadeInFadeOutAnimation() {
        UIView.animateKeyframes(withDuration: 5, delay: 0, options: .calculationModeCubicPaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                self.introText?.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 1.0) {
                self.introText?.alpha = 0
            }
        }) { _ in
            self.goToLogInViewController()
        }
    }


}

