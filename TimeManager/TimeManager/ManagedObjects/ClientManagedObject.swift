//
//  ClientManagedObject.swift
//  TimeManager
//
//  Created by Thomas Ebert on 15.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class Client: NSManagedObject {
    
    @NSManaged var name: String?
    
}