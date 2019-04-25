import UIKit

extension CGPoint {
    
    /// Used for static access. The lowercase is by design so you call UIView.extras.func
    typealias extras = CGPointExtras
    
    var extras: CGPointExtras {
        return CGPointExtras(point: self)
    }
    
}

class CGPointExtras {
    
    var point: CGPoint
    
    init(point: CGPoint) {
        self.point = point
    }
    
}
