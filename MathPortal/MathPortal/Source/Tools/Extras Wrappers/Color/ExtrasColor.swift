import UIKit

extension UIColor {
    
    /// Used for static access. The lowercase is by design so you call UIView.extras.func
    typealias extras = UIColorExtras
    
    var extras: UIColorExtras {
        return UIColorExtras(color: self)
    }
    
}

class UIColorExtras {
    
    var color: UIColor
    
    init(color: UIColor) {
        self.color = color
    }
    
}
