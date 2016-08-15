//
//  ClientEditController.swift
//  TimeManager
//
//  Created by Thomas Ebert on 15.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit

protocol ClientEditDelegate {
    func saveNewClient(name: ClientEditController.Client)
}

class ClientEditController: UIViewController {
    
    struct Client {
        var name: String!
        var street: String!
        var postcode: String!
        var city: String!
        var note: String!
    }
    
    var currentClient: Client!
    
    var delegate: ClientEditDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentClient = Client(name: "", street: "", postcode: "", city: "", note: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Store the input to make it accessible to the unwind segues target controller.
        currentClient.name = (self.view.viewWithTag(5) as! UITextField).text!
        currentClient.street = (self.view.viewWithTag(6) as! UITextField).text!
        currentClient.postcode = (self.view.viewWithTag(7) as! UITextField).text!
        currentClient.city = (self.view.viewWithTag(8) as! UITextField).text!

        let textInput = (self.view.viewWithTag(9) as! UITextInput)
        let range: UITextRange = textInput.textRangeFromPosition(textInput.beginningOfDocument, toPosition: textInput.endOfDocument)!
        currentClient.note = textInput.textInRange(range)

        self.delegate?.saveNewClient(currentClient)
        
        super.viewWillDisappear(animated)
    }
}
