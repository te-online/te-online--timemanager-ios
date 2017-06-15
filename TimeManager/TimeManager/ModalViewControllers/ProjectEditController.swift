//
//  ProjectEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 15.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol ProjectCreateDelegate {
    func saveNewProject(_ name: ProjectEditController.Project)
}

protocol ProjectEditDelegate {
    func editProject(_ project: ProjectEditController.Project)
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
    
    @IBAction func DoneButtonBottomPressed(_ sender: AnyObject) {
        self.saveIntent = true
    }
    
    @IBAction func DoneButtonTopPressed(_ sender: AnyObject) {
        self.saveIntent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentProject = Project(name: "", object: nil)
        
        // Make buttons look nicely.
        DoneButtonTop.layer.borderColor = Colors.MediumBlue.cgColor
        DoneButtonBottom.layer.borderColor = Colors.MediumBlue.cgColor
        CancelButtonBottom.layer.borderColor = Colors.MediumRed.cgColor
        
        if self.editProjectObject != nil {
            // Put data into the fields.
            NameInputField.text = self.editProjectObject.name
            
            // Rename buttons.
            DoneButtonTop.setTitle("Update", for: UIControlState())
            DoneButtonBottom.setTitle("Update", for: UIControlState())
            
            // Change caption.
            ModalTitleLabel.text = "Edit project".uppercased()
        }
        
        // Give some orientation, where the user is.
        if self.currentClientObject != nil {
            ContextInfoLabel.text =  self.currentClientObject.name!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
