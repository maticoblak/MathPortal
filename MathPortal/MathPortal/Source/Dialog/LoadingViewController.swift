//
//  LoadingViewController.swift
//  PetrasWorkspace
//
//  Created by Petra Čačkov on 09/03/2019.
//  Copyright © 2019 Petra. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet private var blurView: UIVisualEffectView?
    
    @IBOutlet private var loadingView: UIView?
    @IBOutlet private var stackView: UIStackView?
    
    @IBOutlet private var indicator: UIActivityIndicatorView?
    @IBOutlet private var loadingMessage: UILabel?
    
    @IBOutlet private var indicatorView: UIView?
    @IBOutlet private var messageView: UIView?
    
    private var overlayWindow: UIWindow?
    
    var message: String? {
        didSet {
            setup()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        blurView?.effect = UIVisualEffect()
        self.loadingView?.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView?.effect = UIBlurEffect(style: .dark)
        })
        UIView.animate(withDuration: 0.3, delay: 0.15, animations: {
            self.loadingView?.alpha = 1.0
        })
    }
    private func setup() {
        loadingMessage?.text = message
        if let loadngViewHeight = loadingView?.frame.height {
            loadingView?.layer.cornerRadius = (loadngViewHeight)/3
        }
        loadingView?.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        indicator?.startAnimating()
    }
    
    private func dismissLoadingScreen(completion : @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: false, completion: nil)
            UIApplication.shared.endIgnoringInteractionEvents()
            completion()
        }
    }
    
}

extension LoadingViewController {
    private static func activateIndicator(text: String) -> LoadingViewController {
        let myLoadingView = UIStoryboard(name: "Loading", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        UIApplication.shared.beginIgnoringInteractionEvents()
        myLoadingView.message = text
        myLoadingView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myLoadingView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        return myLoadingView
    }
    
    static func showInNewWindow(text: String = "Deleting") -> LoadingViewController {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .alert
        let controller: LoadingViewController = {
            let controller = R.storyboard.loading.loadingViewController()!
            controller.message = text
            controller.overlayWindow = window
            return controller
        }()
        window.rootViewController = controller
        window.makeKeyAndVisible()
        return controller
    }
    
    func dismissFromCurrentWindow(completion : (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView?.alpha = 0.0
            self.blurView?.effect = UIVisualEffect()
        }) { _ in
            self.indicator?.stopAnimating()
            self.overlayWindow?.isHidden = true
            self.overlayWindow?.removeFromSuperview()
            self.overlayWindow = nil
            completion?()
        }
        
    }
    
}

