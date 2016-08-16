//
//  SharedColorPalette.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class SharedColorPalette {
    static let sharedInstance = SharedColorPalette()
    
    let DarkGrey = UIColor(red: SharedColorPalette.convertRGB(46), green: SharedColorPalette.convertRGB(46), blue: SharedColorPalette.convertRGB(46), alpha: 1)
    let Grey = UIColor(red: SharedColorPalette.convertRGB(125), green: SharedColorPalette.convertRGB(125), blue: SharedColorPalette.convertRGB(125), alpha: 1)
    let MediumGrey = UIColor(red: SharedColorPalette.convertRGB(180), green: SharedColorPalette.convertRGB(180), blue: SharedColorPalette.convertRGB(180), alpha: 1)
    let LightGrey = UIColor(red: SharedColorPalette.convertRGB(227), green: SharedColorPalette.convertRGB(227), blue: SharedColorPalette.convertRGB(227), alpha: 1)
    let VeryLightGrey = UIColor(red: SharedColorPalette.convertRGB(235), green: SharedColorPalette.convertRGB(235), blue: SharedColorPalette.convertRGB(235), alpha: 1)
    let InvisibleGrey = UIColor(red: SharedColorPalette.convertRGB(247), green: SharedColorPalette.convertRGB(247), blue: SharedColorPalette.convertRGB(247), alpha: 1)
    
    let DarkBlue = UIColor(red: SharedColorPalette.convertRGB(78), green: SharedColorPalette.convertRGB(163), blue: SharedColorPalette.convertRGB(230), alpha: 1)
    let Blue = UIColor(red: SharedColorPalette.convertRGB(85), green: SharedColorPalette.convertRGB(180), blue: SharedColorPalette.convertRGB(253), alpha: 1)
    let MediumBlue = UIColor(red: SharedColorPalette.convertRGB(137), green: SharedColorPalette.convertRGB(204), blue: SharedColorPalette.convertRGB(255), alpha: 1)
    let LightBlue = UIColor(red: SharedColorPalette.convertRGB(188), green: SharedColorPalette.convertRGB(225), blue: SharedColorPalette.convertRGB(255), alpha: 1)
    
    let DarkRed = UIColor(red: SharedColorPalette.convertRGB(219), green: SharedColorPalette.convertRGB(78), blue: SharedColorPalette.convertRGB(16), alpha: 1)
    let Red = UIColor(red: SharedColorPalette.convertRGB(219), green: SharedColorPalette.convertRGB(108), blue: SharedColorPalette.convertRGB(67), alpha: 1)
    let MediumRed = UIColor(red: SharedColorPalette.convertRGB(219), green: SharedColorPalette.convertRGB(147), blue: SharedColorPalette.convertRGB(122), alpha: 1)
    
    let ProjectsCellBlue = UIColor(red: SharedColorPalette.convertRGB(203), green: SharedColorPalette.convertRGB(225), blue: SharedColorPalette.convertRGB(242), alpha: 1)
    let ProjectsCellActiveBlue = UIColor(red: SharedColorPalette.convertRGB(214), green: SharedColorPalette.convertRGB(237), blue: SharedColorPalette.convertRGB(255), alpha: 1)
    
    let TasksCellGreen = UIColor(red: SharedColorPalette.convertRGB(242), green: SharedColorPalette.convertRGB(255), blue: SharedColorPalette.convertRGB(244), alpha: 1)
    let TasksCellActiveGreen = UIColor(red: SharedColorPalette.convertRGB(247), green: SharedColorPalette.convertRGB(255), blue: SharedColorPalette.convertRGB(248), alpha: 1)
    
    static func convertRGB(rgb: Int) -> CGFloat {
        return CGFloat(rgb) / 255
    }
}
