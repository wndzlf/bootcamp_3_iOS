//
//  movie.swift
//  boostcamp_3_iOS
//
//  Created by admin on 05/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import Foundation

struct MovieList:Decodable {
    let order_type: Int
    let movies: [Movie]
}

struct Movie: Decodable {
    let date: String
    let reservation_rate: Double
    let reservation_grade: Int
    let user_rating: Double
    let thumb: String
    let title: String
    let id : String
    let grade : Int
}
