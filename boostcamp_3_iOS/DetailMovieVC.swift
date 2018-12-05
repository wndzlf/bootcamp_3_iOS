//
//  DetailMovieViewController.swift
//  boostcamp_3_iOS
//
//  Created by admin on 05/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

struct detailMovie:Decodable {
    let audience:Int
    let actor:String
    let duration:Int
    let director: String
    let synopsis: String
    let genre:String
    let grade:Int
    let image:String
    let reservation_grade:Int
    let title:String
    let reservation_rate:Double
    let user_rating:Double
    let date:String
    let id:String
}

class DetailMovieVC: UIViewController {

    var navigationTitle: String?
    var id: String?
    var movie:detailMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        
        let url = "http://connect-boxoffice.run.goorm.io/movie?id=\(id!)"
        getJsonFromURL(getURL: url)
    }
    
    func setupNavigation() {
        navigationItem.title = navigationTitle
    }
    
    func getJsonFromURL(getURL: String) {
        
        guard let url = URL(string: getURL) else {return}
        
        URLSession.shared.dataTask(with: url) {[weak self] (datas, response, error) in
            guard let data = datas else {return}
            do{
                let detail = try JSONDecoder().decode(detailMovie.self, from: data)
                guard let `self` = self else {return}
                self.movie = detail
            }catch{
                print("Error")
            }
        }.resume()
    }

}
