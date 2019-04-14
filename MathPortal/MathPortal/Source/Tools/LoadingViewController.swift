//
//  LoadingViewController.swift
//  PetrasWorkspace
//
//  Created by Petra Čačkov on 09/03/2019.
//  Copyright © 2019 Petra. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    
    @IBOutlet private var loadingView: UIView?
    @IBOutlet private var stackView: UIStackView?
    
    @IBOutlet private var indicator: UIActivityIndicatorView?
    @IBOutlet private var loadingMessage: UILabel?
    
    @IBOutlet private var indicatorView: UIView?
    @IBOutlet private var messageView: UIView?
    
    var message: String? {
        didSet {
            setup()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        indicatorView?.backgroundColor = UIColor.clear
        loadingMessage?.text = message
        messageView?.backgroundColor = UIColor.clear
        if let loadngViewHeight = loadingView?.frame.height {
            loadingView?.layer.cornerRadius = (loadngViewHeight)/3
        }
        loadingView?.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        indicator?.startAnimating()
    }
    
    func dismissLoadingScreen() {
        self.dismiss(animated: false, completion: nil)
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

extension LoadingViewController {
    static func activateIndicator(text: String) -> LoadingViewController {
        let myLoadingView = UIStoryboard(name: "Loading", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        UIApplication.shared.beginIgnoringInteractionEvents()
        myLoadingView.message = text
        myLoadingView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myLoadingView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        return myLoadingView
    }
    
}

