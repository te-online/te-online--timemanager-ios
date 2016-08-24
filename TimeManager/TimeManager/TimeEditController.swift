//
//  TimeEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol TimeCreateDelegate {
    func saveNewTime(time: TimeEditController.Time)
}

protocol TimeEditDelegate {
    func editTime(time: TimeEditController.Time)
}

class TimeEditController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    struct Time {
        var start: NSDate!
        var end: NSDate!
        var note: String!
        var object: TimeObject!
    }
    
    var currentTime: Time!
    var editTimeObject: TimeObject!
    var currentTaskObject: TaskObject!
    var saveIntent = false
    
    var createDelegate: TimeCreateDelegate?
    var editDelegate: TimeEditDelegate?
    
    var PickerDurations = [String]()
    var currentDuration = ""
    
    var Colors = SharedColorPalette.sharedInstance
    
    @IBOutlet weak var DurationPickerView: UIPickerView!
    @IBOutlet weak var StartPickerView: UIDatePicker!
    @IBOutlet weak var NoteInputField: UITextView!
    
    @IBOutlet weak var ModalTitleLabel: UILabel!
    @IBOutlet weak var ContextInfoLabel: UILabel!
    
    @IBOutlet weak var CancelButtonBottom: UIButton!
    @IBOutlet weak var DoneButtonBottom: UIButton!
    @IBOutlet weak var DoneButtonTop: UIButton!
    
    @IBAction func DoneButtonTopPressed(sender: AnyObject) {
        self.saveIntent = true
    }
    
    @IBAction func DoneButtonBottomPressed(sender: AnyObject) {
        self.saveIntent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentTime = Time(start: NSDate(), end: NSDate(), note: "", object: nil)
        
        // Make buttons look nicely.
        DoneButtonTop.layer.borderColor = Colors.MediumBlue.CGColor
        DoneButtonBottom.layer.borderColor = Colors.MediumBlue.CGColor
        CancelButtonBottom.layer.borderColor = Colors.MediumRed.CGColor
        
        // Add border to textview.
        NoteInputField.layer.borderWidth = 1.0
        NoteInputField.layer.borderColor = Colors.LightGrey.CGColor
        NoteInputField.layer.cornerRadius = 4.0
        
        // Add durations to duration slider.
        for i in 0...12 {
            if i > 0 {
                PickerDurations.append(String(i))
            }
            PickerDurations.append(String(i) + ".25")
            PickerDurations.append(String(i) + ".5")
            PickerDurations.append(String(i) + ".75")
        }
        DurationPickerView.dataSource = self
        DurationPickerView.delegate = self
        
        currentDuration = PickerDurations.first!
        
        // Give some orientation, where the user is.
        if self.currentTaskObject != nil {
            ContextInfoLabel.text = String(format: "%@ > %@ > %@", self.currentTaskObject.project!.client!.name!, self.currentTaskObject.project!.name!, self.currentTaskObject!.name!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.editDelegate != nil {
            self.editTimeObject = (self.editDelegate as! TimesViewController).getCurrentTime()
        }
        
        if self.editTimeObject != nil {
            NoteInputField.text = self.editTimeObject.note
            
            // Set the date picker view.
            StartPickerView.setDate(self.editTimeObject.start!, animated: false)
            
            // Set the hours picker view.
            let num = self.PickerDurations.indexOf(String(format: "%g", self.editTimeObject.getDurationInHours()))
            if num != nil  {
                DurationPickerView.selectRow(num!, inComponent: 0, animated: false)
            }
            
            // Rename buttons.
            DoneButtonTop.setTitle("Update", forState: .Normal)
            DoneButtonBottom.setTitle("Update", forState: .Normal)
            
            // Change caption.
            ModalTitleLabel.text = "Edit time entry".uppercaseString
        }
        
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.saveIntent {
            // Store the input to make it accessible to the unwind segues target controller.
            let range: UITextRange = NoteInputField.textRangeFromPosition(NoteInputField.beginningOfDocument, toPosition: NoteInputField.endOfDocument)!
            self.currentTime.note = NoteInputField.textInRange(range)
        
            self.currentTime.start = StartPickerView.date
        
            let duration: Double = Double(self.currentDuration)!
            self.currentTime.end = self.currentTime.start.dateByAddingTimeInterval((duration * 60 * 60) as NSTimeInterval)
        
            if self.editTimeObject != nil {
                self.currentTime.object = self.editTimeObject
                self.editDelegate?.editTime(self.currentTime)
            } else {
                self.createDelegate?.saveNewTime(self.currentTime)
            }
        }
        
        super.viewWillDisappear(animated)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickerDurations.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PickerDurations[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentDuration = PickerDurations[row]
    }
    
}
