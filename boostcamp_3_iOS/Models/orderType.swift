//
//  ordertype.swift
//  boostcamp_3_iOS
//
//  Created by admin on 05/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import Foundation

struct orderType:Decodable {
    let order_type: Int
    let movies: [movie]
}
