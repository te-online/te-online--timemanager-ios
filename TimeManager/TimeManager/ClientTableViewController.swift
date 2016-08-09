//
//  ClientTableViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 08.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class ClientTableViewController: UITableViewController {
    
    var clients = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        clients = ["CHOAM", "Acme Corp.", "Sirius Cybernetics Corp.", "Rich Industries", "Evil Corp.", "Soylent Corp.", "Very Big Corp. of America", "Frobozz Magic Co.", "Warbucks Industries", "Tyrell Corp.", "Wayne Enterprises", "Virtucon", "Globex", "Umbrella Corp.", "Wonka Industries", "Stark Industries", "Clampett Oil", "Oceanic Airlines", "Yoyodyne Propulsion Sys.", "Cyberdyne Systems Corp.", "d’Anconia Copper", "Gringotts", "Oscorp", "Nakatomi Trading", "Spacely Space Sprockets"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("clients") as UITableViewCell!
        cell.textLabel?.text = clients[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("selectedClient", sender: nil)
    }
    
}
