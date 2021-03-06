//
//  EditUserViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 15/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit


class EditUserViewController: BaseViewController {
    
    
    @IBOutlet private var editProfileImageButton: UIButton?
    @IBOutlet private var profileImage: UIImageView?
    @IBOutlet private var profileImageFrameView: UIView?
    @IBOutlet private var closeButton: UIButton?
    
    @IBOutlet private var usernameTextField: CustomTextField?
    @IBOutlet private var emailTextField: CustomTextField?
    @IBOutlet private var ageDayTextField: CustomTextField?
    @IBOutlet private var ageMonthTextField: CustomTextField?
    @IBOutlet private var ageYearTextField: CustomTextField?
    @IBOutlet private var studentButton: UIButton?
    @IBOutlet private var teacherButton: UIButton?
    
    
    @IBOutlet private var saveButton: CustomButton?
    @IBOutlet private var deleteAccountButton: CustomButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboard()
        setupView()
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func refresh() {
        
        usernameTextField?.placeholder = User.current?.username
        emailTextField?.placeholder = User.current?.email
        profileImage?.image = User.current?.profileImage
        studentRoleSelected = User.current?.role.contains(.student) ?? false
        teacherRoleSelected = User.current?.role.contains(.teacher)  ?? false
        ageDayTextField?.placeholder = DateTools.getStringComponent(.day, fromDate: User.current?.birthDate) ?? "dd"
        ageMonthTextField?.placeholder = DateTools.getStringComponent(.month, fromDate: User.current?.birthDate) ?? "mm"
        ageYearTextField?.placeholder = DateTools.getStringComponent(.year, fromDate: User.current?.birthDate) ?? "yyyy"
        
    }
    
    private func setupView() {
        profileImageFrameView?.layer.cornerRadius = (profileImageFrameView?.bounds.height ?? 0)/2
        profileImageFrameView?.backgroundColor = Color.darkGrey
        editProfileImageButton?.imageView?.tintColor = Color.lightGrey
        profileImage?.layer.cornerRadius = (profileImage?.bounds.height ?? 0)/2
        
        saveButton?.color = Color.lightGrey
        saveButton?.backgroundColor = Color.darkGrey
        
        studentButton?.layer.cornerRadius = 10
        teacherButton?.layer.cornerRadius = 10
        
        closeButton?.tintColor = Color.darkGrey
        
    }
    
    private func setUpKeyboard() {
        usernameTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        emailTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction private func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    private var studentRoleSelected: Bool = false {
        didSet {
            studentButton?.backgroundColor = studentRoleSelected ? Color.orange : Color.darkGrey
            studentButton?.setTitleColor(studentRoleSelected ? Color.darkGrey : Color.lightGrey, for: .normal)
        }
    }
    
    private var teacherRoleSelected: Bool = false {
        didSet {
            teacherButton?.backgroundColor = teacherRoleSelected ? Color.orange : Color.darkGrey
            teacherButton?.setTitleColor(teacherRoleSelected ? Color.darkGrey : Color.lightGrey, for: .normal)
        }
    }
    

    @IBAction private func editProfileImage(_ sender: Any) {
        let controller = R.storyboard.userViewController.profileImagesViewController()!
        controller.delegate = self
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(controller, animated: true)
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
        ErrorMessage.displayConformationMessage(controller: self, message: "Are you sure you want to delete the account", onYes: delete)
    }
    
    
    func delete(action: UIAlertAction) {
        let loadingSpinner = LoadingViewController.showInNewWindow(text: "Deleting")
        User.current?.delete { (success, error) in
            loadingSpinner.dismissFromCurrentWindow {
                if success {
                    User.logOut()
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
    
    func save() {
        let loadingSpinner = LoadingViewController.showInNewWindow(text: "Saving")
        
        User.current?.save { (success, error) in
            loadingSpinner.dismissFromCurrentWindow() {
                if success == false  {
                    if let description = error?.localizedDescription {
                        ErrorMessage.displayErrorMessage(controller: self, message: description)
                    } else {
                        ErrorMessage.displayErrorMessage(controller: self, message: "Unknown error occurred")
                    }
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func validateAndSave() {
        // TODO: validate whole date
        
        var fields: [FieldValidator.Field] = [FieldValidator.Field] ()
        if emailTextField?.text?.isEmpty == false { fields.append(.email) }
        if usernameTextField?.text?.isEmpty == false { fields.append(.username)}
        if ageDayTextField?.text?.isEmpty == false { fields.append(.age)}
        
        FieldValidator.init(validate: fields, username: usernameTextField?.text, email: emailTextField?.text).validate { result in
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
        guard let user = User.current else { return }
        if let textCount = self.usernameTextField?.text?.count, textCount > 0 { user.username = self.usernameTextField?.text } else { user.username = self.usernameTextField?.placeholder}
        if let textCount = self.emailTextField?.text?.count, textCount > 0 { user.email = self.emailTextField?.text } else { user.email = self.emailTextField?.placeholder}
        if ageDayTextField?.text?.isEmpty == false , ageYearTextField?.text?.isEmpty == false, ageMonthTextField?.text?.isEmpty == false {
            user.birthDate = DateTools.getDateFromStringComponents(day: ageDayTextField?.text, month: ageMonthTextField?.text, year: ageYearTextField?.text)
        }
        var newRoles: [User.Role] {
            var roles = [User.Role]()
            if teacherRoleSelected { roles.append(.teacher) }
            if studentRoleSelected { roles.append(.student) }
            if roles.isEmpty { roles.append(.undefined) }
            return roles
        }
        user.role = newRoles
        user.profileImage = profileImage?.image
    }
}

extension EditUserViewController: ProfileImagesViewControllerDelegate {
    func profileImagesViewController(sender: ProfileImagesViewController, didChoseImage image: UIImage) {
        profileImage?.image = image
        profileImage?.setNeedsDisplay()
    }
    
    
}
