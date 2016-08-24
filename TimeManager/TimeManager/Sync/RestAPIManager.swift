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
        // If the service URL is our debug URL, don't use https, otherwise we should and must.
        self.serviceUrl = defaults.stringForKey("cloudSyncServer") ?? ""
        if(self.serviceUrl == "localhost:4444") {
            self.baseURL = "http://" + self.serviceUrl + "/api/updateObjects"
        } else {
            self.baseURL = "https://" + self.serviceUrl + "/api/updateObjects"
        }
    }
    
    func sendUpdateRequest(body: [String: AnyObject], onCompletion: (JSON) -> Void) {
        let route = baseURL
        // Send a request to the backend API with our body contents.
        makeHTTPPostRequest(route, body: body, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    // MARK: Perform a GET Request (not in use.)
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
            // If we have a username and password, use it.
            if user != nil && pass != nil && !(user?.isEmpty)! && !(user?.isEmpty)! {
                // We need an auth string in the format of user:pass
                let userPasswordString = String(format: "%@:%@", user!, pass!)
                // Base64 encode the credentials.
                let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
                let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions([])
                // Prepend the correct method.
                let authString = "Basic \(base64EncodedCredential)"
                // Add credentials to request.
                request.setValue(authString, forHTTPHeaderField: "Authorization")
            }            
            
            // Add the json type header.
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