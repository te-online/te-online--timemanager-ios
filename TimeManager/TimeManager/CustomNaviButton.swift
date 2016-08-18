//
//  CustomNaviButton.swift
//  TimeManager
//
//  Created by Thomas Ebert on 18.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class CustomNaviButton: UIButton {
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                self.alpha = 0.5
            }
            else {
                self.alpha = 1
            }
        }
    }
}