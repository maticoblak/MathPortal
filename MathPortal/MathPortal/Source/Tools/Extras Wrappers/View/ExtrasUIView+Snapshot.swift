import UIKit

extension ExtrasUIView {

    var snapshotImage: UIImage? {
        return generateSnapshotImage()
    }
    
    func generateSnapshotImage(scale: CGFloat = 0.0) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, scale)
        
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        self.view.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
}
