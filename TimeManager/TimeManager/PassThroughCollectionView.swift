//
//  PassThroughView.swift
//  TimeManager
//
//  Created by Thomas Ebert on 11.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

//protocol CollectionViewScrollDelegate {
//    func scrolledTo(position: UICollectionViewScrollPosition)
//}

class PassThroughCollectionView: UICollectionView {
    
//    var scrollDelegate: CollectionViewScrollDelegate!
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.hidden && subview.alpha > 0 && subview.userInteractionEnabled && subview.pointInside(convertPoint(point, toView: subview), withEvent: event) && subview.isMemberOfClass(UICollectionViewCell) {
                return true
            }
        }
        return false
    }
    
//    override func scrollToItemAtIndexPath(indexPath: NSIndexPath, atScrollPosition scrollPosition: UICollectionViewScrollPosition, animated: Bool) {
//        NSLog("Scroll position %@", String(scrollPosition))
//        self.scrollDelegate.scrolledTo(scrollPosition)
//        super.scrollToItemAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: animated)
//    }
    
    
}
