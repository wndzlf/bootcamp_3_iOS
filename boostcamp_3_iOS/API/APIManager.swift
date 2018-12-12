//
//  APIManager.swift
//  boostcamp_3_iOS
//
//  Created by admin on 12/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

protocol APIManager {}

extension APIManager {
    static func url(_ path: String) -> String {
        return "http://connect-boxoffice.run.goorm.io/" + path
    }
}
