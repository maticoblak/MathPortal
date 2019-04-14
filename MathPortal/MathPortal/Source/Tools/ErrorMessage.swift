//
//  ErrorMessage.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class ErrorMessage {

    static func displayErrorMessage(controller: UIViewController, message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = controller.view
            presenter.sourceRect = controller.view.bounds
        }
        controller.present(alertView, animated: true, completion:nil)
    }
}
