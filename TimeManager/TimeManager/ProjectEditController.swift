//
//  ProjectEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 15.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol ProjectCreateDelegate {
    func saveNewProject(name: ProjectEditController.Project)
}

protocol ProjectEditDelegate {
    func editProject(project: ProjectEditController.Project)
}

class ProjectEditController: UIViewController {
    
    struct Project {
        var name: String!
        var object: ProjectObject!
    }
    
    var currentProject: Project!
    var editProjectObject: ProjectObject!
    var currentClientObject: ClientObject!
    var saveIntent = false
    
    var createDelegate: ProjectCreateDelegate?
    var editDelegate: ProjectEditDelegate?
    
    var Colors = SharedColorPalette.sharedInstance
    
    @IBOutlet weak var DoneButtonTop: UIButton!
    @IBOutlet weak var DoneButtonBottom: UIButton!
    @IBOutlet weak var CancelButtonBottom: UIButton!
    
    @IBOutlet weak var NameInputField: UITextField!
    @IBOutlet weak var ModalTitleLabel: UILabel!
    @IBOutlet weak var ContextInfoLabel: UILabel!
    
    @IBAction func DoneButtonBottomPressed(sender: AnyObject) {
        self.saveIntent = true
    }
    
    @IBAction func DoneButtonTopPressed(sender: AnyObject) {
        self.saveIntent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentProject = Project(name: "", object: nil)
        
        // Make buttons look nicely.
        DoneButtonTop.layer.borderColor = Colors.MediumBlue.CGColor
        DoneButtonBottom.layer.borderColor = Colors.MediumBlue.CGColor
        CancelButtonBottom.layer.borderColor = Colors.MediumRed.CGColor
        
        if self.editProjectObject != nil {
            // Put data into the fields.
            NameInputField.text = self.editProjectObject.name
            
            // Rename buttons.
            DoneButtonTop.setTitle("Update", forState: .Normal)
            DoneButtonBottom.setTitle("Update", forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if(self.saveIntent) {
            // Store the input to make it accessible to the unwind segues target controller.
            currentProject.name = NameInputField.text!
        
            if self.editProjectObject != nil {
                currentProject.object = self.editProjectObject
                self.editDelegate?.editProject(currentProject)
            } else {
                self.createDelegate?.saveNewProject(currentProject)
            }
            
        }
        
        super.viewWillDisappear(animated)
    }
}
