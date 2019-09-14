//
//  OnboardingBasicInfoViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 01/09/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class OnboardingBasicInfoViewController: BaseViewController {
    
    @IBOutlet private var birthdayLabel: UILabel?
    
    @IBOutlet private var datePicker: UIDatePicker?
    
    private var selectedDate: Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdayLabel?.textColor = UIColor.white
        datePicker?.setValue(UIColor.mathLightGrey, forKey: "textColor")
        datePicker?.addTarget(self, action: #selector(getSelectedDate), for: .valueChanged)
        selectedDate = datePicker?.date

    }
    
    @objc private func getSelectedDate(sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        updateAndSaveUser()
    }
    
    private func updateAndSaveUser() {
        guard let user = User.current, let date = selectedDate else { return }
        user.birthDate = date
        
        let loadingSpinner = LoadingViewController.activateIndicator(text: "Loading")
        self.present(loadingSpinner, animated: false, completion: nil)
            
        user.save { (succcess, error) in
            loadingSpinner.dismissLoadingScreen() {
                if succcess {
                    self.goToMainMenuViewController()
                } else {
                    if let description = error?.localizedDescription {
                        ErrorMessage.displayErrorMessage(controller: self, message: description)
                    } else {
                        ErrorMessage.displayErrorMessage(controller: self, message: "Unknown error occurred")
                    }
                }
            }
        }
    }
    
    func goToMainMenuViewController() {
        let controller = R.storyboard.main.tabBarViewController()!
        self.present(controller, animated: true)
    }
}

