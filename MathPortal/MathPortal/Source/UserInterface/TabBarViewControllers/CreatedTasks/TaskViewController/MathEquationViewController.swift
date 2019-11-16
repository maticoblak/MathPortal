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
    @IBOutlet private var keyboardContentView: KeyboardView?
    @IBOutlet private var keyboardHightConstraint: NSLayoutConstraint?
    @IBOutlet private var keyboardBottomConstraint: NSLayoutConstraint?
    @IBOutlet private var equationView: UIView?
    
    weak var delegate: MathEquationViewControllerDelegate?
    
    private var keyboardOpened: Bool = false {
        didSet {
            keyboardBottomConstraint?.constant = keyboardOpened ? 0 : -280
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Appearence.addLeftBarButton(controller: self, leftBarButtonTitle: "< Back ", leftBarButtonAction: #selector(goToTaskViewController))
        equationView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCloseKeyboard)))
        refreshEquation()
        keyboardContentView?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        keyboardOpened = true
    }
    
    @objc private func goToTaskViewController() {
        delegate?.mathEquationViewController(sender: self, didWriteEquation: equation)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func openCloseKeyboard() {
        keyboardOpened = !keyboardOpened
    }
    
    private var currentView: UIView?
    private func refreshEquation() {
        currentView?.removeFromSuperview()
        if let view = equation.expression.generateView().view {
            currentView = view
            self.view.addSubview(view)
            view.frame.origin = CGPoint(x: 10.0, y: (equationView?.frame.minY ?? 0) + 20.0)
        }
    }
}

extension MathEquationViewController: KeyboardViewDelegate {
    func keyboardView(_ sender: KeyboardView, didChoose key: MathSymbol.SymbolType) {
        switch key {
        case .done:
            keyboardOpened = false
        case .back, .brackets, .delete, .forward, .indicator, .integer, .plus, .minus, .levelIn, .levelOut, .fraction, .root, .exponent, .index, .indexAndExponent, .logarithm, .letter, .multiplication, .division, .comma, .equal, .space, .enter:
            equation.handleMathKeyboardButtonsPressed(button: key)
        }
        refreshEquation()
    }
}
