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
    var saveIntent = false
    
    var delegate: ProjectEditDelegate?
    
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
        
        currentProject = Project(name: "")
        
        // Make buttons look nicely.
        DoneButtonTop.layer.borderColor = Colors.MediumBlue.CGColor
        DoneButtonBottom.layer.borderColor = Colors.MediumBlue.CGColor
        CancelButtonBottom.layer.borderColor = Colors.MediumRed.CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if(self.saveIntent) {
            // Store the input to make it accessible to the unwind segues target controller.
            currentProject.name = NameInputField.text!
        
            self.delegate?.saveNewProject(currentProject)
        }
        
        super.viewWillDisappear(animated)
    }
}
