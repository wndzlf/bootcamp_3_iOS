//
//  detailMovie.swift
//  boostcamp_3_iOS
//
//  Created by admin on 07/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import Foundation

struct MovieDetail: Decodable {
    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int
    let image: String
    let reservation_grade: Int
    let title: String
    let reservation_rate: Double
    let user_rating: Double
    let date: String
    let id: String
}
