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
    
    func getJsonFromUrlWithFilter(filterType: filteringMethod, completionHandler: @escaping ((MovieList?, Error?) -> Void)) {
        let baseWithFilterTypeURL = baseURL + "movies?order_type=" + "\(filterType.rawValue)"
        guard let url = URL(string: baseWithFilterTypeURL) else { return }
        URLSession.shared.dataTask(with: url) { (datas, response, error) in
            if error != nil {
                print("Network Error")
            }
            
            guard let data = datas else {return}
            
            do {
                let order = try JSONDecoder().decode(MovieList.self, from: data)
                completionHandler(order, error)
            } catch {
                print("JSON Parising Error")
            }
        }.resume()
    }
    
    func getJsonFromUrlWithMoiveId(movieId: String, completionHandler: @escaping ((CommentList?, Error?) -> Void)) {
        let baseWithFilterTypeURL = baseURL + "comments?movie_id=" + "\(movieId)"
        
        guard let url = URL(string: baseWithFilterTypeURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (datas, response, error) in
            if error != nil {
                print("Network Error")
            }
            
            guard let data = datas else { return }
            
            do {
                let order = try JSONDecoder().decode(CommentList.self, from: data)
                
                completionHandler(order, error)
            } catch {
                print("JSON Parising Error")
            }
        }.resume()
    }
    
    func getJsonFromUrlMovieDetail(movieId: String, completionHandler: @escaping ((MovieDetail?, Error?) -> Void)) {
        let baseWithFilterTypeURL = baseURL + "movie?id=" + "\(movieId)"
        
        guard let url = URL(string: baseWithFilterTypeURL) else { return }
        
        URLSession.shared.dataTask(with: url) {(datas, response, error) in
            if error != nil {
                print("Network Error")
            }
            
            guard let data = datas else { return }
            
            do {
                let order = try JSONDecoder().decode(MovieDetail.self, from: data)
                completionHandler(order, error)
            } catch {
                print("JSON Parising Error")
            }
        }.resume()
    }
}
