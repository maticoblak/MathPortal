//
//  MainMenuViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 10/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class TabBarViewController: BaseViewController {

    
    @IBOutlet private var contentController: ContentControllerView?
    
    @IBOutlet private var createdTasksButtonView: TabBarButtonView?
    @IBOutlet private var userButtonView: TabBarButtonView?
    @IBOutlet private var solvedTasksButtonView: TabBarButtonView?
    @IBOutlet private var browseButtonView: TabBarButtonView?
    @IBOutlet private var superViewOffset: UIView?
    @IBOutlet private var separatorLine: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createdTasksButtonView?.addTarget(self, action: #selector(createdTaskButtonPressed), for: .touchUpInside)
        userButtonView?.addTarget(self, action: #selector(userButtonPressed), for: .touchUpInside)
        solvedTasksButtonView?.addTarget(self, action: #selector(solvedTaskPressed), for: .touchUpInside)
        browseButtonView?.addTarget(self, action: #selector(browseButtonPressed), for: .touchUpInside)
        navigateTo(tab: .userTab)
        allButtons.forEach { button in
            button?.selectedColor = Color.lightGrey
            button?.normalColor = Color.darkGrey
            button?.backgroundColor = Color.darkBlue
        }
        superViewOffset?.backgroundColor = Color.darkBlue
        separatorLine?.backgroundColor = Color.darkGrey
    }
    
    private var allButtons: [TabBarButtonView?] { return [createdTasksButtonView, userButtonView, solvedTasksButtonView, browseButtonView] }
    
    var currentTab: Tab = .userTab {
        didSet {
            switch currentTab {
            case .userTab: allButtons.forEach { $0?.selected = $0 === userButtonView }
            case .createdTaskTab: allButtons.forEach { $0?.selected = $0 === createdTasksButtonView }
            case .solvedTaskTab: allButtons.forEach { $0?.selected = $0 === solvedTasksButtonView }
            case .browseTab: allButtons.forEach { $0?.selected = $0 === browseButtonView }
            }
        }
    }
    
    lazy private var createdTasksViewController: (controller: CreatedTasksViewController, navigationController: UINavigationController) = {
        let controller = CreatedTasksViewController.createFromStoryboard()
        let navigationController = UINavigationController(rootViewController: controller)
        return (controller, navigationController)
    }()
    
    lazy private var userViewController: (controller: UserViewController, navigationController: UINavigationController) = {
        let controller = UserViewController.createFromStoryboard()
        let navigationController = UINavigationController(rootViewController: controller)
        return (controller, navigationController)
    }()
    
    lazy private var solvedTasksViewController: (controller: SolvedTasksViewController, navigationController: UINavigationController) = {
        let controller = SolvedTasksViewController.createFromStoryboard(delegate: self)
        let navigationController = UINavigationController(rootViewController: controller)
        return (controller, navigationController)
    }()
    
    lazy private var browseTasksViewController: (controller: BrowseTasksViewController, navigationController: UINavigationController) = {
        let controller = BrowseTasksViewController.createFromStoryboard()
        let navigationController = UINavigationController(rootViewController: controller)
        return (controller, navigationController)
    }()
    
    @objc private func userButtonPressed() {
        if currentTab == .userTab {
            userViewController.navigationController.popToRootViewController(animated: true)
        } else {
            navigateTo(tab: .userTab)
        }
    }
    
    @objc private func createdTaskButtonPressed() {
        if currentTab == .createdTaskTab {
            createdTasksViewController.navigationController.popToRootViewController(animated: true)
        } else {
            navigateTo(tab: .createdTaskTab)
        }
    }
    @objc private func solvedTaskPressed() {
        if currentTab == .solvedTaskTab {
            solvedTasksViewController.navigationController.popToRootViewController(animated: true)
        } else {
            navigateTo(tab: .solvedTaskTab)
        }
    }
    
    @objc private func browseButtonPressed() {
        if currentTab == .browseTab {
            browseTasksViewController.navigationController.popToRootViewController(animated: true)
        } else {
            navigateTo(tab: .browseTab)
        }
    }
    
    func navigateTo(tab: Tab) {
        switch tab {
        case .userTab:
            contentController?.setViewController(controller: userViewController.navigationController)
        case .createdTaskTab:
            contentController?.setViewController(controller: createdTasksViewController.navigationController)
        case .solvedTaskTab:
            contentController?.setViewController(controller: solvedTasksViewController.navigationController)
        case .browseTab:
            contentController?.setViewController(controller: browseTasksViewController.navigationController)
        }
        currentTab = tab
    }
    
}

extension TabBarViewController {
    enum Tab {
        case userTab
        case createdTaskTab
        case solvedTaskTab
        case browseTab
    }
}

// MARK: - SolvedTasksViewControllerDelegate

extension TabBarViewController: SolvedTasksViewControllerDelegate {
    func solvedTasksViewController(_ sender: SolvedTasksViewController) {
        browseButtonPressed()
    }
}
