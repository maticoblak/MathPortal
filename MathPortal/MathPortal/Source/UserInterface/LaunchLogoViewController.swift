//
//  LaunchLogoViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 11/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class LaunchLogoViewController: BaseViewController {
    
    static private(set) var current: LaunchLogoViewController?
    
    @IBOutlet private var logoView: UIView?
    @IBOutlet private var topConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LaunchLogoViewController.current = self
        self.logoView?.alpha = 0
        topConstraint?.isActive = false
        logoView?.center = self.view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fadeInAndMoveToTopAnimation()
    }
    
    func dismissToRoot() {
        while presentedViewController != nil {
            dismiss(animated: false, completion: nil)
        }
    }
    
    func fadeInAndMoveToTopAnimation() {
        
        UIView.animateKeyframes(withDuration: 5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.logoView?.alpha = 1
                
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.topConstraint?.isActive = true
                self.view.layoutIfNeeded()
            }
        }) { _ in
            self.goToFirstScreen()
        }
    }
    
    private func goToFirstScreen() {
        if let _ = User.current {
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
    
    private func goToLogInOrRegisterViewController() {
        let controller = R.storyboard.main.loginOrRegisterViewController()!
        let navigationController = UINavigationController.init(rootViewController: controller)
        navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // NOTE: For testing
    private func testNavigation() {
        let controller = R.storyboard.onboarding.onboardingRoleViewController()!
        let navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true, completion: nil)
    }
}

