//
//  OnboardingRoleViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 07/09/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class OnboardingRoleViewController: BaseViewController {
    
    enum State {
        case selected
        case unselected
    }

    @IBOutlet private var teacherButtonView: UIView?
    @IBOutlet private var teacherButton: UIButton?
    @IBOutlet private var teacherShadowView: UIView!
    
    @IBOutlet private var studentButtonView: UIView?
    @IBOutlet private var studentButton: UIButton?
    @IBOutlet private var studentShadowView: UIView!
    
    @IBOutlet private var einsteinButtonView: UIView!
    @IBOutlet private var einsteinButton: UIButton!
    @IBOutlet private var einsteinShadowView: UIView!
    
    @IBOutlet private var nextButton: CustomButton?
    
    private var selectedRole: [User.Role]? {
        didSet {
            nextButton?.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setup()

        // Do any additional setup after loading the view.
    }
    
    private var teacherSelected: Bool = false {
        didSet {
            teacherShadowView.isHidden = teacherSelected
        }
    }
    private var studntSelected: Bool = false {
        didSet {
            studentShadowView.isHidden = studntSelected
        }
    }
    
    private var einsteinSelected: Bool = false {
        didSet {
            einsteinShadowView.isHidden = einsteinSelected
        }
    }

    private func setup() {
        nextButton?.isUserInteractionEnabled = false
        
        teacherButtonView?.backgroundColor = UIColor.mathDarkGrey
        studentButtonView?.backgroundColor = UIColor.mathDarkGrey
        einsteinButtonView?.backgroundColor = UIColor.mathDarkGrey
        
        teacherShadowView.backgroundColor = UIColor.mathLightGrey
        studentShadowView.backgroundColor = UIColor.mathLightGrey
        einsteinShadowView.backgroundColor = UIColor.mathLightGrey
    }
    
    @IBAction private func teacherSelected(_ sender: Any) {
        teacherSelected = true
        studntSelected = false
        einsteinSelected = false
        
        selectedRole = [User.Role.teacher]
    }
    @IBAction private func studentSelected(_ sender: Any) {
        teacherSelected = false
        studntSelected = true
        einsteinSelected = false
        
        selectedRole = [User.Role.student]
    }
    @IBAction private func einsteinSelected(_ sender: Any) {
        teacherSelected = false
        studntSelected = false
        einsteinSelected = true
        
        selectedRole = [User.Role.teacher, User.Role.student]
    }
    
   
    @IBAction func nextButtonPressed(_ sender: Any) {
        updateUserAndGoToNextScreen()
    }
    
    private func updateUserAndGoToNextScreen() {
        if let user = User.current, let roles = selectedRole {
            user.role = roles
            let controller = R.storyboard.onboarding.onboardingBasicInfoViewController()!
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
