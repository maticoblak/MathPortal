//
//  ErrorMessage.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class ErrorMessage {

    static func displayErrorMessage(controller: UIViewController, message: String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = controller.view
            presenter.sourceRect = controller.view.bounds
        }
        controller.present(alertView, animated: true, completion:nil)
    }
    
    static func displayConformationMessage(controller: UIViewController, message: String, onYes: @escaping ((UIAlertAction) -> Void)) {
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: onYes)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertView.addAction(confirmAction)
        alertView.addAction(cancelAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = controller.view
            presenter.sourceRect = controller.view.bounds
        }
        controller.present(alertView, animated: true, completion:nil)
    }
}
