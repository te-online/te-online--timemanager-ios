//
//  ProjectDetailViewController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol ProjectDetailViewControllerDelegate {
    func deleteCurrentProject()
    func editCurrentProject()
}

class ProjectDetailViewController: UIViewController {
    
    var delegate: ProjectDetailViewControllerDelegate?
    
    @IBAction func EditButtonPressed(sender: AnyObject) {
        self.delegate?.editCurrentProject()
    }
    
    @IBAction func DeleteButtonPressed(sender: AnyObject) {
        self.delegate?.deleteCurrentProject()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
