//
//  CustomTableView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 25/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

protocol CustomTableViewDelegate: class {
    func customTableView(sender: CustomTableView, didRemoveCellAt previousIndexPath: IndexPath, didInsertCellAt currentIndexPath: IndexPath)
}

class CustomTableView: UITableView {
    
    private var previousIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    private var cellSnapshot: UIView = UIView()
    private var cellAndTapDifference: CGFloat = 0
    
    override init(frame: CGRect, style: UITableView.Style = UITableView.Style.plain) {
        super.init(frame: frame, style: style)
        addLongPressGestureRecogniser()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addLongPressGestureRecogniser()
    }
    
    weak var customDelegate: CustomTableViewDelegate?
    
    private func addLongPressGestureRecogniser() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
        longPress.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPress)
    }
    
    @objc private func onLongPressGesture(sender: UILongPressGestureRecognizer) {
        
        let locationInTableView = sender.location(in: self)
        let currentIndexPath = self.indexPathForRow(at: locationInTableView)
        switch sender.state {
        case .began:
            guard let currentIndexPath = currentIndexPath, let cell = self.cellForRow(at: currentIndexPath) else { return }
            UISelectionFeedbackGenerator().selectionChanged()
            previousIndexPath = currentIndexPath
            cellAndTapDifference = locationInTableView.y - cell.center.y
            cellSnapshot = snapshotOfCell(inputView: cell, center: cell.center, alpha: 0.8)
            self.addSubview(cellSnapshot)
            cell.isHidden = true
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                self.cellSnapshot.transform = self.cellSnapshot.transform.scaledBy(x: 1.05, y: 1.05)
                self.cellSnapshot.alpha = 0.80
                
            }, completion: nil )
        case .changed:
            cellSnapshot.center.y = locationInTableView.y - cellAndTapDifference
            guard  let currentIndexPath = currentIndexPath, currentIndexPath != previousIndexPath else { return }
            //let itemToMove = equationsAndTexts[previousIndexPath.row]
            customDelegate?.customTableView(sender: self, didRemoveCellAt: previousIndexPath, didInsertCellAt: currentIndexPath)
            //equationsAndTexts.remove(at: previousIndexPath.row)
            //equationsAndTexts.insert(itemToMove, at: currentIndexPath.row)
            
            self.moveRow(at: previousIndexPath, to: currentIndexPath)
            self.previousIndexPath = currentIndexPath
        case .ended, .cancelled:
            guard let cell = self.cellForRow(at: previousIndexPath) else { return }
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.cellSnapshot.center = cell.center
                self.cellSnapshot.transform = CGAffineTransform.identity
            }, completion: { (finished) -> Void in
                if finished {
                    cell.isHidden = false
                    cell.alpha = 1
                    self.cellSnapshot.removeFromSuperview()
                }
            })
        case .possible, .failed:
            print("possible??")
        }
    }
    
    func snapshotOfCell(inputView: UIView, center: CGPoint, alpha: CGFloat) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let cellSnapshot = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        cellSnapshot.center = center
        cellSnapshot.alpha = alpha
        return cellSnapshot
    }
    
}
