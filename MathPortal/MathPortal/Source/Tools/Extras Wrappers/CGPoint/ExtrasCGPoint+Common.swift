
import UIKit

extension CGPointExtras {

    func adding(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: self.point.x + point.x, y: self.point.y + point.y)
    }
    
}
