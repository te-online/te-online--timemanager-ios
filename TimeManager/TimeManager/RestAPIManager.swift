//
//  RestAPIManager.swift
//  TimeManager
//
//  Created by Thomas Ebert on 17.08.16.
//  Copyright © 2016 Thomas Ebert, te-online.net. All rights reserved.
//

import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var serviceUrl = ""
    var baseURL = ""
    
    override init() {
        self.serviceUrl = defaults.stringForKey("cloudSyncServer") ?? ""
        if(self.serviceUrl == "localhost:4444") {
            self.baseURL = "http://" + self.serviceUrl + "/api/updateObjects"
        } else {
            self.baseURL = "https://" + self.serviceUrl + "/api/updateObjects"
        }
    }
    
    func sendUpdateRequest(body: [String: AnyObject], onCompletion: (JSON) -> Void) {
        let route = baseURL
        makeHTTPPostRequest(route, body: body, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    // MARK: Perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
    
    // MARK: Perform a POST Request
    private func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        
        do {
            // Set the POST body for the request.
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: [])
            request.HTTPBody = jsonBody
            
            // Prepare the authentication parameters.
            let user = defaults.stringForKey("cloudSyncUser")
            let pass = defaults.stringForKey("cloudSyncPassword")
            if user != nil && pass != nil && !(user?.isEmpty)! && !(user?.isEmpty)! {
                let userPasswordString = String(format: "%@:%@", user!, pass!)
                let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
                let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions([])
                let authString = "Basic \(base64EncodedCredential)"
                request.setValue(authString, forHTTPHeaderField: "Authorization")
                NSLog("Sending auth.")
            }
            
            
            // Add the type header.
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Initiate the session.
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil)
                } else {
                    onCompletion(nil, error)
                }
            })
            task.resume()
        } catch {
            // Create your personal error
            onCompletion(nil, nil)
        }
    }
}