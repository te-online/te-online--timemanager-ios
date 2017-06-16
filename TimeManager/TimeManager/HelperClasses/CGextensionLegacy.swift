//
//  CGextensionLegacy.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.06.17.
//  Copyright © 2017 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

extension CGRect {
    mutating func offsetInPlace(dx: CGFloat, dy: CGFloat) {
        self = self.offsetBy(dx: dx, dy: dy)
    }
}
