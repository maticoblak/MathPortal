//
//  Appearence.swift
//  Assignment
//
//  Created by Petra Čačkov on 28/03/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class Appearence {
    
    static func getGradientLayerFor(_ myView: UIView?, colors: [CGColor]) -> CAGradientLayer? {
        guard let myView = myView else { return nil }
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: myView.frame.size)
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.locations = [0.0, 1]

        let shape = CAShapeLayer()
        shape.lineWidth = 7
        shape.path = UIBezierPath(rect: myView.bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        return gradient
    }
    
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
            button.tintColor = UIColor.white
            return button
        }()
        controller.navigationItem.rightBarButtonItem  = {
            let button = UIBarButtonItem(title: rightBarButtonTitle, style: .plain, target: controller, action: rightBarButtonAction )
            button.tintColor = UIColor.white
            return button
        }()
        if leftBarButtonTitle != nil , leftBarButtonAction != nil  { controller.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: font ?? "Helvetica", size: CGFloat(fontSize ?? 15)) ?? UIFont.systemFontSize ], for: UIControl.State.normal)
        }
        if rightBarButtonTitle != nil , rightBarButtonAction != nil {
            controller.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: font ?? "Helvetica" , size: CGFloat(fontSize ?? 15)) ?? UIFont.systemFontSize ], for: UIControl.State.normal)
        }
    }
    
    static func addRightBarButton(controller: UIViewController, rightBarButtonTitle: String, rightBarButtonAction: Selector, font: String? = nil , fontSize: Int? = nil) {
        setUpnavigationBar(controller: controller, leftBarButtonTitle: nil, leftBarButtonAction: nil , rightBarButtonTitle: rightBarButtonTitle, rightBarButtonAction: rightBarButtonAction, font: font, fontSize: fontSize)
    }
    static func addLeftBarButton(controller: UIViewController, leftBarButtonTitle: String, leftBarButtonAction: Selector, font: String? = nil, fontSize: Int? = nil) {
        setUpnavigationBar(controller: controller, leftBarButtonTitle: leftBarButtonTitle , leftBarButtonAction: leftBarButtonAction , rightBarButtonTitle: nil , rightBarButtonAction: nil, font: font, fontSize: fontSize)
    }
    
    
    static func setUpNavigationController(controller: UIViewController, titleColor: UIColor = UIColor.white, barColor: UIColor = UIColor.mathDarkBlue, font: String = "System", titleFontSize: CGFloat = UIFont.systemFontSize, title: String? = nil ) {
        if let title = title {
            controller.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor :  titleColor, NSAttributedString.Key.font: UIFont(name: font, size: 22) ?? UIFont.systemFontSize]
            controller.title = title
            
        }
        controller.navigationController?.navigationBar.isTranslucent = false
        controller.navigationController?.navigationBar.barTintColor = barColor.withAlphaComponent(1)
        //controller.navigationController?.navigationBar.backgroundColor = barColor.withAlphaComponent(1)

    }
}
    
