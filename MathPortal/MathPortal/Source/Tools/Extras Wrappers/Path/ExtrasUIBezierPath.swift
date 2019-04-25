import UIKit

extension UIBezierPath {
    
    /// Used for static access. The lowercase is by design so you call UIView.extras.func
    typealias extras = UIBezierPathExtras
    
    var extras: UIBezierPathExtras {
        return UIBezierPathExtras(path: self)
    }
    
}

class UIBezierPathExtras {
    
    var path: UIBezierPath
    
    init(path: UIBezierPath) {
        self.path = path
    }
    
}
