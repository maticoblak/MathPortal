//
//  MathEquationViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 26/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

protocol MathEquationViewControllerDelegate: class {
    func mathEquationViewController(sender: MathEquationViewController, didWriteEquation equation: Equation)
}

class MathEquationViewController: UIViewController {
    
    var equation: Equation = Equation()
    
    @IBOutlet private var equationView: UIView?
    @IBOutlet private var equationViewBottomConstraint: NSLayoutConstraint?
    
    weak var delegate: MathEquationViewControllerDelegate?
    private let keyboardView = KeyboardView()

    private var panGestureRecogniser: UIPanGestureRecognizer?
    private var tapGestureRecogniser: UITapGestureRecognizer?
    private var pinchGestureRecogniser: UIPinchGestureRecognizer?
    
    private var currentViewLocation: CGPoint = CGPoint(x: 10, y: 20) {
        didSet {
            currentView?.frame.origin = currentViewLocation
        }
    }
    
    private var keyboardOpened: Bool = false {
        didSet {
            toggleKeyboard()
        }
    }
    
    private func toggleKeyboard() {
        guard let equationViewHeight = equationView?.bounds.height else { return }
        let keyboardHeight = keyboardView.bounds.height - 94  // 94 is height of tab bar, 30 is offset
        
        if keyboardOpened, let cursorLocation = Equation.currentCursorLocation(InView: equationView), cursorLocation.y >= equationViewHeight - keyboardHeight {
            let translation: CGPoint = CGPoint(x: 0, y: equationViewHeight - keyboardHeight - cursorLocation.y)
            self.translateScreen(by: translation, animationDuration: 0.3)
        }
        equationViewBottomConstraint?.constant = keyboardOpened ? keyboardHeight : 0.0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        snapScreenToPosition()
        keyboardOpened ? keyboardView.open() : keyboardView.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appearence.addLeftBarButton(controller: self, leftBarButtonTitle: "< Back ", leftBarButtonAction: #selector(goToTaskViewController))
        
        tapGestureRecogniser = {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCloseKeyboard))
            tapRecognizer.delegate = self
            equationView?.addGestureRecognizer(tapRecognizer)
            return tapRecognizer
        }()
        
        pinchGestureRecogniser = {
            let pinchRecogniser = UIPinchGestureRecognizer(target: self, action: #selector(scale))
            pinchRecogniser.delegate = self
            equationView?.addGestureRecognizer(pinchRecogniser)
            return pinchRecogniser
        }()
                    
        panGestureRecogniser = {
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveScreen))
            gestureRecognizer.maximumNumberOfTouches = 1
            gestureRecognizer.delegate = self
            equationView?.addGestureRecognizer(gestureRecognizer)
            return gestureRecognizer
        }()
        
        
        keyboardView.delegate = self
        equation.addCursor()
        refreshEquation()
        keyboardOpened = true
    }
    
    @objc private func goToTaskViewController() {
        keyboardView.remove()
        equation.removeCursor()
        delegate?.mathEquationViewController(sender: self, didWriteEquation: equation)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func openCloseKeyboard() {
        keyboardOpened = !keyboardOpened
    }
    
    private var currentViewScale: CGFloat = 1 {
        didSet {
            equation.expression.defaultScale = currentViewScale
            
            refreshEquation()
        }
    }
    private lazy var equationMaxWidth: CGFloat = view.bounds.width - 20
    private var previousPinchScale: CGFloat = 1
    @objc private func scale(_ sender: UIPinchGestureRecognizer) {
        panGestureRecogniser?.isEnabled = false
        tapGestureRecogniser?.isEnabled = false
        let newScale = sender.scale
        let location = sender.location(in: equationView)
        switch sender.state {
        case .began:
            previousPinchScale = newScale
        case .changed:
            let scale = currentViewScale/previousPinchScale * newScale
            changeScale(to: scale, around: location)
            previousPinchScale = newScale
        case .failed, .cancelled, .ended:
            panGestureRecogniser?.isEnabled = true
            tapGestureRecogniser?.isEnabled = true
            snapScreenToPosition()
        @unknown default:
            break
        }
        
    }
    
    private func changeScale(to newScale: CGFloat, around point: CGPoint) {
        let newScale: CGFloat = {
            if newScale < 1 {
                return 1
            } else if newScale > 5 {
                return 5
            } else {
                return newScale
            }
        }()
        let translation = CGPoint(x: newScale/currentViewScale * (currentViewLocation.x - point.x) + point.x, y: newScale/currentViewScale * (currentViewLocation.y - point.y) + point.y)
        currentViewScale = newScale
        equationMaxWidth *= newScale
        currentViewLocation = translation
    }
    

    private var previousPanLocation: CGPoint = .zero
    @objc func moveScreen(sender: UIPanGestureRecognizer) {
        let newLocation = sender.location(in: equationView)
        tapGestureRecogniser?.isEnabled = false
        pinchGestureRecogniser?.isEnabled = false
        switch sender.state {
        case .began:
            previousPanLocation = newLocation
        case .changed:
            let translation = CGPoint(x: newLocation.x - previousPanLocation.x, y: newLocation.y - previousPanLocation.y)
            translateScreen(by: translation)
            previousPanLocation = newLocation
        case .ended, .cancelled, .failed:
            tapGestureRecogniser?.isEnabled = true
            pinchGestureRecogniser?.isEnabled = true
            snapScreenToPosition()
        @unknown default:
            return
        }
    }
    
    private func translateScreen(by point: CGPoint, animationDuration: Double = 0 ) {
        guard let currentViewSize = currentView?.bounds.size else { return }
        guard let equationViewSize = equationView?.bounds.size else { return }
        
        UIView.animate(withDuration: animationDuration) {
            if currentViewSize.width <= equationViewSize.width {
                self.currentViewLocation.y += point.y
            } else {
                self.currentViewLocation = self.currentViewLocation.extras.adding(point)
            }
        }
    }
    
    private func snapScreenToPosition() {
        guard let currentViewSize = currentView?.bounds.size else { return }
        guard let equationViewSize = equationView?.bounds.size else { return }
        var newLocation = currentViewLocation
        
        if currentViewLocation.y > 20 {
            newLocation.y = 20
        } else if currentViewSize.height + currentViewLocation.y <= equationViewSize.height - 20 {
            newLocation.y = min(20, equationViewSize.height - currentViewSize.height - 20)
        }
        
        if currentViewLocation.x > 0 {
            newLocation.x = 10
        } else if currentViewSize.width + currentViewLocation.x <= equationViewSize.width - 10 {
            newLocation.x = min(10, equationViewSize.width - currentViewSize.width)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.currentViewLocation = newLocation
        }
    }
    
    private var currentView: UIView?
    private func refreshEquation() {
        currentView?.removeFromSuperview()
        if let view = equation.expression.generateView(withMaxWidth: equationMaxWidth).view {
            view.frame.origin = currentViewLocation
            currentView = view
            self.equationView?.addSubview(view)
        }
    }
}

extension MathEquationViewController: KeyboardViewDelegate {
    func keyboardView(_ sender: KeyboardView, didChoose key: MathSymbol.SymbolType) {
        equation.handleMathKeyboardButtonsPressed(button: key)
        refreshEquation()
    }
}

extension MathEquationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
