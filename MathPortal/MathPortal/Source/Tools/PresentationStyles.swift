//
//  PresentationStyles.swift
//  MathPortal
//
//  Created by Petra Čačkov on 06/10/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentAsFullScreen(_ viewControllerToPresent: UIViewController, animated: Bool, transitionStyle: UIModalTransitionStyle? = nil, completion: (() -> Void)? = nil ) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        if let transitionStyle = transitionStyle {
            viewControllerToPresent.modalTransitionStyle = transitionStyle
        }
        self.present(viewControllerToPresent, animated: animated, completion: completion)
    }
}
