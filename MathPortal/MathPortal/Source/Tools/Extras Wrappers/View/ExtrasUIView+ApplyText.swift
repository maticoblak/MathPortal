import UIKit

extension ExtrasUIView {

    var appliedText: String? {
        set {
            if let label = view as? UILabel {
                label.text = newValue
            } else if let button = view as? UIButton {
                button.setTitle(newValue, for: .normal)
            } else if let textView = view as? UITextView {
                textView.text = newValue
            } else if let textField = view as? UITextField {
                textField.text = newValue
            }
        }
        get {
            if let label = view as? UILabel {
                return label.text
            } else if let button = view as? UIButton {
                return button.title(for: .normal)
            } else if let textView = view as? UITextView {
                return textView.text
            } else if let textField = view as? UITextField {
                return textField.text
            } else {
                return nil
            }
        }
    }
    
}
