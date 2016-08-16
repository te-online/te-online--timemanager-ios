//
//  TaskEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol TaskEditDelegate {
    func saveNewTask(task: TaskEditController.Task)
}

class TaskEditController: UIViewController {
    
    struct Task {
        var name: String!
    }
    
    var currentTask: Task!
    var saveIntent = false
    
    var delegate: TaskEditDelegate?
    
    var Colors = SharedColorPalette.sharedInstance
    
    @IBOutlet weak var NameInputField: UITextField!
    @IBOutlet weak var ContextInfoLabel: UILabel!
    @IBOutlet weak var ModalTitleLabel: UILabel!
    
    @IBOutlet weak var DoneButtonTop: UIButton!
    @IBOutlet weak var DoneButtonBottom: UIButton!
    @IBOutlet weak var CancelButtonBottom: UIButton!
    
    @IBAction func DoneButtonBottomPressed(sender: AnyObject) {
        self.saveIntent = true
    }
    
    @IBAction func DoneButtonTopPressed(sender: AnyObject) {
        self.saveIntent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentTask = Task(name: "")
        
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
        if self.saveIntent {
            // Store the input to make it accessible to the unwind segues target controller.
            self.currentTask.name = NameInputField.text!
            
            self.delegate?.saveNewTask(self.currentTask)
        }
        
        super.viewWillDisappear(animated)
    }
}
