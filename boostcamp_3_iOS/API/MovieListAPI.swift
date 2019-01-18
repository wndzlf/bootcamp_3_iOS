//
//  MovieListAPI.swift
//  boostcamp_3_iOS
//
//  Created by admin on 12/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import Foundation
import UIKit

struct MovieListAPI: APIManager {
    static let shared = MovieListAPI()
    private init(){}
    
    var baseURL = url("")
    
    func getJsonFromUrl<DataType: Decodable>(_ urlString: String, completionHandler: @escaping ((DataType?, Error?) -> Void)) {
        guard let url = URL(string: baseURL + urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {(datas, response, error) in
            if error != nil {
                print("Network Error")
                return
            }
            
            guard let data = datas else { return }
            
            do {
                let order = try JSONDecoder().decode(DataType.self, from: data)
                completionHandler(order, error)
            } catch {
                print("JSON Parising Error")
            }
        }.resume()
    }

}
