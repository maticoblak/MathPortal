//
//  KeyboardView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 27/10/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

protocol KeyboardViewDelegate: class {
    func keyboardView(_ sender: KeyboardView, didChoose key: MathSymbol.SymbolType)
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
    @IBOutlet private var deleteButton: KeyboardButton?
    @IBOutlet private var leftRightStackView: UIStackView?
    @IBOutlet private var spaceButton: KeyboardButton?
    @IBOutlet private var enterButton: KeyboardButton?
    @IBOutlet private var inOutStackView: UIStackView?
    
    
    
    @IBOutlet private var changeKeyboardView: UIView?
    @IBOutlet private var numbersKeyboardButtonView: UIView?
    @IBOutlet private var numbersKeyboardButton: CustomButton?
    @IBOutlet private var functionsKeyboardButtonView: UIView?
    @IBOutlet private var functionsKeyboardButton: CustomButton?
    @IBOutlet private var lettersKeyboardButtonView: UIView?
    @IBOutlet private var lettersKeyboardButton: CustomButton?
    
    // MARK: Keyboard with numbers
    @IBOutlet private var numberKeyboard: UIView?
    @IBOutlet private var numbersLeftFirstRow: UIStackView?
    @IBOutlet private var numbersLeftSecondRow: UIStackView?
    @IBOutlet private var numbersLeftThirdRow: UIStackView?
    @IBOutlet private var numbersRightFirstRow: UIStackView?
    @IBOutlet private var numbersRightSecondRow: UIStackView?
    @IBOutlet private var numbersRightThirdRow: UIStackView?
    @IBOutlet private var numbersRightFourthRow: UIStackView?
    @IBOutlet private var rightSideNumbersWidthConstraint: NSLayoutConstraint?
    
    // MARK: Keyboard with letters
    @IBOutlet private var lettersKeyboard: UIView?
    @IBOutlet private var firstRow: UIStackView?
    @IBOutlet private var secondRow: UIStackView?
    @IBOutlet private var thirdRow: UIStackView?
    private var buttonsLetters: [KeyboardButton] = []
    
    // MARK: Keyboard with functions
    @IBOutlet var functionsKeyboard: UIView!
    
    
    weak var delegate: KeyboardViewDelegate?
    
    var type: LayoutType = .numbers {
        didSet {
            changeKeyboard()
        }
    }
    private var currentKeyboard: UIView? {
        switch type {
        case .numbers: return numberKeyboard
        case .letters: return lettersKeyboard
        case .functions: return functionsKeyboard
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView?.backgroundColor = Color.darkBlue
        type = .numbers
        setupKeyboardNavigationButtons()
        setupDifferentKeyboardButtons()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        setupLettersKeyboard()
        setupNumbersKeyboard()
        addKeyboard(lettersKeyboard)
        addKeyboard(numberKeyboard)
        addKeyboard(functionsKeyboard)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
        setupLettersKeyboard()
        setupNumbersKeyboard()
        addKeyboard(lettersKeyboard)
        addKeyboard(numberKeyboard)
        addKeyboard(functionsKeyboard)
    }
    
    var previousFrame: CGRect = .zero
    override func layoutSubviews() {
        super.layoutSubviews()
        if previousFrame != self.frame {
            guard let firstRow = firstRow else { return }
            let contentInset = (((self.bounds.width + firstRow.spacing) / CGFloat(firstRow.arrangedSubviews.count)) - firstRow.spacing)/2
            secondRow?.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: contentInset, bottom: 0, trailing:  contentInset)
            thirdRow?.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 3*contentInset + firstRow.spacing, bottom: 0, trailing: 3*contentInset + firstRow.spacing)
            rightSideNumbersWidthConstraint?.constant = 2*self.bounds.width/5
            previousFrame = self.frame
        }
    }
    
    
    @IBAction private func changeKeyboard(_ sender: Any) {
        guard let sender = sender as? UIButton else { return }
        switch sender {
        case lettersKeyboardButton: type = .letters
        case numbersKeyboardButton: type = .numbers
        case functionsKeyboardButton: type = .functions
        default: return
        }
    }
    
    private func changeKeyboard() {
        [functionsKeyboard, numberKeyboard, lettersKeyboard].forEach { $0?.isHidden = true }
        [functionsKeyboardButtonView, numbersKeyboardButtonView, lettersKeyboardButtonView].forEach { $0?.backgroundColor = .white }
        switch type {
        case .numbers:
            numberKeyboard?.isHidden = false
            numbersKeyboardButtonView?.backgroundColor = Color.darkBlue
        case .letters:
            lettersKeyboard?.isHidden = false
            lettersKeyboardButtonView?.backgroundColor = Color.darkBlue
        case .functions:
            functionsKeyboard.isHidden = false
            functionsKeyboardButtonView?.backgroundColor = Color.darkBlue
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
        delegate?.keyboardView(self, didChoose: buttonType)
    }
}

// MARK - custom layout setup

extension KeyboardView {
    private func setupLettersKeyboard() {
        let letters = MathSymbol.SymbolType.letters
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
    
    private func setupNumbersKeyboard() {
        let numbers: [KeyboardButton] = MathSymbol.SymbolType.integers.map { KeyboardButton(type: $0)}
        let leftFirstRow: [KeyboardButton] = [MathSymbol.SymbolType.exponent, MathSymbol.SymbolType.index, MathSymbol.SymbolType.brackets].map { KeyboardButton(type: $0)}
        let leftSecondRow: [KeyboardButton] = [MathSymbol.SymbolType.fraction, MathSymbol.SymbolType.multiplication, MathSymbol.SymbolType.division].map { KeyboardButton(type: $0)}
        let leftThirdRow: [KeyboardButton] = [MathSymbol.SymbolType.root, MathSymbol.SymbolType.plus, MathSymbol.SymbolType.minus].map { KeyboardButton(type: $0)}
        let rightFourthRow: [KeyboardButton] = [MathSymbol.SymbolType.integer(value: 0), MathSymbol.SymbolType.comma, MathSymbol.SymbolType.equal].map { KeyboardButton(type: $0)}
        
        [numbers, leftFirstRow, leftSecondRow, leftThirdRow, rightFourthRow].forEach {  $0.forEach {$0.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside) } }
        
        leftFirstRow.forEach { self.numbersLeftFirstRow?.addArrangedSubview($0)}
        leftSecondRow.forEach { self.numbersLeftSecondRow?.addArrangedSubview($0)}
        leftThirdRow.forEach { self.numbersLeftThirdRow?.addArrangedSubview($0)}
        Array(numbers[1..<4]).forEach { self.numbersRightThirdRow?.addArrangedSubview($0)}
        Array(numbers[4..<7]).forEach { self.numbersRightSecondRow?.addArrangedSubview($0)}
        Array(numbers[7..<numbers.count]).forEach { self.numbersRightFirstRow?.addArrangedSubview($0)}
        rightFourthRow.forEach { self.numbersRightFourthRow?.addArrangedSubview($0)}
        
        [numbersLeftFirstRow, numbersLeftSecondRow, numbersLeftThirdRow, numbersRightFirstRow, numbersRightSecondRow, numbersRightThirdRow, numbersRightFourthRow].forEach { $0?.distribution = UIStackView.Distribution.fillEqually}
        
    }
    
    
    private func setupFunctionsKeyboard() {
        // TODO: setup keyboard with functions
    }
    
    private func setupKeyboardNavigationButtons() {
        spaceButton?.contentType = .space
        enterButton?.contentType = .enter
        deleteButton?.contentType = .delete
        
        let navigationButtonsLeftRight: [KeyboardButton] = [MathSymbol.SymbolType.back, MathSymbol.SymbolType.forward].map { KeyboardButton(type: $0)}
        
        let navigationButtonsInOut: [KeyboardButton] = [MathSymbol.SymbolType.levelIn, MathSymbol.SymbolType.levelOut].map { KeyboardButton(type: $0)}
        
        navigationButtonsLeftRight.forEach { button in
            button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            self.leftRightStackView?.addArrangedSubview(button)
        }
        navigationButtonsInOut.forEach { button in
            button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            self.inOutStackView?.addArrangedSubview(button)
        }
        if let spaceButton = spaceButton, let enterButton = enterButton, let deleteButton = deleteButton {
            [spaceButton, enterButton, deleteButton].forEach {$0.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside) }
        }
        
        [leftRightStackView, inOutStackView].forEach { $0?.distribution = UIStackView.Distribution.fillEqually}
        
    }
    
    private func setupDifferentKeyboardButtons() {
        [functionsKeyboardButtonView, numbersKeyboardButtonView, lettersKeyboardButtonView].forEach { view in
            view?.clipsToBounds = true
            view?.layer.cornerRadius = 2
            view?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        }
        functionsKeyboardButton?.setTitle("f(x)", for: .normal)
        numbersKeyboardButton?.setTitle("123", for: .normal)
        lettersKeyboardButton?.setTitle("ABc", for: .normal)
    }
}
