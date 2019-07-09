//
//  EditUserViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 15/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController {
    
    
    @IBOutlet private var editProfileImageButton: UIButton?
    @IBOutlet private var profileImage: UIImageView?
    @IBOutlet private var usernameTextField: UITextField?
    @IBOutlet private var emailTextField: UITextField?
    @IBOutlet private var teacherButton: UIButton?
    @IBOutlet private var ageDayTextField: UITextField?
    @IBOutlet private var ageMonthTextField: UITextField?
    @IBOutlet private var ageYearTextField: UITextField?
    //@IBOutlet private var ageTextField: UITextField?
    @IBOutlet private var studentButton: UIButton?
    
    
    @IBOutlet private var saveButton: UIButton?
    @IBOutlet private var deleteAccountButton: UIButton?
    
    // TODO: add birthdate logic
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboard()
        refresh()
    }
    
    private func refresh() {
        usernameTextField?.placeholder = user.username
        emailTextField?.placeholder = user.email
        profileImage?.image = user.profileImage
        studentRoleSelected = user.role.contains(.student)
        teacherRoleSelected = user.role.contains(.teacher)
        ageDayTextField?.placeholder = DateTools.getStringComponent(.day, fromDate: user.birthDate) ?? "dd"
        ageMonthTextField?.placeholder = DateTools.getStringComponent(.month, fromDate: user.birthDate) ?? "mm"
        ageYearTextField?.placeholder = DateTools.getStringComponent(.year, fromDate: user.birthDate) ?? "yyyy"
        
    }
    private func setUpKeyboard() {
        usernameTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        emailTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    private var studentRoleSelected: Bool = false {
        didSet {
            studentButton?.backgroundColor = studentRoleSelected ? UIColor.lightGray : UIColor.clear
        }
    }
    
    private var teacherRoleSelected: Bool = false {
        didSet {
            teacherButton?.backgroundColor = teacherRoleSelected ? UIColor.lightGray : UIColor.clear
        }
    }
    

    @IBAction private func editProfileImage(_ sender: Any) {
        // TODO: Go to new screen and select a predefined image or image from your library
    }
    @IBAction private func selectTeacher(_ sender: Any) {
        teacherRoleSelected = !teacherRoleSelected
    }
    
    
    @IBAction private func selectStudent(_ sender: Any) {
        studentRoleSelected = !studentRoleSelected
    }
    @IBAction private func saveChanges(_ sender: Any) {
        validateAndSave()

    }
    @IBAction private func deleteAccount(_ sender: Any) {
        // TODO: have a delete account option
    }
    
    
    
    func save() {
        let loadingSpinner = LoadingViewController.activateIndicator(text: "Saving")
        self.present(loadingSpinner, animated: false, completion: nil)
        self.user.save { (success, error) in
            loadingSpinner.dismissLoadingScreen() {
                if success == false  {
                    if let description = error?.localizedDescription {
                        ErrorMessage.displayErrorMessage(controller: self, message: description)
                    } else {
                        ErrorMessage.displayErrorMessage(controller: self, message: "Unknown error occurred")
                    }
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func validateAndSave() {
        var fields: [FieldValidator.Field] = [FieldValidator.Field] ()
        if emailTextField?.text?.isEmpty == false { fields.append(.email) }
        if usernameTextField?.text?.isEmpty == false { fields.append(.username)}
        if ageDayTextField?.text?.isEmpty == false { fields.append(.age)}
        
        FieldValidator.init(validate: fields, username: usernameTextField?.text, email: emailTextField?.text).validate { result in
            print(result)
            switch result {
            case .OK:
                self.updateUser()
                self.save()
                break
            case .usernameAlreadyTaken, .ageInvalid, .emailAlreadyTaken, .emailInvalid:
                ErrorMessage.displayErrorMessage(controller: self, message: result.error)
                break
            }
        }
    }
    
    func updateUser() {
        if let textCount = self.usernameTextField?.text?.count, textCount > 0 { self.user.username = self.usernameTextField?.text } else { self.user.username = self.usernameTextField?.placeholder}
        if let textCount = self.emailTextField?.text?.count, textCount > 0 { self.user.email = self.emailTextField?.text } else { self.user.email = self.emailTextField?.placeholder}
        if ageDayTextField?.text?.isEmpty == false , ageYearTextField?.text?.isEmpty == false, ageMonthTextField?.text?.isEmpty == false {
            user.birthDate = DateTools.getDateFromStringComponents(day: ageDayTextField?.text, month: ageMonthTextField?.text, year: ageYearTextField?.text)
            user.age = DateTools.getAgeFromDate(date: user.birthDate)
        }
        var newRoles: [User.Role] {
            var roles = [User.Role]()
            if teacherRoleSelected { roles.append(.teacher) }
            if studentRoleSelected { roles.append(.student) }
            if roles.isEmpty { roles.append(.undefined) }
            return roles
        }
        user.role = newRoles
        
    }
}
