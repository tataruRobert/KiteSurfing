//
//  File.swift
//  KiteSurfing
//
//  Created by Tataru Robert on 03/04/2019.
//  Copyright © 2019 Tataru Robert. All rights reserved.
//

import Foundation

struct Country {
    let country : String
    init(json: String)  {
        self.country = json
    }

    static let basePath = "https://internship-2019.herokuapp.com"

    static func getCountries ( completion: @escaping ([Country]) -> ()) {
        let url = basePath + "/api-spot-get-countries"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //print(token)
        request.addValue("OatadvnKQA", forHTTPHeaderField: "Token")
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
            var Countries:[Country] = []
            do {
                guard let receivedJson = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                print("Could not get JSON from responseData as dictionary")
                return
                }

                if let results = receivedJson["result"] as? [String] {
                    for dataPoint in results {
                        Countries.append(Country(json: dataPoint))
                    }
                }
            } catch  {
                print("error parsing response from POST")
                return
            }
            completion(Countries)
        }
        task.resume()
    }


}
