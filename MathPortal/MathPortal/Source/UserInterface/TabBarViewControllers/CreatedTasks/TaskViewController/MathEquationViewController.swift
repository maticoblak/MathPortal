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
    
    private var keyboardOpened: Bool = false {
        didSet {
            keyboardOpened ? keyboardView.open() : keyboardView.close()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Appearence.addLeftBarButton(controller: self, leftBarButtonTitle: "< Back ", leftBarButtonAction: #selector(goToTaskViewController))
        equationView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCloseKeyboard)))
        keyboardView.delegate = self
        
        refreshEquation()
        keyboardOpened = true
    }
    
    @objc private func goToTaskViewController() {
        keyboardView.remove()
        delegate?.mathEquationViewController(sender: self, didWriteEquation: equation)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func openCloseKeyboard() {
        keyboardOpened = !keyboardOpened
    }
    
    private var currentView: UIView?
    private func refreshEquation() {
        currentView?.removeFromSuperview()
        if let view = equation.expression.generateView(withMaxWidth: view.bounds.width - 20).view {
            currentView = view
            self.view.addSubview(view)
            view.frame.origin = CGPoint(x: 10.0, y: (equationView?.frame.minY ?? 0) + 20.0)
        }
    }
}

extension MathEquationViewController: KeyboardViewDelegate {
    func keyboardView(_ sender: KeyboardView, didChoose key: MathSymbol.SymbolType) {
        equation.handleMathKeyboardButtonsPressed(button: key)
        refreshEquation()
    }
}
