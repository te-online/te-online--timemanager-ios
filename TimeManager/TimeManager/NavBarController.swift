//
//  NavBarController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 09.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class NavBarController: UIViewController {
    
    var currentScreen = Int()
    var screens = [String]()
    
    @IBAction func NavBarButtonOverviewTouch(sender: AnyObject) {
        // Show overview screen
    }
    
    @IBAction func NavBarButtonEntriesTouch(sender: AnyObject) {
        // Show Entries screen
    }
    
    @IBAction func NavBarButtonStatisticsTouch(sender: AnyObject) {
        // Show Statistics Screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentScreen = 0;
        screens = ["OverviewScreenContainer", "EntriesScreenContainer", "StatisticsScreenContainer"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeView(screenNum: Int) {
        // Hide screen with current num
        //var currentScreenView = UIView
        //currentScreenView =
        // Show screen with new num
        
        // Save screen num
        //currentScreen = screenNum
    }
    
}