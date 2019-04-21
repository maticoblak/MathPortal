
import UIKit

class ContentControllerOverlay: ContentControllerView {
    
    /// The controller to which this one is currently attached
    private var currentContainerController: UIViewController?
    
    /// The constrinats added to current container controller
    private var currentContainerControllerConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    
    
    
    /// Will attach the contrnt controlelr view to a new view controller. An embeded view controller should be set again after this call (if it was previously set)
    ///
    /// - Parameter controller: The controller on which this view is attached to
    func attachTo(viewController controller: UIViewController, animated: Bool = true) {
        
        detatchFromCurrentController()
        
        self.parentViewController = controller
        
        self.translatesAutoresizingMaskIntoConstraints = false
        frame = controller.view.bounds
        controller.view.addSubview(self)
        
        var addedConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        addedConstraints.append(NSLayoutConstraint(item: controller.view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0))
        addedConstraints.append(NSLayoutConstraint(item: controller.view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0))
        addedConstraints.append(NSLayoutConstraint(item: controller.view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        addedConstraints.append(NSLayoutConstraint(item: controller.view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        currentContainerControllerConstraints = addedConstraints
        controller.view.addConstraints(addedConstraints)
        
        currentContainerController = controller
        
        self.alpha = 0.0
        UIView.animate(withDuration: animated ? 0.3 : 0.0) { 
            self.alpha = 1.0
        }
    }
    
    /// Removes the view from the current superview
    func detatchFromCurrentController(animated: Bool = true) {
        
        guard let currentController = currentContainerController else {
            return
        }
        
        UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
            self.alpha = 0.0
        }) { _ in
            currentController.view.removeConstraints(self.currentContainerControllerConstraints)
            self.removeFromSuperview()
            
            self.currentContainerControllerConstraints = []
            self.currentContainerController = nil
            
            self.setViewController(controller: nil)
            
            self.alpha = 1.0
        }
        
        
    }
    
    
}
