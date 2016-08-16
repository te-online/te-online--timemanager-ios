//
//  TimeEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 16.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol TimeEditDelegate {
    func saveNewTime(time: TimeEditController.Time)
}

class TimeEditController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    struct Time {
        var start: NSDate!
        var end: NSDate!
        var note: String!
    }
    
    var currentTime: Time!
    var saveIntent = false
    
    var delegate: TimeEditDelegate?
    
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
        
        self.currentTime = Time(start: NSDate(), end: NSDate(), note: "")
        
        // Make buttons look nicely.
        DoneButtonTop.layer.borderColor = Colors.MediumBlue.CGColor
        DoneButtonBottom.layer.borderColor = Colors.MediumBlue.CGColor
        CancelButtonBottom.layer.borderColor = Colors.MediumRed.CGColor
        
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
        
        // Set up the client, project and taskname
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
            self.currentTime.end = self.currentTime.start.dateByAddingTimeInterval((duration * 60) as NSTimeInterval)
        
            self.delegate?.saveNewTime(self.currentTime)
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
