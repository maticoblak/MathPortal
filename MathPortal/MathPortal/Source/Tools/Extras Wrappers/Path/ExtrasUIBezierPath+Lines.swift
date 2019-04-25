
import UIKit

extension UIBezierPathExtras {

    static func lineAt(_ center: CGPoint, angle: CGFloat, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let direction: CGPoint = CGPoint(x: cos(angle)*radius, y: sin(angle)*radius)
        path.move(to: CGPoint(x: center.x - direction.x, y: center.y - direction.y))
        path.addLine(to: CGPoint(x: center.x + direction.x, y: center.y + direction.y))
        return path
    }
    
}
