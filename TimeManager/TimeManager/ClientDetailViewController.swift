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
    func editCurrentClient()
}

class ClientDetailViewController: UIViewController {
    
    var delegate: ClientDetailViewControllerDelegate?
    
    @IBAction func EditButtonPressed(sender: AnyObject) {
//        NSLog("Client would be edited now")
        self.delegate?.editCurrentClient()
    }
    
    @IBAction func DeleteButtonPressed(sender: AnyObject) {
//        NSLog("Client would be deleted now")
        self.delegate?.deleteCurrentClient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}