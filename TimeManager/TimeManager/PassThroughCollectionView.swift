//
//  PassThroughView.swift
//  TimeManager
//
//  Created by Thomas Ebert on 11.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class PassThroughCollectionView: UICollectionView {
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.hidden && subview.alpha > 0 && subview.userInteractionEnabled && subview.pointInside(convertPoint(point, toView: subview), withEvent: event) && subview.isMemberOfClass(UICollectionViewCell) {
                return true
            }
        }
        return false
    }
}
