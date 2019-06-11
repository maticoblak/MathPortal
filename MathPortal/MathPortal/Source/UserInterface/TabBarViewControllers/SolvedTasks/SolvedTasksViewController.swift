//
//  SolvedTasksViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 11/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class SolvedTasksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Appearence.setUpNavigationController(controller: self)
    }
    
    static func createFromStoryboard() -> SolvedTasksViewController {
        return UIStoryboard(name: "SolvedTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "SolvedTasksViewController") as! SolvedTasksViewController
    }

}
