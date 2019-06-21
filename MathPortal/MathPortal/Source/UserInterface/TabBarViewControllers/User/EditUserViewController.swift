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
    @IBOutlet private var ageTextField: UITextField?
    @IBOutlet private var studentButton: UIButton?
    
    @IBOutlet private var saveButton: UIButton?
    @IBOutlet private var deleteAccountButton: UIButton?
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboard()
        refresh()
    }
    
    private func refresh() {
        usernameTextField?.placeholder = user.username
        emailTextField?.placeholder = user.email
        ageTextField?.placeholder = String(describing: user.age)
        profileImage?.image = user.profileImage
        studentRoleSelected = user.role.contains(.student) ? true : false
        teacherRoleSelected = user.role.contains(.teacher) ? true : false
    }
    private func setUpKeyboard() {
        usernameTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        emailTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        ageTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
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
    
//    var username: String? {
//        didSet {
//            if username?.isEmpty == false  {
//                user.username = username
//            } else {
//                user.username = usernameTextField?.placeholder
//            }
//        }
//    }

    @IBAction func editProfileImage(_ sender: Any) {
        // TODO: Go to new screen and select a predefined image or image from your library
    }
    @IBAction func selectTeacher(_ sender: Any) {
        teacherRoleSelected = !teacherRoleSelected
    }
    
//    class FieldValidator {
//        let username: String
//
//        init(username: String) {
//            self.username = username
//        }
//        
//        enum Result {
//            case OK
//            case usernameAlreadyTaken
//            case emailInvalid
//        }
//
//        private var nameValid: Bool? { didSet { checkValid() } }
//        private var emailValid: Bool? { didSet { checkValid() } }
//        private var completion: ((_ result: Result) -> Void)?
//
//        private var selfReference: FieldValidator?
//
//        func validate(_ completion: @escaping (_ result: Result) -> Void) {
//            self.completion = completion
//            selfReference = self
//
//            User.usernameIsAlreadyTaken(username: username) { taken in
//                self.nameValid = !taken
//            }
//            UIView.animate(withDuration: 10) {
//                print("ads")
//            }
//        }
//
//        private func checkValid() {
//            guard let nameValid = nameValid else { return }
//            guard let emailValid = emailValid else { return }
//
//            if !nameValid { completion?(.usernameAlreadyTaken) }
//            if !emailValid { completion?(.emailInvalid) }
//            else { completion?(.OK) }
//
//            completion = nil
//            selfReference = nil
//        }
//
//    }
    
//    func doMagic() {
//        FieldValidator(username: "dsf").validate { result in
//            switch result {
//
//            case .OK:
//                print("hfgf")
//            case .usernameAlreadyTaken:
//                print("hfgf")
//            case .emailInvalid:
//                print("hfgf")
//            @unknown default:
//                print("hfgf")
//            }
//        }
//    }
    
    
    @IBAction func selectStudent(_ sender: Any) {
        studentRoleSelected = !studentRoleSelected
    }
    @IBAction func saveChanges(_ sender: Any) {
        validateAndSave()

    }
    @IBAction func deleteAccount(_ sender: Any) {
        
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
        FieldValidator.init(username: usernameTextField?.text, email: emailTextField?.text, age: ageTextField?.text).validate { result in
            print(result)
            switch result {
            case .OK:
                if let textCount = self.usernameTextField?.text?.count, textCount > 0 { self.user.username = self.usernameTextField?.text }
                if let textCount = self.emailTextField?.text?.count, textCount > 0 { self.user.email = self.emailTextField?.text }
                if let text = self.ageTextField?.text, text.count > 0 { self.user.age = Int(text) }
                self.save()
                break
            case .usernameAlreadyTaken:
                ErrorMessage.displayErrorMessage(controller: self, message: "Username is alreadi taken")
                break
            case .emailInvalid:
                ErrorMessage.displayErrorMessage(controller: self, message: "Email is invalid")
                break
            case .ageInvalid:
                ErrorMessage.displayErrorMessage(controller: self, message: "Age format is wrong")
                break
            case .emailAlreadyTaken:
                ErrorMessage.displayErrorMessage(controller: self, message: "Email is already taken")
                break
            }
        }
    }
    
//    var userSuccessfulyUpdated: Bool = false
//    private func updateUser(compleation: @escaping () -> Void) {
//
//        FieldValidator.init(username: usernameTextField?.text).validate { result in
//            compleation()
//            switch result {
//
//            case .OK:
//                self.user.username = self.usernameTextField?.text
//            case .usernameAlreadyTaken:
//                ErrorMessage.displayErrorMessage(controller: self, message: "Username is alreadi taken")
//                break
//            case .emailInvalid:
//                ErrorMessage.displayErrorMessage(controller: self, message: "Email is already teken")
//                break
//            @unknown default:
//                break
//            }
    
//        }
//
//
//        //if let newUsername = usernameTextField?.text { username = usernameTextField?.text }
//       // if let newEmail = emailTextField?.text?.isEmpty, newEmail == false { user.email = emailTextField?.text }
//        if let newAge = ageTextField?.text, newAge.isEmpty == false {
//            guard let ageAsInt = Int(newAge) else {
//                ErrorMessage.displayErrorMessage(controller: self, message: "Age format is wrong")
//                userSuccessfulyUpdated = false
//                return
//            }
//            user.age =  ageAsInt
//        }
//        var newRoles: [User.Role] {
//            var roles = [User.Role]()
//            if teacherRoleSelected { roles.append(.teacher) }
//            if studentRoleSelected { roles.append(.student) }
//            if roles.isEmpty { roles.append(.undefined) }
//            return roles
//        }
//        user.role = newRoles
//        userSuccessfulyUpdated = true
//    }
}
