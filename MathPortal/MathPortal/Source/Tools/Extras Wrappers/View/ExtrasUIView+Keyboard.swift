import UIKit

extension ExtrasUIView {

    @discardableResult func addToolbar(doneButton: (selector: Selector, target: UIViewController)) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let flexibleSpacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: doneButton.target, action: doneButton.selector)
        toolBar.items = [flexibleSpacing, doneButton]
        
        if let textField = self.view as? UITextField {
            textField.inputAccessoryView = toolBar
        } else if let textView = self.view as? UITextView {
            textView.inputAccessoryView = toolBar
        }
        
        return toolBar
    }
    
}
