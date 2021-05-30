//
//  SolarDataModel.swift
//  solarLogApp
//
//  Created by Holger Preu on 25.03.21.
//

import Foundation

protocol SolarDataProtocol {
    
    func solarDataRetrieved(_ data:Welcome)
}

class SolarDataModel {
    
    var delegate:SolarDataProtocol?
    
    func getSolarData() {
        
        // Fetch Solar Data
        // getLocalJsonFile()
        getRemoteJsonFile()
    }
    
    func getLocalJsonFile() {
        
        // Get the bundle path to json file
        let path = Bundle.main.path(forResource: "solarLogResponse", ofType: "json")
        
        // Double check that the path is not nil
        guard path != nil else {
            print("Could not find the json data file.")
            return
        }
        
        // Create URL object from the path
        let url = URL(fileURLWithPath: path!)
        
        // Get the data from the url
        do {
            let jsonData = try Data(contentsOf: url)
            
            // Try to decode data into objects
            let decoder = JSONDecoder()
            let welcome = try decoder.decode(Welcome.self, from: jsonData)
            
            let myData = welcome.the801.the170
            print(myData.consYieldMonth)
            
        }
        catch {
            // Error: could not download the data at the URL
            print("Error: could not download the data at the URL")
        }
    }
    
    func getRemoteJsonFile() {
        // Get a URL object
        let urlString = Constants.Network.url
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            print("Could not create the URL object")
            return
        }
        
        // Get a URL Session object
        let session = URLSession.shared
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Build the JSON query
        let jsonQuery: [String:Any] = ["801" : ["170" : nil]]
        
        // Serialize the array to JSON data
        var jsonTodo : Data
        
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: jsonQuery, options: [])
            
        }
        catch {
            print ("Cannot encode JSON")
            return
        }
        
        
        // Get a data task object
        let dataTask = session.uploadTask(with: request, from: jsonTodo) { (data, urlreponse, error) in
            
            // Check that there wasn't an error
            if error == nil && data != nil {
                do {
                    
                    // Create a JSON Decoder object
                    let decoder = JSONDecoder()
                    
                    // Parse the JSON
                    let myData = try decoder.decode(Welcome.self, from: data!)
                    
                    // TODO: Call delegate
                    DispatchQueue.main.async {
                        
                        // Notify the view controller
                        self.delegate?.solarDataRetrieved(myData)
                    }
                }
                
                catch {
                    print("Could not parse the JSON response")
                }
            }
        }
        
        // Call resume on the data task
        dataTask.resume()
    }
    
}
