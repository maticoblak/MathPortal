//
//  MainMenuViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 10/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {

    
    @IBOutlet private var contentController: ContentControllerView?
    
    @IBOutlet private var firstButton: TabBarButton?
    @IBOutlet private var secondButton: TabBarButton?
    @IBOutlet private var thirdButton: TabBarButton?
    @IBOutlet private var fourthButton: TabBarButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstButton?.addTarget(self, action: #selector(firstButtonPressed), for: .touchUpInside)
        secondButton?.addTarget(self, action: #selector(secondButtonPressed), for: .touchUpInside)
        thirdButton?.addTarget(self, action: #selector(thirdButtonPressed), for: .touchUpInside)
        fourthButton?.addTarget(self, action: #selector(fourthButtonPressed), for: .touchUpInside)
        navigateTo(tab: .secondTab)
    }
    
    private var allButtons: [TabBarButton?] { return [firstButton, secondButton, thirdButton, fourthButton] }
    
    var currentTab: Tab = .firstTab {
        didSet {
            switch currentTab {
            case .firstTab: allButtons.forEach { $0?.selected = $0 === firstButton }
            case .secondTab: allButtons.forEach { $0?.selected = $0 === secondButton }
            case .thirdTab: allButtons.forEach { $0?.selected = $0 === thirdButton }
            case .fourthTab: allButtons.forEach { $0?.selected = $0 === fourthButton }
            }
        }
    }
    
    lazy private var firstController: (controller: LoggedInViewController, navigationController: UINavigationController) = {
        let controller = LoggedInViewController.createFromStoryboard()
        let navigationController = UINavigationController(rootViewController: controller)
        return (controller, navigationController)
    }()
    
    lazy private var secondController: (controller: UserViewController, navigationController: UINavigationController) = {
        let controller = UserViewController.createFromStoryboard()
        let navigationController = UINavigationController(rootViewController: controller)
        return (controller, navigationController)
    }()
    
    lazy private var thirdController: (controller: SolvedTasksViewController, navigationController: UINavigationController) = {
        let controller = SolvedTasksViewController.createFromStoryboard()
        let navigationController = UINavigationController(rootViewController: controller)
        return (controller, navigationController)
    }()
    
    lazy private var fourthController: (controller: BrowseTasksViewController, navigationController: UINavigationController) = {
        let controller = BrowseTasksViewController.createFromStoryboard()
        let navigationController = UINavigationController(rootViewController: controller)
        return (controller, navigationController)
    }()
    
    @objc private func firstButtonPressed() {
        if currentTab == .firstTab {
            firstController.navigationController.popToRootViewController(animated: true)
        } else {
            navigateTo(tab: .firstTab)
        }
    }
    
    @objc private func secondButtonPressed() {
        if currentTab == .secondTab {
            secondController.navigationController.popToRootViewController(animated: true)
        } else {
            navigateTo(tab: .secondTab)
        }
    }
    @objc private func thirdButtonPressed() {
        if currentTab == .thirdTab {
            thirdController.navigationController.popToRootViewController(animated: true)
        } else {
            navigateTo(tab: .thirdTab)
        }
    }
    
    @objc private func fourthButtonPressed() {
        if currentTab == .fourthTab {
            fourthController.navigationController.popToRootViewController(animated: true)
        } else {
            navigateTo(tab: .fourthTab)
        }
    }
    
    func navigateTo(tab: Tab) {
        switch tab {
        case .firstTab:
            contentController?.setViewController(controller: firstController.navigationController, animationStyle: .fade)
        case .secondTab:
            contentController?.setViewController(controller: secondController.navigationController, animationStyle:  .fade)
        case .thirdTab:
            contentController?.setViewController(controller: thirdController.navigationController, animationStyle: .fade)
        case .fourthTab:
            contentController?.setViewController(controller: fourthController.navigationController, animationStyle: .fade)
        }
        currentTab = tab
    }
    
}

extension TabBarViewController {
    enum Tab {
        case firstTab
        case secondTab
        case thirdTab
        case fourthTab
    }
}
