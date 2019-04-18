//
//  Appearence.swift
//  Assignment
//
//  Created by Petra Čačkov on 28/03/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class Appearence {

    static func shadows(view: UIView, color: CGColor) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = color
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = 1
    }
    
    static func setUpnavigationBar(controller: UIViewController, leftBarButtonTitle: String?, leftBarButtonAction: Selector?, rightBarButtonTitle: String?, rightBarButtonAction: Selector?, font: String? = nil , fontSize: Int? = nil ) {
        
        controller.navigationItem.leftBarButtonItem  = {
            let button = UIBarButtonItem(title: leftBarButtonTitle, style: .plain, target: controller, action: leftBarButtonAction )
            button.tintColor = UIColor.black
            return button
        }()
        controller.navigationItem.rightBarButtonItem  = {
            let button = UIBarButtonItem(title: rightBarButtonTitle, style: .plain, target: controller, action: rightBarButtonAction )
            button.tintColor = UIColor.black
            return button
        }()
        if leftBarButtonTitle != nil , leftBarButtonAction != nil  { controller.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: font ?? "Helvetica", size: CGFloat(fontSize ?? 15)) ?? UIFont.systemFontSize ], for: UIControl.State.normal)
        }
        if rightBarButtonTitle != nil , rightBarButtonAction != nil {
            controller.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: font ?? "Helvetica" , size: CGFloat(fontSize ?? 15)) ?? UIFont.systemFontSize ], for: UIControl.State.normal)
        }
    }
    
    static func addRightBarButton(controller: UIViewController, rightBarButtonTitle: String, rightBarButtonAction: Selector, font: String? = nil , fontSize: Int? = nil) {
        setUpnavigationBar(controller: controller, leftBarButtonTitle: nil , leftBarButtonAction: nil , rightBarButtonTitle: rightBarButtonTitle, rightBarButtonAction: rightBarButtonAction, font: font, fontSize: fontSize)
    }
    static func addLeftBarButton(controller: UIViewController, leftBarButtonTitle: String, leftBarButtonAction: Selector, font: String? = nil, fontSize: Int? = nil) {
        setUpnavigationBar(controller: controller, leftBarButtonTitle: leftBarButtonTitle , leftBarButtonAction: leftBarButtonAction , rightBarButtonTitle: nil , rightBarButtonAction: nil, font: font, fontSize: fontSize)
    }
    
    
    static func setUpNavigationController(controller: UIViewController, titleColor: UIColor = UIColor.black, barColor: UIColor = UIColor.gray, font: String, titleFontSize: CGFloat = UIFont.systemFontSize, title: String = "" ) {
        controller.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor :  titleColor, NSAttributedString.Key.font: UIFont(name: font, size: 22) ?? UIFont.systemFontSize]
        controller.navigationController?.navigationBar.barTintColor = barColor
        controller.title = title
    }
}
    
