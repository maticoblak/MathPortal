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
    
    weak var delegate: MathEquationViewControllerDelegate?
    private let keyboardView = KeyboardView()
    
    private var currentViewScale: CGFloat = 1
    private var equationMaxWidth: CGFloat { view.bounds.width - 20 }
    
    private var panGestureRecogniser: UIPanGestureRecognizer?
    private var tapGestureRecogniser: UITapGestureRecognizer?
    
    private var keyboardOpened: Bool = false {
        didSet {
            keyboardOpened ? keyboardView.open() : keyboardView.close()
        }
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
        
        
        let pinchRecogniser = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        pinchRecogniser.delegate = self
        equationView?.addGestureRecognizer(pinchRecogniser)
            
        panGestureRecogniser = {
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveScreen))
            gestureRecognizer.maximumNumberOfTouches = 1
            gestureRecognizer.delegate = self
            equationView?.addGestureRecognizer(gestureRecognizer)
            return gestureRecognizer
        }()
        
        
        keyboardView.delegate = self
        
        refreshEquation()
        keyboardOpened = true
    }
    
    @objc private func goToTaskViewController() {
        keyboardView.remove()
        // TODO: Remove indicator
        delegate?.mathEquationViewController(sender: self, didWriteEquation: equation)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func openCloseKeyboard() {
        keyboardOpened = !keyboardOpened
    }
    
    private var priviousPinchScale: CGFloat = 1
    @objc private func scale(_ sender: UIPinchGestureRecognizer) {
        
        let scale = sender.scale
        print(scale)
        guard let currentSize = equationView?.bounds else { return }
        
        switch sender.state {
        case .began: break
        case .possible: break
        case .changed: break
        case .ended: break
        case .cancelled: break
        case .failed: break
        @unknown default: break
        }
        
    }
    private var currentViewLocation: CGPoint = CGPoint(x: 10, y: 20)
    private var previousPanLocation: CGPoint = .zero
    @objc func moveScreen(sender: UIPanGestureRecognizer) {
        let newLocation = sender.location(in: equationView)
        tapGestureRecogniser?.isEnabled = false
        switch sender.state {
        case .began:
            previousPanLocation = newLocation
        case .changed:
            let translation = CGPoint(x: newLocation.x - previousPanLocation.x, y: newLocation.y - previousPanLocation.y)
            translateScreen(by: translation)
            previousPanLocation = newLocation
            refreshEquation()
        case .ended, .cancelled, .failed:
            tapGestureRecogniser?.isEnabled = true
            snapScreenToPosition()
        @unknown default:
            return
        }
    }
    
    private func translateScreen(by point: CGPoint ) {
        guard let currentViewSize = currentView?.bounds.size else { return }
        guard let equationViewSize = equationView?.bounds.size else { return }
        if currentViewSize.width <= equationViewSize.width {
            currentViewLocation.y += point.y
        } else {
            currentViewLocation = currentViewLocation.extras.adding(point)
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
        
        currentViewLocation = newLocation
        UIView.animate(withDuration: 0.3) {
            self.currentView?.frame.origin = self.currentViewLocation
        }
    }

    private var currentView: UIView?
    private func refreshEquation() {
        currentView?.removeFromSuperview()
        if let view = equation.expression.generateView(withMaxWidth: equationMaxWidth).view {
            view.frame.origin = currentViewLocation
            currentView = view
            self.view.addSubview(view)
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
