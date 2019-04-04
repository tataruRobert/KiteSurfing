//
//  Location.swift
//  KiteSurfing
//
//  Created by Tataru Robert on 02/04/2019.
//  Copyright © 2019 Tataru Robert. All rights reserved.
//

import Foundation

struct Location {
    let id : String
    let name : String
    let country : String
    let whenToGo : String
    var isFavorite : Bool
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {
        guard let id = json["id"] as? String else {throw SerializationError.missing("id is missing")}
        
        guard let name = json["name"] as? String else {throw SerializationError.missing("name is missing")}
        
        guard let country = json["country"] as? String else {throw SerializationError.missing("country is missing")}
        
        guard let whenToGo = json["whenToGo"] as? String else {throw SerializationError.missing("whenToGo is missing")}
        
        guard let isFavorite = json["isFavorite"] as? Bool else {throw SerializationError.missing("isFavorite is missing")}
        
        self.id = id
        self.name = name
        self.country = country
        self.whenToGo = whenToGo
        self.isFavorite = isFavorite
        
    }
    
    
    
    static let basePath = "https://internship-2019.herokuapp.com"
    static var token : String = ""
    
    static func start () {
        
        let url = basePath + "/api-user-get"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let email: [String: Any] = ["email": "robert.tataru98@gmail.com"]
        let jsonEmail: Data
        do {
            jsonEmail = try JSONSerialization.data(withJSONObject: email, options: [])
            request.httpBody = jsonEmail
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
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedJson = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
                
                
                if let results = receivedJson["result"] as? [String:Any] {
                    guard let Token = results["token"] as? String else {
                        print("Could not get todoID as int from JSON")
                        return
                    }
                    print("Token is: \(Token)")
                    token = Token
                    print("ceva")
                }
                
                
                //print(errorMessage)
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
        
        
    }
    
    static func getAll(wind: String, country : String, completion: @escaping ([Location]) -> ()) {
        let url = basePath + "/api-spot-get-all"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //print(token)
        request.addValue("OatadvnKQA", forHTTPHeaderField: "Token")
        let headerDictionary: [String: Any] = ["country": "\(country)", "windProbability": Int (wind) as Any]
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
            var Locations:[Location] = []
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedJson = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
                
                
                if let results = receivedJson["result"] as? [[String:Any]] {
                    for dataPoint in results {
                        if let locationObject = try? Location(json: dataPoint) {
                            Locations.append(locationObject)
                            
                        }
                    }
                }
                
                
                //print(errorMessage)
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
            completion(Locations)
        }
        task.resume()
        
        
        
    }
    static func addFavorite(spotId : String) {
        let url = basePath + "/api-spot-favorites-add"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //print(token)
        request.addValue("OatadvnKQA", forHTTPHeaderField: "Token")
        let headerDictionary: [String: Any] = ["spotId": "\(spotId)"]
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
           
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedJson = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
            
                
                
                //print(errorMessage)
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
            
        }
        task.resume()
        
        
        
    }
    static func removeFavorite(spotId : String) {
        let url = basePath + "/api-spot-favorites-remove"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //print(token)
        request.addValue("OatadvnKQA", forHTTPHeaderField: "Token")
        let headerDictionary: [String: Any] = ["spotId": "\(spotId)"]
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
            
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedJson = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
                
                
                
                //print(errorMessage)
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
            
        }
        task.resume()
        
        
        
    }
    
    
    
}
