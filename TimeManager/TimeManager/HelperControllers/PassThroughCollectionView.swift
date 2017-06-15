//
//  PassThroughView.swift
//  TimeManager
//
//  Created by Thomas Ebert on 11.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class PassThroughCollectionView: UICollectionView {
    
    // Pass through touches to views behing this collectionsviews invisible cell.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) && subview.isMember(of: UICollectionViewCell) {
                return true
            }
        }
        return false
    }
    
}
