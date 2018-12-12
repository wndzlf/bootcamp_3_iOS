//
//  MovieListAPI.swift
//  boostcamp_3_iOS
//
//  Created by admin on 12/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import Foundation
import UIKit

struct MovieListAPI:APIManager {
    //let baseURL = "http://connect-boxoffice.run.goorm.io/movies"
    //let baseURL = "http://connect-boxoffice.run.goorm.io/movies"
    static let shared = MovieListAPI()
    let baseURL = url("")
    
    func getJsonFromURL(filterType: filteringMethod,  completionHandler:@escaping ( (MovieList?, Error?) -> Void )) {
        let baseWithFilterTypeURL = baseURL+"\(filterType.rawValue)"
        guard let url = URL(string: baseWithFilterTypeURL) else {return}
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        URLSession.shared.dataTask(with: url) {(datas, response, error) in
            if error != nil {
                print("Network Error")
            }
            guard let data = datas else {return}
            
            do {
                let order = try JSONDecoder().decode(MovieList.self, from: data)
                completionHandler(order, error)
            }catch{
                print("JSON Parising Error")
            }
        }.resume()
    }
    

}
