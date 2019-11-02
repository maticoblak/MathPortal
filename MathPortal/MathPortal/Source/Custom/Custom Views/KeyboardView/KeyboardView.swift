//
//  KeyboardView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 27/10/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

protocol KeyboardViewDelegate: class {
    func keyboardView(_ sender: KeyboardView, didPress button: Button.ButtonType)
}

class KeyboardView: UIView {

    /// Different keyboards
    enum LayoutType {
        case numbers
        case letters
        case functions
    }
    
    
    @IBOutlet private var contentView: UIView?
    
    @IBOutlet private var keyboardView: UIView?
    @IBOutlet private var navigationView: UIView?
    
    // MARK: Keyboard with numbers
    @IBOutlet private var numberKeyboard: UIView?
    
    // MARK: Keyboard with letters
    @IBOutlet private var lettersKeyboard: UIView?
    @IBOutlet private var firstRow: UIStackView?
    @IBOutlet private var secondRow: UIStackView?
    @IBOutlet private var thirdRow: UIStackView?
    private var buttonsLetters: [KeyboardButton] = []
    
    // MARK: Keyboard with functions
    @IBOutlet var functionsKeyboard: UIView!
    
    
    weak var delegate: KeyboardViewDelegate?
    
    var type: LayoutType = .letters
    private var currentKeyboard: UIView? {
        switch type {
        case .numbers: return numberKeyboard
        case .letters: return lettersKeyboard
        case .functions: return functionsKeyboard
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        setupLettersKeyboard()
        addKeyboard(currentKeyboard)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
        setupLettersKeyboard()
        addKeyboard(currentKeyboard)
    }
    
    var previousFrame: CGRect = .zero
    override func layoutSubviews() {
        super.layoutSubviews()
        if previousFrame != self.frame {
            guard let firstRow = firstRow else { return }
            let contentInset = (((self.bounds.width + firstRow.spacing) / CGFloat(firstRow.arrangedSubviews.count)) - firstRow.spacing)/2
            secondRow?.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: contentInset, bottom: 0, trailing:  contentInset)
            thirdRow?.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 3*contentInset + firstRow.spacing, bottom: 0, trailing: 3*contentInset + firstRow.spacing)
            
            previousFrame = self.frame
        }
    }
    
    private func fromNib() {
        Bundle.main.loadNibNamed(R.nib.keyboardView.name, owner: self, options: nil)
        guard let contentView = contentView else { return }
        addSubview(contentView)
        addConstraints(parentView: self, childView: contentView)
    }
    
    private func addKeyboard(_ view: UIView?) {
        guard let view = view else { return }
        view.removeFromSuperview()
        keyboardView?.addSubview(view)
        addConstraints(parentView: keyboardView, childView: view)
    }
    
    private func addConstraints(parentView: UIView?, childView: UIView?) {
        guard let parentView = parentView, let childView = childView else { return }
        childView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addConstraint(NSLayoutConstraint(item: childView, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1.0, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: childView, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1.0, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: childView, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: 0))
    }
    
    @objc private func buttonClicked(sender: KeyboardButton) {
        guard let buttonType = sender.contentType else { return }
        print(sender.contentType)
        delegate?.keyboardView(self, didPress: buttonType)
    }
}

// MARK - Letters layout setup

extension KeyboardView {
    private func setupLettersKeyboard() {
        let letters = Button.ButtonType.letters
        Array(letters).forEach { buttonsLetters.append( KeyboardButton(type: $0)) }
        buttonsLetters.forEach { $0.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)}
        
        Array(buttonsLetters[0..<10]).forEach { self.firstRow?.addArrangedSubview( $0) }
        Array(buttonsLetters[10..<19]).forEach { self.secondRow?.addArrangedSubview( $0) }
        Array(buttonsLetters[19..<buttonsLetters.count]).forEach { self.thirdRow?.addArrangedSubview( $0) }
       
        
        self.firstRow?.distribution  = UIStackView.Distribution.fillEqually
        self.secondRow?.distribution  = UIStackView.Distribution.fillEqually
        self.thirdRow?.distribution  = UIStackView.Distribution.fillEqually
        
        secondRow?.isLayoutMarginsRelativeArrangement = true
        thirdRow?.isLayoutMarginsRelativeArrangement = true
        
    }
}
