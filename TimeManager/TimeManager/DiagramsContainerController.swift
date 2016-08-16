//
//  DiagramsContainerController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class DiagramsContainerController: UIViewController {
    
    @IBOutlet weak var PageViewContainer: UIView!
    @IBOutlet weak var YearNavigationButton: UIButton!
    @IBOutlet weak var MonthNavigationButton: UIButton!
    @IBOutlet weak var WeekNavigationButton: UIButton!
    @IBOutlet weak var DayNavigationButton: UIButton!
    
    @IBAction func YearNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(0)
    }
    
    @IBAction func MonthNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(1)
    }
    
    @IBAction func WeekNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(2)
    }
    
    @IBAction func DayNavigationButtonPressed(sender: AnyObject) {
        (self.childViewControllers[0] as! DiagramsPageViewController).jumpTo(3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
