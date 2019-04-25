import UIKit

extension ExtrasUIView {

    func shake(duration: TimeInterval = 0.16, repeatCount: Int = 2, magnitude: CGPoint = CGPoint(x: 10.0, y: 0.0)) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = repeatCount > 1 ? duration/TimeInterval(repeatCount) : duration
        animation.repeatCount = Float(repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - magnitude.x, y: view.center.y + magnitude.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + magnitude.x, y: view.center.y - magnitude.y))
        view.layer.add(animation, forKey: "position")
    }
    
}
