import UIKit

extension CGFloat {
    
    /// Used for static access. The lowercase is by design so you call UIView.extras.func
    typealias extras = CGFloatExtras
    
    var extras: CGFloatExtras {
        return CGFloatExtras(value: self)
    }
    
}

class CGFloatExtras {
    
    var value: CGFloat
    
    init(value: CGFloat) {
        self.value = value
    }
    
}
