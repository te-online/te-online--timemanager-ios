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
    
    var delegate: NSObject!
    
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
        
        self.cardType = CardType.DeckCard
        self.cardMode = CardMode.InTheDeck
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
        if pgr.state == .Changed {
            
            var center: CGPoint = pgr.view!.center
            let translation: CGPoint = pgr.translationInView(pgr.view!)
            
            var xPos: CGFloat = 0
            
            // If card is first card
            if(cardType == CardType.FirstCard) {
                // If movement is to the right
                if((translation.x + center.x) > center.x) {
                    // move card until middle of parent frame
                    xPos = center.x + translation.x
                    xPos = (xPos > pgr.view!.frame.width) ? pgr.view!.frame.width : xPos
                    (self.tableView.delegate as! EntriesViewController).mightNavigateLeft(self)
                } else {
                    // If movement is to the left
                    // dimm card more
                    // report to container -> maybe make next card active again
                    (self.tableView.delegate as! EntriesViewController).mightNavigateRight(self)
                    xPos = center.x
                }
            } else {
                if((translation.x + center.x) > center.x) {
                    (self.tableView.delegate as! EntriesViewController).mightNavigateLeft(self)
                } else {
                    // report to container -> maybe make next card active again
                    (self.tableView.delegate as! EntriesViewController).mightNavigateRight(self)
                }
                
                xPos = center.x + translation.x
                xPos = (xPos < pgr.view!.frame.width / 2) ? pgr.view!.frame.width / 2 : xPos
                xPos = (xPos >= self.parentViewController!.view!.frame.width) ? self.parentViewController!.view!.frame.width : xPos
                // If card is side by side left
                // If the movement is a slide to the right
                // position the card to active
                // report to container -> maybe make next card invisible
                // report to container -> maybe make previous card side by side left
                // If the movement is a slide to the left
                // dimm card more
                // report to container -> maybe next card side by side left and next, next card active
                
                // If card is side by side right
                // If the movement is to the right
                // report to container -> maybe navigation right
                // move card until half of it is out of viewport
                
                // If card is active
                // If the movement is to the right
                // report to container -> maybe navigation right
                // If the movement is to the left
                // report to container -> maybe navigation left
            }
            
//            NSLog("X " + String(xPos))
            center = CGPointMake(xPos, pgr.view!.center.y)
            pgr.view!.center = center
            pgr.setTranslation(CGPointZero, inView: pgr.view!)
        }
        if(pgr.state == .Ended) {
            NSLog("Touch ended.")
            self.repositionCard()
        }
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
    
    func repositionCard() {
        // If card is first card
        if(cardType == CardType.FirstCard) {
            // position card back to starting point
            var center: CGPoint = self.view!.center
            let xPos = self.view!.frame.width / 2
            center = CGPointMake(xPos, self.view!.center.y)
            self.view!.center = center
            if(cardMode == CardMode.InTheDeck) {
                self.view!.alpha = 0.3
            } else {
                self.view!.alpha = 1
            }
        } else {
            var center: CGPoint = self.view!.center
            var xPos: CGFloat = 0
            // If card is side by side left
            if(cardMode == CardMode.SideBySideLeft) {
                // Position card to side by side left
                xPos = self.view!.frame.width / 2
                center = CGPointMake(xPos, self.view!.center.y)
                self.view!.alpha = 1
            }
            // If card is side by side right
            if(cardMode == CardMode.SideBySideRight) {
                // Position card to side by side right
                xPos = self.view!.frame.width + (self.view!.frame.width / 2)
                center = CGPointMake(xPos, self.view!.center.y)
                self.view!.alpha = 1
            }
            // If card is active
            if(cardMode == CardMode.Active) {
                // Position card to active
//                xPos = self.parentViewController!.view!.frame.width - self.view!.frame.width / 2
                xPos = self.view!.frame.width + self.view!.frame.width / 2
                center = CGPointMake(xPos, self.view!.center.y)
                self.view!.alpha = 1
            }
            // If card is invisible
            if(cardMode == CardMode.Invisible) {
                // Position card to invisible
//                xPos = self.parentViewController!.view!.frame.width + self.view!.frame.width / 2
                xPos = self.view!.frame.width + self.view!.frame.width / 2
                center = CGPointMake(xPos, self.view!.center.y)
                self.view!.alpha = 0
            }
            // If card is in the deck
            if(cardMode == CardMode.InTheDeck) {
                // Position card to in the deck
                xPos = self.view!.frame.width / 2
                center = CGPointMake(xPos, self.view!.center.y)
                self.view!.alpha = 0.5
            }
            
            self.view!.center = center
        }
    }
    
    func positionActive() {
        // Position the card as active.
        self.cardMode = CardMode.Active
        
        self.repositionCard()
        
        // Make sure, the card is on the right edge of the view.
        // Make sure, the card is completely visible
    }
    
    func positionInTheDeck() {
        // Position the card as being in the deck.
        self.cardMode = CardMode.InTheDeck
        
        self.repositionCard()
        
        // Make sure, the card is on the left edge of the view (slightly off to see that there is a deck.)
        // Make sure, the card is dimm.
    }
    
    func positionSideBySideLeft() {
        // Position the card side by side left.
        self.cardMode = CardMode.SideBySideLeft
        
        self.repositionCard()
        
        // Make sure, the card is on the left edge of the view.
        // Make sure the card is completely visible.
    }
    
    func positionSideBySideRight() {
        // Position the card side by side right.
        self.cardMode = CardMode.SideBySideRight
        
        self.repositionCard()
        
        // Make sure, the card is on the right edge of the view.
        // Make sure, the card is completely visible.
    }
    
    func positionInvisible() {
        // Position the card side by side right.
        self.cardMode = CardMode.Invisible
        
        self.repositionCard()
        
        // Make sure, the card is on the right edge of the view.
        // Make sure, the card is completely visible.
    }
    
    func setCardType(type: CardType) {
        // Set the mode of the card here.
        self.cardType = type
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        NSLog("Touch ended.")
//    }
    
}
