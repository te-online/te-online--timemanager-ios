//
//  ClientTableViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 08.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol CardOfViewDeckControllerDelegate {
    func didSelectItemAtIndexPath(_ viewController: UICollectionViewController, indexPath: IndexPath)
    func mightNavigateLeft(_ sender: UICollectionViewController)
    func mightNavigateRight(_ sender: UICollectionViewController)
    func mightMoveWithOtherCards(_ sender: UICollectionViewController)
    func repositionCards()
    func didDeleteClient()
    func didDeleteProject()
    func didDeleteTask()
}

class CardOfViewDeckController: UICollectionViewController {
    
    var delegate: CardOfViewDeckControllerDelegate?
    
    var cardType: CardType!
    var cardMode: CardMode!
    
    var startX: Double = 0
    
    enum CardMode {
        case active
        case sideBySideLeft
        case sideBySideRight
        case inTheDeck
        case invisible
    }
    
    enum CardType {
        case firstCard
        case deckCard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pgr: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
        (self as UIViewController).view.addGestureRecognizer(pgr)
        pgr
        
        self.cardType = CardType.deckCard
        self.cardMode = CardMode.inTheDeck
        
        self.collectionView?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlePan(_ pgr: UIPanGestureRecognizer) {
        if pgr.state == .began {
            self.startX = Double(pgr.view!.center.x)
        }
        if pgr.state == .changed {
            // Okay, the user panned something. Let's figure out what!
            var center: CGPoint = pgr.view!.center
            let translation: CGPoint = pgr.translation(in: pgr.view!)
            
            var xPos: CGFloat = 0
            
            // If card is first card
            if(cardType == CardType.firstCard) {
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
                // Move the card the way the user wants.
                xPos = center.x + translation.x
                xPos = (xPos < pgr.view!.frame.width / 2) ? pgr.view!.frame.width / 2 : xPos
                xPos = (xPos >= pgr.view!.frame.width * 2) ? pgr.view!.frame.width * 2 : xPos
            }
            
            let targetX = translation.x + center.x
            
            // An ambition to navigate left or right will only be communicated when threshold of 50 is covered.
            if(targetX > center.x && abs(self.startX - Double(targetX)) > 50) {
                self.delegate?.mightNavigateLeft(self)
            } else if(targetX <= center.x && abs(self.startX - Double(targetX)) > 50) {
                // report to container -> maybe make next card active again
                self.delegate?.mightNavigateRight(self)
            }
            
            // There might be other cards that need to move because of this one...
            self.delegate?.mightMoveWithOtherCards(self)
            
            center = CGPoint(x: xPos, y: pgr.view!.center.y)
            pgr.view!.center = center
            pgr.setTranslation(CGPoint.zero, in: pgr.view!)
        }
        if(pgr.state == .ended) {
            // Okay, the user ended panning. Clean up the mess.
            self.delegate?.repositionCards()
        }
    }
    
    func moveCardFromLeft(_ x: Double) {
        var center: CGPoint = self.view!.center
        let xPos: CGFloat = CGFloat(x) + self.view!.frame.width / 2
        center = CGPoint(x: xPos, y: self.view!.center.y)
        self.view!.center = center
    }
    
    func moveCardFromRight(_ x: Double) {
        var center: CGPoint = self.view!.center
        let xPos: CGFloat = CGFloat(x) - self.view!.frame.width / 2
        center = CGPoint(x: xPos, y: self.view!.center.y)
        self.view!.center = center
    }
    
    func moveCardRightHandWithOtherCardsCenterPosition(_ x: Double) {
        var center: CGPoint = self.view!.center
        let xPos: CGFloat = CGFloat(x) + self.view!.frame.width
        center = CGPoint(x: xPos, y: self.view!.center.y)
        self.view!.center = center
    }
    
    func moveCardLeftHandWithOtherCardsCenterPosition(_ x: Double) {
        var center: CGPoint = self.view!.center
        let xPos: CGFloat = CGFloat(x) - self.view!.frame.width
        center = CGPoint(x: xPos, y: self.view!.center.y)
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
        if(cardType == CardType.firstCard) {
            // position card back to starting point
            let xPos = self.view!.frame.width / 2
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                self.view!.center = CGPoint(x: xPos, y: self.view!.center.y)
                self.view!.alpha = 1
                if(self.cardMode == CardMode.inTheDeck) {
                    self.view!.alpha = 0.3
                } else {
                    self.view!.alpha = 1
                }
            })
        } else {
            var xPos: CGFloat = 0
            // If card is side by side left
            if(cardMode == CardMode.sideBySideLeft) {
                // Position card to side by side left
                xPos = self.view!.frame.width / 2
                self.view!.alpha = 1
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    self.view!.center = CGPoint(x: xPos, y: self.view!.center.y)
                    self.view!.alpha = 1
                })
            }
            // If card is side by side right
            if(cardMode == CardMode.sideBySideRight) {
                // Position card to side by side right
                xPos = self.view!.frame.width + (self.view!.frame.width / 2)
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    self.view!.center = CGPoint(x: xPos, y: self.view!.center.y)
                    self.view!.alpha = 1
                })
            }
            // If card is active
            if(cardMode == CardMode.active) {
                // Position card to active
                xPos = self.view!.frame.width + self.view!.frame.width / 2
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    self.view!.center = CGPoint(x: xPos, y: self.view!.center.y)
                    self.view!.alpha = 1
                })
            }
            // If card is invisible
            if(cardMode == CardMode.invisible) {
                // Position card to invisible
                xPos = self.view!.frame.width * 2 + self.view!.frame.width / 2
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    self.view!.center = CGPoint(x: xPos, y: self.view!.center.y)
                })
                UIView.animate(withDuration: 0.3, animations: {() -> Void in
                    self.view!.alpha = 0
                })
            }
            // If card is in the deck
            if(cardMode == CardMode.inTheDeck) {
                // Position card to in the deck
                xPos = self.view!.frame.width / 2
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    self.view!.center = CGPoint(x: xPos, y: self.view!.center.y)
                    self.view!.alpha = 0.5
                })
            }
        }
    }
    
    // Active is essentially the same as SideBySideRight, but more speaking in some cases.
    func positionActive() {
        // Position the card as active.
        self.cardMode = CardMode.active
        // Make sure, the card is on the right edge of the view.
        // Make sure, the card is completely visible
    }
    
    func positionInTheDeck() {
        // Position the card as being in the deck.
        self.cardMode = CardMode.inTheDeck
        // Make sure, the card is on the left edge of the view (slightly off to see that there is a deck.)
        // Make sure, the card is dimm.
    }
    
    func positionSideBySideLeft() {
        // Position the card side by side left.
        self.cardMode = CardMode.sideBySideLeft
        // Make sure, the card is on the left edge of the view.
        // Make sure the card is completely visible.
    }
    
    func positionSideBySideRight() {
        // Position the card side by side right.
        self.cardMode = CardMode.sideBySideRight
        // Make sure, the card is on the right edge of the view.
        // Make sure, the card is completely visible.
    }
    
    func positionInvisible() {
        // Position the card side by side right.
        self.cardMode = CardMode.invisible
        // Make sure, the card is on the right edge of the view.
        // Make sure, the card is completely visible.
    }
    
    func setCardType(_ type: CardType) {
        // Set the mode of the card here.
        self.cardType = type
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        collectionView.reloadData()
        return self.getCellSize()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = self.getCellSize()
        self.collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    func setCellSize() {
         (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = self.getCellSize()
    }
    
    func getCellSize() -> CGSize {
        return CGSize(width: self.view.frame.width, height: 63)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItemAtIndexPath(self, indexPath: indexPath)
    }
    
}
