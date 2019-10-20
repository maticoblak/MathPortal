//
//  CustomTextField.swift
//  MathPortal
//
//  Created by Petra Čačkov on 18/10/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

@IBDesignable class CustomTextField: UITextField {
    
    
    @IBInspectable var firstColor: UIColor = Color.pink {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var secondColor: UIColor = Color.orange {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var textFieldTitle: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var titleXPosition: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var titleYPosition: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 15 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineSpacing: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var topLine: HorizontalGradientView = HorizontalGradientView()
    private var textFieldTitleLabel: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextfield()
        addSubviews()
    }
    
    private func setupTextfield() {
        self.backgroundColor = .clear
        self.textColor = Color.lightGrey
        self.backgroundColor = Color.darkGrey
        self.layer.cornerRadius = 5
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: Color.darkBlue])
        }
        
    }
    
    var previousFrame : CGRect = .zero
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
        guard previousFrame != self.frame else { return }
        setupLines()
        setupLabels()
        previousFrame = self.frame
    }
    
    // NOTE: If there is no border the frame changes based on character size. So to prevent that the content size has to be constant.
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: textHeight())
    }
    
    /// Returns height of the font to calculate the content size of the textfield.
    private func textHeight() -> CGFloat {
        guard let font = self.font else { return 0.0 }
        return font.lineHeight + 7.0
    }
    
    
    private func setupLines() {
        topLine.frame = CGRect(x: 0, y: -lineSpacing, width: self.bounds.width, height: lineThickness)
        topLine.leftColor = firstColor
        topLine.rightColor = secondColor
    }
    private func addSubviews() {
        self.addSubview(topLine)
        setupLines()
        
        if textFieldTitle?.isEmpty == false {
            self.addSubview(textFieldTitleLabel)
            setupLabels()
        }
    }
    
    
    private func setupLabels() {
    
        textFieldTitleLabel.text = textFieldTitle
        textFieldTitleLabel.textColor = .white
        textFieldTitleLabel.font = textFieldTitleLabel.font.withSize(fontSize)
        textFieldTitleLabel.sizeToFit()
        textFieldTitleLabel.frame.origin = CGPoint(x: titleXPosition, y: -textFieldTitleLabel.bounds.height - titleYPosition - lineSpacing)
    }
    
}
