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
    
    let defaults = UserDefaults.standard
    
    var serviceUrl = ""
    var baseURL = ""
    
    override init() {
        // If the service URL is our debug URL, don't use https, otherwise we should and must.
        self.serviceUrl = defaults.string(forKey: "cloudSyncServer") ?? ""
        if(self.serviceUrl == "localhost:4444") {
            self.baseURL = "http://" + self.serviceUrl + "/api/updateObjects"
        } else {
            self.baseURL = "https://" + self.serviceUrl + "/api/updateObjects"
        }
    }
    
    func sendUpdateRequest(_ body: [String: AnyObject], onCompletion: @escaping (JSON) -> Void) {
        let route = baseURL
        // Send a request to the backend API with our body contents.
        makeHTTPPostRequest(route, body: body, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    // MARK: Perform a GET Request (not in use.)
    fileprivate func makeHTTPGetRequest(_ path: String, onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error as NSError?)
            } else {
                onCompletion(JSON.null, error as NSError?)
            }
        })
        task.resume()
    }
    
    // MARK: Perform a POST Request
    fileprivate func makeHTTPPostRequest(_ path: String, body: [String: AnyObject], onCompletion: @escaping ServiceResponse) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        // Set the method to POST
        request.httpMethod = "POST"
        
        do {
            // Set the POST body for the request.
            let jsonBody = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonBody
            
            // Prepare the authentication parameters.
            let user = defaults.string(forKey: "cloudSyncUser")
            let pass = defaults.string(forKey: "cloudSyncPassword")
            // If we have a username and password, use it.
            if user != nil && pass != nil && !(user?.isEmpty)! && !(user?.isEmpty)! {
                // We need an auth string in the format of user:pass
                let userPasswordString = String(format: "%@:%@", user!, pass!)
                // Base64 encode the credentials.
                let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
                let base64EncodedCredential = userPasswordData!.base64EncodedString()
                // Prepend the correct method.
                let authString = "Basic \(base64EncodedCredential)"
                // Add credentials to request.
                request.setValue(authString, forHTTPHeaderField: "Authorization")
            }            
            
            // Add the json type header.
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Initiate the session.
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                if let jsonData = data {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil)
                } else {
                    onCompletion(JSON.null, error as NSError?)
                }
            })
            task.resume()
        } catch {
            // Create your personal error
            onCompletion(JSON.null, nil)
        }
    }
}
