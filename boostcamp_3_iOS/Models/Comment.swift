//
//  oneLine.swift
//  boostcamp_3_iOS
//
//  Created by admin on 07/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import Foundation

struct CommentList: Decodable {
    let comments: [Comment]
    let movie_id: String
}

struct Comment: Decodable {
    let rating: Double
    let timestamp: Double
    let writer: String
    let movie_id: String
    let contents: String
}
