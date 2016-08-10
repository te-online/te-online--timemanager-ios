//
//  ClientTableViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 08.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class ProjectTableViewController: UITableViewController {
    
    var hasFocus: Bool!
    var previousHasFocus: Bool!
    var nextHasFocus: Bool!
    
    var cardType: CardType!
    var cardMode: CardMode!
    
    enum CardMode {
        case Active
        case SideBySideLeft
        case SideBySideRight
        case InTheDeck
        case Invisible
    }
    
    enum CardType {
        case FirstCard
        case DeckCard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pgr: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
        (self as UIViewController).view.addGestureRecognizer(pgr)
        pgr
        
        self.hasFocus = true
        self.previousHasFocus = false
        self.nextHasFocus = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("projects") as UITableViewCell!
        cell.textLabel?.text = "World"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func handlePan(pgr: UIPanGestureRecognizer) {
//        if pgr.state == .Changed {
//            var center: CGPoint = pgr.view!.center
//            let translation: CGPoint = pgr.translationInView(pgr.view!)
//            var xPos = center.x + translation.x
//            NSLog("X " + String(xPos))
//            xPos = (xPos < (pgr.view!.frame.width / 2) + 5) ? (pgr.view!.frame.width / 2) + 5 : xPos
//            center = CGPointMake(xPos, pgr.view!.center.y)
//            pgr.view!.center = center
//            pgr.setTranslation(CGPointZero, inView: pgr.view!)
//        }
//        if(pgr.state == .Ended) {
//             NSLog("Touch ended.")
//            if((self.hasFocus) != nil && self.hasFocus == true) {
//                var center: CGPoint = pgr.view!.center
//                let xPos = pgr.view!.frame.width + (pgr.view!.frame.width / 2)
//                center = CGPointMake(xPos, pgr.view!.center.y)
//                pgr.view!.center = center
//                pgr.setTranslation(CGPointZero, inView: pgr.view!)
//                pgr.view!.alpha = 1
//            } else if((self.previousHasFocus) != nil && self.previousHasFocus == true) {
//                var center: CGPoint = pgr.view!.center
//                let xPos = pgr.view!.frame.width + (pgr.view!.frame.width / 2)
//                center = CGPointMake(xPos, pgr.view!.center.y)
//                pgr.view!.center = center
//                pgr.setTranslation(CGPointZero, inView: pgr.view!)
//                pgr.view!.alpha = 0.3
//            } else if((self.nextHasFocus) != nil && self.nextHasFocus == true) {
//                var center: CGPoint = pgr.view!.center
//                let xPos = (pgr.view!.frame.width / 2) + 5
//                center = CGPointMake(xPos, pgr.view!.center.y)
//                pgr.view!.center = center
//                pgr.setTranslation(CGPointZero, inView: pgr.view!)
//                pgr.view!.alpha = 0.3
//            } else {
//                var center: CGPoint = pgr.view!.center
//                let xPos = (pgr.view!.frame.width / 2) + 5
//                center = CGPointMake(xPos, pgr.view!.center.y)
//                pgr.view!.center = center
//                pgr.setTranslation(CGPointZero, inView: pgr.view!)
//                pgr.view!.alpha = 0.3
//            }
//        }
    }
    
//    public func setFocus(type: String) {
//        if(type == "self") {
//            self.hasFocus = true
//            self.nextHasFocus = false
//            self.previousHasFocus = false
//        } else if(type == "previous") {
//            self.hasFocus = false
//            self.nextHasFocus = false
//            self.previousHasFocus = true
//        } else if(type == "next") {
//            self.hasFocus = false
//            self.nextHasFocus = true
//            self.previousHasFocus = false
//        } else {
//            self.hasFocus = false
//            self.nextHasFocus = false
//            self.previousHasFocus = false
//        }
//    }
    
    func positionActive() {
        // Position the card as active.
        self.cardMode = CardMode.Active
    }
    
    func positionInTheDeck() {
        // Position the card as being in the deck.
        self.cardMode = CardMode.InTheDeck
    }
    
    func setCardType(type: CardType) {
        // Set the mode of the card here.
        self.cardType = type
    }
    
    func positionCardSideBySideLeft() {
        // Position the card side by side left.
        self.cardMode = CardMode.SideBySideLeft
    }
    
    func positionCardSideBySideRight() {
        // Position the card side by side right.
        self.cardMode = CardMode.SideBySideRight
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        NSLog("Touch ended.")
//    }
    
}
