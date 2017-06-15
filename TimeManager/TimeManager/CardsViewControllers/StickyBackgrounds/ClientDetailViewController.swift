//
//  ProjectDetailsViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 12.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol ClientDetailViewControllerDelegate {
    func deleteCurrentClient()
//    var currentClient: ClientObject
}

class ClientDetailViewController: UIViewController {
    
    var delegate: ClientDetailViewControllerDelegate?
    var currentClient: ClientObject!
    
    @IBAction func EditButtonPressed(_ sender: AnyObject) {
        // Do nothing. Segue does the rest.
    }
    
    @IBAction func DeleteButtonPressed(_ sender: AnyObject) {
        self.delegate?.deleteCurrentClient()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass over the correct data for the correct segue.
        if segue.identifier == "editClient" {
            (segue.destination as! ClientEditController).editDelegate = (self.delegate as! ProjectsViewController)
            (segue.destination as! ClientEditController).editClientObject = (self.delegate as! ProjectsViewController).currentClient
        }
        if segue.identifier == "newProject" {
            (segue.destination as! ProjectEditController).currentClientObject = (self.delegate as! ProjectsViewController).currentClient
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
