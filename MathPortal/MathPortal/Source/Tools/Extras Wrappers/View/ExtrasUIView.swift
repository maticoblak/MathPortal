import UIKit

extension UIView {
    
    /// Used for static access. The lowercase is by design so you call UIView.extras.func
    typealias extras = ExtrasUIView
    
    var extras: ExtrasUIView {
        return ExtrasUIView(view: self)
    }
    
}

class ExtrasUIView {

    var view: UIView
    
    init(view: UIView) {
        self.view = view
    }
    
}
