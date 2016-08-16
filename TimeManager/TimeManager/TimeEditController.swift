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

class TimeEditController: UIViewController {
    
    struct Time {
        var name: String!
        var start: NSDate!
        var end: NSDate!
        var note: String!
    }
    
    var currentTime: Time!
    
    var delegate: TimeEditDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentTime = Time(name: "", start: NSDate(), end: NSDate(), note: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Store the input to make it accessible to the unwind segues target controller.
        let textInput = (self.view.viewWithTag(9) as! UITextInput)
        let range: UITextRange = textInput.textRangeFromPosition(textInput.beginningOfDocument, toPosition: textInput.endOfDocument)!
        self.currentTime.note = textInput.textInRange(range)
        
        self.currentTime.start = (self.view.viewWithTag(4) as! UIDatePicker).date
        
        
        self.delegate?.saveNewTime(self.currentTime)
        
        super.viewWillDisappear(animated)
    }
}
