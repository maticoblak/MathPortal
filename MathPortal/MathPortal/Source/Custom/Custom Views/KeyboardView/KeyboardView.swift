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
    
    enum LetterKeyboard {
        case normal
        case greek
    }
    
    enum LetterKeyboardType {
        case uppercase
        case lowercase
    }
    
    @IBOutlet private var contentView: UIView?
    
    @IBOutlet private var keyboardView: UIView?
   
    // MARK: Bottom navigation buttons
    @IBOutlet private var deleteButton: KeyboardButton?
    @IBOutlet private var spaceButton: KeyboardButton?
    @IBOutlet private var enterButton: KeyboardButton?
    @IBOutlet private var inButton: KeyboardButton?
    @IBOutlet private var outButton: KeyboardButton?
    @IBOutlet private var leftButton: KeyboardButton?
    @IBOutlet private var rightButton: KeyboardButton?
    
    // MARK: Keyboard navigation bar
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
    @IBOutlet private var upperLettersButton: KeyboardButton?
    @IBOutlet private var greekLettersButton: KeyboardButton?
    @IBOutlet private var upperLettersButtonWidth: NSLayoutConstraint?
    @IBOutlet private var greekLettersButtonWidth: NSLayoutConstraint?
    
    private var letterKeyboard: LetterKeyboard = .normal {
        didSet {
            toggleLetterKeyboard()
        }
    }
    
    private var letterKeyboardType: LetterKeyboardType = .lowercase {
        didSet {
            toggleLetterKeyboard()
        }
    }
    
    // MARK: Keyboard with functions
    @IBOutlet private var functionsKeyboard: UIView?
    @IBOutlet private var functionsFirstRow: UIStackView?
    @IBOutlet private var functionsSecondRow: UIStackView?
    @IBOutlet private var functionsThirdRow: UIStackView?
    @IBOutlet private var functionsFourthRow: UIStackView?
    
    
    weak var delegate: KeyboardViewDelegate?
    private var keyboardHeight: CGFloat = 350
    
    private var gestureRecognisers: (singleTap: UITapGestureRecognizer, doubleTap: UIGestureRecognizer) {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(onSingleTap))
        singleTap.numberOfTapsRequired = 1
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        
        singleTap.require(toFail: doubleTap)
        
        return (singleTap, doubleTap)
    }
    
    private var type: LayoutType = .numbers {
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
    
    convenience init() {
        self.init(frame: .zero)
        setupKeyboardView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupKeyboardView()
    }
    
    private func setupKeyboardView() {
        fromNib()
        contentView?.backgroundColor = Color.darkBlue
        setupKeyboardNavigationButtons()
        setupDifferentKeyboardButtons()
        setupLettersKeyboard()
        setupNumbersKeyboard()
        setupFunctionsKeyboard()
        changeKeyboard()
        addKeyboardToWindow()
    }
    
    // MARK: Content insets setup for letters keyboard
    private var previousFrame: CGRect = .zero
    override func layoutSubviews() {
        super.layoutSubviews()
        if previousFrame != self.frame {
            guard let firstRow = firstRow else { return }
            let contentInset = (((self.bounds.width + firstRow.spacing) / CGFloat(firstRow.arrangedSubviews.count)) - firstRow.spacing)/2
            secondRow?.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: contentInset, bottom: 0, trailing:  contentInset)

            greekLettersButtonWidth?.constant = 3*contentInset
            upperLettersButtonWidth?.constant = 3*contentInset
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
    
    @IBAction private func toggleUppercase(_ sender: Any) {
        letterKeyboardType = letterKeyboardType == .lowercase ? .uppercase : .lowercase
    }
    
    @IBAction private func toggleLettersKeyboard(_ sender: Any) {
        letterKeyboard = letterKeyboard == .normal ? .greek : .normal
    }
    
    private func addKeyboardToWindow() {
        let window = UIApplication.shared.keyWindow!
        self.frame = CGRect(x: 0, y: window.bounds.height, width: window.bounds.width, height: keyboardHeight)
        window.addSubview(self)
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
            functionsKeyboard?.isHidden = false
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
        
    @objc private func onSingleTap(_ sender: UITapGestureRecognizer) {
        guard let buttonType = (sender.view as? KeyboardButton)?.contentType else { return }
        delegate?.keyboardView(self, didChoose: buttonType)
    }
    
    @objc private func onDoubleTap(_ sender: UITapGestureRecognizer) {
        guard let buttonType = (sender.view as? KeyboardButton)?.contentType?.doubleTap else { return }
        delegate?.keyboardView(self, didChoose: buttonType)
    }
}

// MARK: - Custom layout setup

extension KeyboardView {
    
    private func setupLettersKeyboard() {
        [greekLettersButton, upperLettersButton].compactMap {$0}.forEach { button in
            button.backgroundColor = Color.lightGrey
            button.tintColor = Color.darkBlue
            button.layer.cornerRadius = 5
        }
        toggleLetterKeyboard()
        addKeyboard(lettersKeyboard)
    }
    
    private func toggleLetterKeyboard() {
        let rows: [UIStackView?] = [firstRow, secondRow, thirdRow]
        rows.forEach { row in
            guard let row = row else { return }
            row.arrangedSubviews.forEach { $0.removeFromSuperview() }
        }
        
        let buttons: [[MathSymbol.SymbolType]] = {
            let letters: [MathSymbol.SymbolType]
            switch letterKeyboard {
            case .normal:
                letters = letterKeyboardType == .lowercase ? MathSymbol.SymbolType.letters : MathSymbol.SymbolType.lettersUppercase
            case.greek:
                letters = letterKeyboardType == .lowercase ? MathSymbol.SymbolType.greekLetters : MathSymbol.SymbolType.greekLettersUppercase
            }
            
            return [ Array(letters[0..<10]),  Array(letters[10..<19]),  Array(letters[19..<letters.count])]
        }()
        
        rows.forEach { row in
            row?.distribution = .fillEqually
            row?.isLayoutMarginsRelativeArrangement = true
            row?.isUserInteractionEnabled = true
        }
        
        for index in 0..<buttons.count {
            let row = buttons[index]
            row.forEach { buttonItem in
                let button = KeyboardButton(type: buttonItem)
                button.addGestureRecognizer(gestureRecognisers.singleTap)
                rows[index]?.addArrangedSubview(button)
            }
        }
        
    }
    
    private func setupNumbersKeyboard() {
        
        let leftButtons: [[MathSymbol.SymbolType]] = [[.exponent, .brackets, .percent],  [.fraction, .multiplication, .division], [.root, .plus, .minus]]
        
        let numbers: [MathSymbol.SymbolType] = MathSymbol.SymbolType.integers
        let rightButtons: [[MathSymbol.SymbolType]] = [ Array(numbers[1..<4]), Array(numbers[4..<7]), Array(numbers[7..<numbers.count]), [.integer(value: 0), .comma, .equal]]
         
        let leftRows: [UIStackView?] = [numbersLeftFirstRow, numbersLeftSecondRow, numbersLeftThirdRow]
        let rightRows: [UIStackView?] = [numbersRightFirstRow, numbersRightSecondRow, numbersRightThirdRow, numbersRightFourthRow]
        [leftRows,rightRows ].forEach { $0.forEach { $0?.distribution = UIStackView.Distribution.fillEqually }}
        
        for index in 0..<leftButtons.count {
            let row = leftButtons[index]
            row.forEach { buttonItem in
                let button = KeyboardButton(type: buttonItem)
                button.addGestureRecognizer(gestureRecognisers.singleTap)
                leftRows[index]?.addArrangedSubview(button)
            }
        }
         
        for index in 0..<rightButtons.count {
            let row = rightButtons[index]
            row.forEach { buttonItem in
                let button = KeyboardButton(type: buttonItem)
                button.addGestureRecognizer(gestureRecognisers.singleTap)
                rightRows[index]?.addArrangedSubview(button)
            }
        }
        
        addKeyboard(numberKeyboard)
    }
    
    
    private func setupFunctionsKeyboard() {    
        let buttons: [[MathSymbol.SymbolType]] = [[.sin, .cos, .tan, .cot], [.logarithm, .limit, .sumSeries, .productSeries], [.index, .indexAndExponent, .absoluteValue, .integral], [.lessThan, .greaterThan, .lessOrEqualThen, .greaterOrEqualThen, .faculty, .notEqual, .infinity]]
        
        let rows: [UIStackView?] = [functionsFirstRow, functionsSecondRow, functionsThirdRow, functionsFourthRow]
        rows.forEach { $0?.distribution = UIStackView.Distribution.fillEqually}
        
        for index in 0..<buttons.count {
            let row = buttons[index]
            row.forEach { buttonItem in
                let button = KeyboardButton(type: buttonItem)
                button.addGestureRecognizer(gestureRecognisers.singleTap)
                rows[index]?.addArrangedSubview(button)
            }
        }
        
        addKeyboard(functionsKeyboard)
    }
    
    private func setupKeyboardNavigationButtons() {
        spaceButton?.contentType = .space
        enterButton?.contentType = .enter
        deleteButton?.contentType = .delete
        inButton?.contentType = .levelIn
        outButton?.contentType = .levelOut
        leftButton?.contentType = .back
        rightButton?.contentType = .forward
        
        [spaceButton, deleteButton, inButton, outButton, leftButton, rightButton].forEach { button in
            button?.addGestureRecognizer(gestureRecognisers.singleTap)
        }
        
        let recognisers = gestureRecognisers
        enterButton?.addGestureRecognizer(recognisers.singleTap)
        enterButton?.addGestureRecognizer(recognisers.doubleTap)
    }
    
    private func setupDifferentKeyboardButtons() {
        [functionsKeyboardButtonView, numbersKeyboardButtonView, lettersKeyboardButtonView].forEach { view in
            view?.clipsToBounds = true
            view?.layer.cornerRadius = 2
            view?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        }
        functionsKeyboardButton?.setTitle("f(x)", for: .normal)
        numbersKeyboardButton?.setTitle("123", for: .normal)
        lettersKeyboardButton?.setTitle("Abγ", for: .normal)
    }
}


extension KeyboardView {
    
    func open() {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.y = self.frame.origin.y - self.keyboardHeight
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.y = self.frame.origin.y + self.keyboardHeight
        }
    }
    
    func remove() {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = self.frame.origin.y + self.keyboardHeight
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
