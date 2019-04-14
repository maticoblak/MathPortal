//
//  LoggedInViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class LoggedInViewController: UIViewController {

    @IBOutlet private var logOutButton: UIButton?
    
    @IBAction func logOut(_ sender: Any) {
        logoutOfApp()
    }
    
    func logoutOfApp() {
        let loadingSpinner = LoadingViewController.activateIndicator(text: "Loading")
        self.present(loadingSpinner, animated: false, completion: nil)
        
        PFUser.logOutInBackground { (error: Error?) in
            loadingSpinner.dismissLoadingScreen()
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                if let descrip = error?.localizedDescription{
                    ErrorMessage.displayErrorMessage(controller: self, message: descrip)
                } else {
                    ErrorMessage.displayErrorMessage(controller: self, message: "error logging out")
                }
            }
        }
    }

}
