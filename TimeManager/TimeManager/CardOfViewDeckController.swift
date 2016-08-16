//
//  ClientTableViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 08.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol CardOfViewDeckControllerDelegate {
    func didSelectItemAtIndexPath(viewController: UICollectionViewController, indexPath: NSIndexPath)
    func mightNavigateLeft(sender: UICollectionViewController)
    func mightNavigateRight(sender: UICollectionViewController)
    func mightMoveWithOtherCards(sender: UICollectionViewController)
    func repositionCards()
}

class CardOfViewDeckController: UICollectionViewController {
    
    var delegate: CardOfViewDeckControllerDelegate?
    
    var hasFocus: Bool!
    var previousHasFocus: Bool!
    var nextHasFocus: Bool!
    
    var cardType: CardType!
    var cardMode: CardMode!
    
//    var delegate: NSObject!
    
    var startX: Double = 0
    
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
        
        self.collectionView?.delegate = self
        
//        NSLog("CollectionView width" + String(self.view.bounds.width/2))
//        self.setCellSize();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlePan(pgr: UIPanGestureRecognizer) {
        if pgr.state == .Began {
            self.startX = Double(pgr.view!.center.x)
        }
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
                } else {
                    // If movement is to the left
                    // dimm card more
                    xPos = center.x
                }
                
            } else {
                
                xPos = center.x + translation.x
                xPos = (xPos < pgr.view!.frame.width / 2) ? pgr.view!.frame.width / 2 : xPos
//                xPos = (xPos >= self.parentViewController!.view!.frame.width) ? self.parentViewController!.view!.frame.width : xPos
                xPos = (xPos >= pgr.view!.frame.width * 2) ? pgr.view!.frame.width * 2 : xPos
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
            
            let targetX = translation.x + center.x
            
            if(targetX > center.x && abs(self.startX - Double(targetX)) > 50) {
                self.delegate?.mightNavigateLeft(self)
//                (self.collectionView!.delegate as! CardOfViewDeckController).mightNavigateLeft(self)
                
            } else if(targetX <= center.x && abs(self.startX - Double(targetX)) > 50) {
                // report to container -> maybe make next card active again
//                (self.collectionView!.delegate as! EntriesViewController).mightNavigateRight(self)
                self.delegate?.mightNavigateRight(self)
            }
            
            self.delegate?.mightMoveWithOtherCards(self)
            
//            NSLog("X " + String(xPos))
            center = CGPointMake(xPos, pgr.view!.center.y)
            pgr.view!.center = center
            pgr.setTranslation(CGPointZero, inView: pgr.view!)
        }
        if(pgr.state == .Ended) {
//            NSLog("Touch ended.")
//            self.repositionCard()
            self.delegate?.repositionCards()
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
    
    func moveCardFromLeft(x: Double) {
        var center: CGPoint = self.view!.center
        let xPos: CGFloat = CGFloat(x) + self.view!.frame.width / 2
        center = CGPointMake(xPos, self.view!.center.y)
        self.view!.center = center
    }
    
    func moveCardFromRight(x: Double) {
        var center: CGPoint = self.view!.center
        let xPos: CGFloat = CGFloat(x) - self.view!.frame.width / 2
        center = CGPointMake(xPos, self.view!.center.y)
        self.view!.center = center
    }
    
    func moveCardRightHandWithOtherCardsCenterPosition(x: Double) {
        var center: CGPoint = self.view!.center
        let xPos: CGFloat = CGFloat(x) + self.view!.frame.width
        center = CGPointMake(xPos, self.view!.center.y)
        self.view!.center = center
    }
    
    func moveCardLeftHandWithOtherCardsCenterPosition(x: Double) {
        var center: CGPoint = self.view!.center
        let xPos: CGFloat = CGFloat(x) - self.view!.frame.width
        center = CGPointMake(xPos, self.view!.center.y)
        self.view!.center = center
    }
    
    func getRightX() -> Double {
        return Double(self.view!.center.x + self.view!.frame.width / 2)
    }
    
    func getLeftX() -> Double {
        return Double(self.view!.center.x - self.view!.frame.width / 2)
    }
    
    func getX() -> Double {
        return Double(self.view!.center.x)
    }
    
    func repositionCard() {
        // If card is first card
        if(cardType == CardType.FirstCard) {
            // position card back to starting point
            let xPos = self.view!.frame.width / 2
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                self.view!.center = CGPointMake(xPos, self.view!.center.y)
                self.view!.alpha = 1
                if(self.cardMode == CardMode.InTheDeck) {
                    self.view!.alpha = 0.3
                } else {
                    self.view!.alpha = 1
                }
            })
        } else {
            var xPos: CGFloat = 0
            // If card is side by side left
            if(cardMode == CardMode.SideBySideLeft) {
                // Position card to side by side left
                xPos = self.view!.frame.width / 2
                self.view!.alpha = 1
                UIView.animateWithDuration(0.25, animations: {() -> Void in
                    self.view!.center = CGPointMake(xPos, self.view!.center.y)
                    self.view!.alpha = 1
                })
            }
            // If card is side by side right
            if(cardMode == CardMode.SideBySideRight) {
                // Position card to side by side right
                xPos = self.view!.frame.width + (self.view!.frame.width / 2)
//                center = CGPointMake(xPos, self.view!.center.y)
//                self.view!.alpha = 1
                UIView.animateWithDuration(0.25, animations: {() -> Void in
                    self.view!.center = CGPointMake(xPos, self.view!.center.y)
                    self.view!.alpha = 1
                })
            }
            // If card is active
            if(cardMode == CardMode.Active) {
                // Position card to active
//                xPos = self.parentViewController!.view!.frame.width - self.view!.frame.width / 2
                xPos = self.view!.frame.width + self.view!.frame.width / 2
//                center = CGPointMake(xPos, self.view!.center.y)
//                self.view!.alpha = 1
                UIView.animateWithDuration(0.25, animations: {() -> Void in
                    self.view!.center = CGPointMake(xPos, self.view!.center.y)
                    self.view!.alpha = 1
                })
            }
            // If card is invisible
            if(cardMode == CardMode.Invisible) {
                // Position card to invisible
//                xPos = self.parentViewController!.view!.frame.width + self.view!.frame.width / 2
                xPos = self.view!.frame.width * 2 + self.view!.frame.width / 2
//                center = CGPointMake(xPos, self.view!.center.y)
//                self.view!.alpha = 0
                UIView.animateWithDuration(0.25, animations: {() -> Void in
                    self.view!.center = CGPointMake(xPos, self.view!.center.y)
                })
                UIView.animateWithDuration(0.3, animations: {() -> Void in
//                    self.view!.center = CGPointMake(xPos, self.view!.center.y)
                    self.view!.alpha = 0
                })
            }
            // If card is in the deck
            if(cardMode == CardMode.InTheDeck) {
                // Position card to in the deck
                xPos = self.view!.frame.width / 2
//                center = CGPointMake(xPos, self.view!.center.y)
//                self.view!.alpha = 0.5
                UIView.animateWithDuration(0.25, animations: {() -> Void in
                    self.view!.center = CGPointMake(xPos, self.view!.center.y)
                    self.view!.alpha = 0.5
                })
            }
        }
    }
    
    func positionActive() {
        // Position the card as active.
        self.cardMode = CardMode.Active
        
//        self.repositionCard()
        
        // Make sure, the card is on the right edge of the view.
        // Make sure, the card is completely visible
    }
    
    func positionInTheDeck() {
        // Position the card as being in the deck.
        self.cardMode = CardMode.InTheDeck
        
//        self.repositionCard()
        
        // Make sure, the card is on the left edge of the view (slightly off to see that there is a deck.)
        // Make sure, the card is dimm.
    }
    
    func positionSideBySideLeft() {
        // Position the card side by side left.
        self.cardMode = CardMode.SideBySideLeft
        
//        self.repositionCard()
        
        // Make sure, the card is on the left edge of the view.
        // Make sure the card is completely visible.
    }
    
    func positionSideBySideRight() {
        // Position the card side by side right.
        self.cardMode = CardMode.SideBySideRight
        
//        self.repositionCard()
        
        // Make sure, the card is on the right edge of the view.
        // Make sure, the card is completely visible.
    }
    
    func positionInvisible() {
        // Position the card side by side right.
        self.cardMode = CardMode.Invisible
        
//        self.repositionCard()
        
        // Make sure, the card is on the right edge of the view.
        // Make sure, the card is completely visible.
    }
    
    func setCardType(type: CardType) {
        // Set the mode of the card here.
        self.cardType = type
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        collectionView.reloadData()
//        NSLog("sizeForItemAtIndexPath width" + String(collectionView.frame.width))
        return self.getCellSize()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = self.getCellSize()
        self.collectionView!.collectionViewLayout.invalidateLayout()
        NSLog("invalidated")
    }
    
    func setCellSize() {
         (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = self.getCellSize()
    }
    
    func getCellSize() -> CGSize {
        return CGSizeMake(self.view.frame.width, 63)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.didSelectItemAtIndexPath(self, indexPath: indexPath)
    }
    
//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        currentSelection = indexPath
//    }
//    
//    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        currentSelection = nil
//    }
    
//    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
//        NSLog("Changing color" + String((collectionView as UICollectionView)))
////        
//        collectionView.reloadData()
//        
////        let cell: UICollectionViewCell = (collectionView as UICollectionView).cellForItemAtIndexPath(indexPath)!
////        let color: UIColor = cell.contentView.backgroundColor!
//        
////        cell.contentView.backgroundColor = UIColor(CGColor: CGColorCreateCopyWithAlpha(color.CGColor, 0.7)!)
//    }
////
////    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
////        NSLog("changing back color")
////        
////        let cell: UICollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath)!
////        let color: UIColor = cell.contentView.backgroundColor!
////        
////        cell.contentView.backgroundColor = UIColor(CGColor: CGColorCreateCopyWithAlpha(color.CGColor, 1)!)
////    }
    
}
