//
//  ClientEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 15.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol ClientCreateDelegate {
    func saveNewClient(name: ClientEditController.Client)
}

protocol ClientEditDelegate {
    func editClient(client: ClientEditController.Client)
}

class ClientEditController: UIViewController {
    
    struct Client {
        var name: String!
        var street: String!
        var postcode: String!
        var city: String!
        var note: String!
        var object: ClientObject!
    }
    
    var currentClient: Client!
    var editClientObject: ClientObject!
    var saveIntent = false
    
    var createDelegate: ClientCreateDelegate?
    var editDelegate: ClientEditDelegate?
    
    var Colors = SharedColorPalette.sharedInstance
    
    @IBOutlet weak var DoneButtonTop: UIButton!
    @IBOutlet weak var DoneButtonBottom: UIButton!
    @IBOutlet weak var CancelButtonBottom: UIButton!
    
    @IBOutlet weak var ModalTitleLabel: UILabel!
    
    @IBOutlet weak var NameInputField: UITextField!
    @IBOutlet weak var StreetInputField: UITextField!
    @IBOutlet weak var PostcodeInputField: UITextField!
    @IBOutlet weak var CityInputField: UITextField!
    @IBOutlet weak var NoteInputField: UITextView!
    
    @IBAction func DoneButtonTopPressed(sender: AnyObject) {
        self.saveIntent = true
    }
    
    @IBAction func DoneButtonBottomPressed(sender: AnyObject) {
        self.saveIntent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentClient = Client(name: "", street: "", postcode: "", city: "", note: "", object: nil)
        
        // Make buttons look nicely.
        DoneButtonTop.layer.borderColor = Colors.MediumBlue.CGColor
        DoneButtonBottom.layer.borderColor = Colors.MediumBlue.CGColor
        CancelButtonBottom.layer.borderColor = Colors.MediumRed.CGColor
        
        if self.editClientObject != nil {
            // Put data into the fields.
            NameInputField.text = self.editClientObject.name
            StreetInputField.text = self.editClientObject.street
            PostcodeInputField.text = self.editClientObject.postcode
            CityInputField.text = self.editClientObject.city
            NoteInputField.text = self.editClientObject.note
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
            currentClient.name = NameInputField.text!
            currentClient.street = StreetInputField.text!
            currentClient.postcode = PostcodeInputField.text!
            currentClient.city = CityInputField.text!

            let range: UITextRange = NoteInputField.textRangeFromPosition(NoteInputField.beginningOfDocument, toPosition: NoteInputField.endOfDocument)!
            currentClient.note = NoteInputField.textInRange(range)
            
            if self.editClientObject != nil {
                currentClient.object = self.editClientObject
                self.editDelegate?.editClient(currentClient)
            } else {
                self.createDelegate?.saveNewClient(currentClient)
            }
        }
        
        super.viewWillDisappear(animated)
    }
}
