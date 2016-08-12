//
//  TestViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 11.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class ClientsViewController: CardOfViewDeckController {
    
    var backgroundController: UIViewController!
    
    var clients = [Client]()
    
    struct Client {
        var clientName: String!
        var clientMeta: String!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.backgroundColor = UIColor.clearColor()
        self.view!.backgroundColor = UIColor.whiteColor()
        
        clients = [Client(clientName: "CHOAM", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Acme Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Sirius Cybernetics Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Rich Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Evil Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Soylent Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Very Big Corp. of America", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Frobozz Magic Co.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Warbucks Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Tyrell Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Wayne Enterprises", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Virtucon", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Globex", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Umbrella Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Wonka Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Stark Industries", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Clampett Oil", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Oceanic Airlines", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Yoyodyne Propulsion Sys.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Cyberdyne Systems Corp.", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "d’Anconia Copper", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Gringotts", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Oscorp", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Nakatomi Trading", clientMeta: "2 projects • 224 hrs. • since 2012"), Client(clientName: "Spacely Space Sprockets", clientMeta: "2 projects • 224 hrs. • since 2012")]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("ClientCell", forIndexPath: indexPath) as UICollectionViewCell!
//            cell.backgroundColor = UIColor.whiteColor()
            
            let ClientNameLabel = cell.viewWithTag(1) as! UILabel
            ClientNameLabel.text = self.clients[indexPath.row].clientName
            
            let ClientMetaLabel = cell.viewWithTag(2) as! UILabel
            ClientMetaLabel.text = self.clients[indexPath.row].clientMeta
        
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return clients.count
        
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        reusableView = nil
        
        if(kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "ClientsHeadCell", forIndexPath: indexPath)
            
            headerView.backgroundColor = UIColor.whiteColor()
            
            reusableView = headerView
        }
        
        return reusableView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 63)
    }

    
}
