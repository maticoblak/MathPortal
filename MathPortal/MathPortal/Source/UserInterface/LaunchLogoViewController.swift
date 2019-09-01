//
//  LaunchLogoViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 11/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class LaunchLogoViewController: UIViewController {
    
    @IBOutlet private var introText: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.introText?.alpha = 0
        fadeInFadeOutAnimation()
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
            self.goToFirstScreen()
        }
    }
    
    private func goToFirstScreen() {
        if let _ = PFUser.current() {
            goToTabBarViewController()
        } else {
            goToLogInOrRegisterViewController()
        }
    }
    
    private func goToTabBarViewController() {
        let controller = R.storyboard.main.tabBarViewController()!
        controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(controller, animated: true)
    }

    private func goToLogInViewController() {
        
        let controller = R.storyboard.main.logInViewController()!
        let navigationController = UINavigationController.init(rootViewController: controller)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func goToLogInOrRegisterViewController() {
        
        let controller = R.storyboard.main.loginOrRegisterViewController()!
        let navigationController = UINavigationController.init(rootViewController: controller)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(navigationController, animated: true, completion: nil)
    }
}

