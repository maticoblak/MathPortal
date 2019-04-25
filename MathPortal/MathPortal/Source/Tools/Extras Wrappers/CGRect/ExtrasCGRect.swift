import UIKit

extension CGRect {
    
    /// Used for static access. The lowercase is by design so you call UIView.extras.func
    typealias extras = CGRectExtras
    
    var extras: CGRectExtras {
        return CGRectExtras(frame: self)
    }
    
}

class CGRectExtras {
    
    var frame: CGRect
    
    init(frame: CGRect) {
        self.frame = frame
    }
    
}
