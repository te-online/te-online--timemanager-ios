//
//  ProjectEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 15.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol ProjectEditDelegate {
    func saveNewProject(name: ProjectEditController.Project)
}

class ProjectEditController: UIViewController {
    
    struct Project {
        var name: String!
    }
    
    var currentProject: Project!
    
    var delegate: ProjectEditDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentProject = Project(name: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Store the input to make it accessible to the unwind segues target controller.
        currentProject.name = (self.view.viewWithTag(5) as! UITextField).text!
        
        self.delegate?.saveNewProject(currentProject)
        
        super.viewWillDisappear(animated)
    }
}
