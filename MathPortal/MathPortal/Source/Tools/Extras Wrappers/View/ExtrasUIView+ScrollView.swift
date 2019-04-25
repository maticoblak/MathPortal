import UIKit

extension ExtrasUIView {

    static func scrollToViews(scrollView: UIScrollView?,_ inputViews: [UIView?]) {
        guard let scrollView = scrollView else { return }
        let views: [UIView] = inputViews.compactMap { $0 }
        if views.count > 0 {
            let frames: [CGRect] = views.map { $0.convert($0.bounds, to: scrollView) }
            var frame = frames[0]
            for index in 1..<frames.count {
                frame = frame.union(frames[index])
            }
            scrollView.scrollRectToVisible(frame, animated: false)
        }
    }
    
    func scrollToViews(_ inputViews: [UIView?]) {
        ExtrasUIView.scrollToViews(scrollView: view as? UIScrollView, inputViews)
    }
    
}
