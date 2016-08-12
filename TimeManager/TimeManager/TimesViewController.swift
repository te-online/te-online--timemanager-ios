//
//  TimesViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class TimesViewController: CardOfViewDeckController {
    
    var backgroundController: UIViewController!
    
    var clients = [Client]()
    
    struct Client {
        var clientName: String!
        var clientMeta: String!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load all the nice child views we're going to use.
        self.backgroundController = storyboard?.instantiateViewControllerWithIdentifier("TimesInfoBackground")
        
        // Show the first view.
        self.displayContentController(backgroundController!)
        
        self.collectionView!.frame = CGRect(x: 0, y: 30, width: self.view!.frame.width, height: self.collectionView!.frame.height - 30)
        self.collectionView!.backgroundColor = UIColor.clearColor()
        self.view!.backgroundColor = UIColor.whiteColor()
        
        clients = [Client(clientName: "CHOAM", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Acme Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Sirius Cybernetics Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Rich Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Evil Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Soylent Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Very Big Corp. of America", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Frobozz Magic Co.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Warbucks Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Tyrell Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Wayne Enterprises", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Virtucon", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Globex", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Umbrella Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Wonka Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Stark Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Clampett Oil", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Oceanic Airlines", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Yoyodyne Propulsion Sys.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Cyberdyne Systems Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "d’Anconia Copper", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Gringotts", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Oscorp", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Nakatomi Trading", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Spacely Space Sprockets", clientMeta: "2 projects • 224 hrs. • since 2012")]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("empty", forIndexPath: indexPath) as UICollectionViewCell!
            cell.backgroundColor = UIColor.clearColor()
            cell.userInteractionEnabled = false
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimeCell", forIndexPath: indexPath) as UICollectionViewCell!
            
            let ClientNameLabel = cell.viewWithTag(1) as! UILabel
            ClientNameLabel.text = self.clients[indexPath.row].clientName
            
            let ClientMetaLabel = cell.viewWithTag(2) as! UILabel
            ClientMetaLabel.text = self.clients[indexPath.row].clientMeta
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0) {
            return 1
        } else {
            return clients.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        reusableView = nil
        
        if(kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "TimesHeadCell", forIndexPath: indexPath)
            
            if(indexPath.section == 0) {
                headerView.backgroundColor = UIColor.clearColor()
                headerView.alpha = 0
                headerView.userInteractionEnabled = false
            }
            
            reusableView = headerView
        }
        
        return reusableView
    }
    
//    func collectionView(myView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        if indexPath.section == 0 {
//            return CGSize(width: self.view.frame.width, height: 200)
//        }
//        return CGSize(width: self.view.frame.width, height: 63)
//    }
    
    func displayContentController(content: UIViewController!) {
        // Add the new view controller.
        self.addChildViewController(content!)
        // Make sure the view fits perfectly into our layout.
        content!.view.frame = self.visibleFrameForEmbeddedControllers()
        // Add the new view.
        self.view!.insertSubview(content!.view, belowSubview: self.collectionView!)
        //        self.view!.addSubview(content!.view)
        // Tell the child that it now lives at their parents.
        content!.didMoveToParentViewController(self)
        content!.view.userInteractionEnabled = true
    }
    
    func visibleFrameForEmbeddedControllers() -> CGRect {
        // Let's give them a rect, where the nav bar is still visible (Nav Bar is 86px in width and full height).
        let showRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.6)
        return showRect
    }
    
}
