//
//  SpotDetails.swift
//  KiteSurfing
//
//  Created by Tataru Robert on 03/04/2019.
//  Copyright © 2019 Tataru Robert. All rights reserved.
//

import Foundation

struct SpotDetails {
    
    let id : String
    let name : String
    let longitude: Double
    let latitude : Double
    let windProbability: Int
    let country : String
    let whenToGo : String
    let isFavorite : Bool
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {
        
        guard let id = json["id"] as? String else {throw SerializationError.missing("id is missing")}
        
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name is missing")}
        
        guard let longitude = json["longitude"] as? Double else {
           
            throw SerializationError.missing("longitude is missing")
            
        }
        
        guard let latitude = json["latitude"] as? Double else {throw SerializationError.missing("latitude is missing")}
        
        guard let windProbability = json["windProbability"] as? Int else {throw SerializationError.missing("windProbability is missing")}
        
        guard let country = json["country"] as? String else {throw SerializationError.missing("country is missing")}
        
        guard let whenToGo = json["whenToGo"] as? String else {throw SerializationError.missing("whenToGo is missing")}
        
        guard let isFavorite = json["isFavorite"] as? Bool else {throw SerializationError.missing("isFavorite is missing")}
        
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.windProbability = windProbability
        self.country = country
        self.whenToGo = whenToGo
        self.isFavorite = isFavorite
        
        
    }
    
    
    static let basePath = "https://internship-2019.herokuapp.com"
    
    static func getDetails(spotId : String, completion: @escaping (SpotDetails?) -> ()) {
        let url = basePath + "/api-spot-get-details"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //print(token)
        request.addValue("OatadvnKQA", forHTTPHeaderField: "Token")
        
        let headerDictionary: [String: Any] = [ "spotId": "\(spotId)"]
       // print(spotId)
        let jsonSend: Data
        do {
            jsonSend = try JSONSerialization.data(withJSONObject: headerDictionary, options: [])
            request.httpBody = jsonSend
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            var SpotDetail: SpotDetails?
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedJson = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
                
                
                if let results = receivedJson["result"] as? [String:Any] {
                    print(results["longitude"] as Any)
                        if let spotDetailsObject = try? SpotDetails(json: results) {
                            SpotDetail = spotDetailsObject
                            print("ceva")
                            
                        }
                    
                }
                
                
                //print(errorMessage)
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
            completion(SpotDetail)
        }
        task.resume()
        
        
        
    }
    
}
