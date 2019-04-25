import UIKit

extension ExtrasUIView {

    // MARK: Horizontal
    
    var left: CGFloat {
        get {
            return view.frame.origin.x
        }
        set {
            view.frame.origin.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return view.frame.origin.x + view.frame.size.width
        }
        set {
            left = newValue - width
        }
    }
    
    var width: CGFloat {
        get {
            return view.frame.size.width
        }
        set {
            view.frame.size.width = newValue
        }
    }
    
    // MARK: Vertical
    
    var top: CGFloat {
        get {
            return view.frame.origin.y
        }
        set {
            view.frame.origin.y = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return view.frame.origin.y + view.frame.size.height
        }
        set {
            top = newValue - height
        }
    }
    
    var height: CGFloat {
        get {
            return view.frame.size.height
        }
        set {
            view.frame.size.height = newValue
        }
    }
    
    func frameIn(view: UIView?) -> CGRect? {
        return self.view.superview?.convert(self.view.frame, to: view)
    }
    
    func centerIn(view: UIView?) -> CGPoint? {
        return self.view.superview?.convert(self.view.center, to: view)
    }
    
}
