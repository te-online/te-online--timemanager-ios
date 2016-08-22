//
//  SettingsController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 09.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var Colors = SharedColorPalette.sharedInstance
    
    var WeekDays = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    var currentStartWeekWithSelection: Int!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var DoneButtonTop: UIButton!
    @IBOutlet weak var DoneButtonBottom: UIButton!
    @IBOutlet weak var CancelButtonBottom: UIButton!
    
    @IBOutlet weak var StartWeekWithPickerView: UIPickerView!
    @IBOutlet weak var CloudSyncServerInputField: UITextField!
    @IBOutlet weak var CloudSyncUserInputField: UITextField!
    @IBOutlet weak var CloudSyncPasswordInputField: UITextField!
    
    @IBAction func DoneButtonTopPressed(sender: AnyObject) {
        self.saveSettings()
    }
    
    @IBAction func DoneButtonBottomPressed(sender: AnyObject) {
        self.saveSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.DoneButtonTop.layer.borderColor = self.Colors.MediumBlue.CGColor
        self.DoneButtonBottom.layer.borderColor = self.Colors.MediumBlue.CGColor
        self.CancelButtonBottom.layer.borderColor = self.Colors.MediumRed.CGColor
        
        self.StartWeekWithPickerView.dataSource = self
        self.StartWeekWithPickerView.delegate = self

        if self.defaults.integerForKey("startWeekWith") == 0 {
            self.currentStartWeekWithSelection = 3
        } else {
            self.currentStartWeekWithSelection = self.defaults.integerForKey("startWeekWith") ?? 3
        }
        self.StartWeekWithPickerView.selectRow((self.currentStartWeekWithSelection-1), inComponent: 0, animated: true)
        
        self.CloudSyncServerInputField.text = self.defaults.stringForKey("cloudSyncServer") ?? ""
        self.CloudSyncUserInputField.text = self.defaults.stringForKey("cloudSyncUser") ?? ""
        self.CloudSyncPasswordInputField.text = self.defaults.stringForKey("cloudSyncPassword") ?? ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.WeekDays.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.WeekDays[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentStartWeekWithSelection = row+1
    }
    
    func saveSettings() {
        self.defaults.setValue(self.currentStartWeekWithSelection, forKey: "startWeekWith")
        self.defaults.setValue(self.CloudSyncServerInputField.text, forKey: "cloudSyncServer")
        self.defaults.setValue(self.CloudSyncUserInputField.text, forKey: "cloudSyncUser")
        self.defaults.setValue(self.CloudSyncPasswordInputField.text, forKey: "cloudSyncPassword")
        
        // Sync on saving settings.
        (UIApplication.sharedApplication().delegate as! AppDelegate).syncInBackground({})
    }
    
}

