//
//  DayChartDetailTableView.swift
//  TimeManager
//
//  Created by Thomas Ebert on 22.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class DayChartDetailController: UITableView {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if(indexPath.section == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("client")!
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("subitem")!
        }
        
        cell.textLabel!.text = "Rich Industries"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "FOR"
        } else if(section == 1) {
            return "PROJECT"
        }
        return "TASKS"
    }

}
