//
//  TaskEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol TaskCreateDelegate {
    func saveNewTask(_ task: TaskEditController.Task)
}
protocol TaskEditDelegate {
    func editTask(_ task: TaskEditController.Task)
}

class TaskEditController: UIViewController {
    
    struct Task {
        var name: String!
        var object: TaskObject!
    }
    
    var currentTask: Task!
    var editTaskObject: TaskObject!
    var currentProjectObject: ProjectObject!
    var saveIntent = false
    
    var createDelegate: TaskCreateDelegate?
    var editDelegate: TaskEditDelegate?
    
    var Colors = SharedColorPalette.sharedInstance
    
    @IBOutlet weak var NameInputField: UITextField!
    @IBOutlet weak var ContextInfoLabel: UILabel!
    @IBOutlet weak var ModalTitleLabel: UILabel!
    
    @IBOutlet weak var DoneButtonTop: UIButton!
    @IBOutlet weak var DoneButtonBottom: UIButton!
    @IBOutlet weak var CancelButtonBottom: UIButton!
    
    @IBAction func DoneButtonBottomPressed(_ sender: AnyObject) {
        self.saveIntent = true
    }
    
    @IBAction func DoneButtonTopPressed(_ sender: AnyObject) {
        self.saveIntent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentTask = Task(name: "", object: nil)
        
        // Make buttons look nicely.
        DoneButtonTop.layer.borderColor = Colors.MediumBlue.cgColor
        DoneButtonBottom.layer.borderColor = Colors.MediumBlue.cgColor
        CancelButtonBottom.layer.borderColor = Colors.MediumRed.cgColor
        
        if self.editTaskObject != nil {
            // Put data into the fields.
            NameInputField.text = self.editTaskObject.name
            
            // Rename buttons.
            DoneButtonTop.setTitle("Update", for: UIControlState())
            DoneButtonBottom.setTitle("Update", for: UIControlState())
            
            // Change caption.
            ModalTitleLabel.text = "Edit task".uppercased()
        }
        
        // Give some orientation, where the user is.
        if self.currentProjectObject != nil {
            ContextInfoLabel.text = String(format: "%@ > %@", self.currentProjectObject.client!.name!, self.currentProjectObject!.name!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.saveIntent {
            // Store the input to make it accessible to the unwind segues target controller.
            self.currentTask.name = NameInputField.text!
            
            if self.editTaskObject != nil {
                self.currentTask.object = self.editTaskObject
                self.editDelegate?.editTask(self.currentTask)
            } else {
                self.createDelegate?.saveNewTask(self.currentTask)
            }
            
        }
        
        super.viewWillDisappear(animated)
    }
}
