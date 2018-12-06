//
//  DetailMovieViewController.swift
//  boostcamp_3_iOS
//
//  Created by admin on 05/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

struct superoneLine: Decodable {
    let comments: [oneLine]
    let moive_id: String
}

struct oneLine: Decodable {
    let rating:Double
    let timestamp:Double
    let writer: String
    let movie_id: String
    let contents: String
}

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
    
    var id: String?
    var movie:detailMovie?
    var navigationTitle: String?
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var genre: UILabel!
    @IBOutlet var reservation_rate: UILabel!
    @IBOutlet var user_rating: UILabel!
    @IBOutlet var audience: UILabel!
    @IBOutlet var synopsis: UITextView!
    @IBOutlet var director: UILabel!
    @IBOutlet var actor: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        let url = "http://connect-boxoffice.run.goorm.io/movie?id=\(id!)"
        getJsonFromURL(getURL: url)
        
        let commmentsURL = "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(id!)"
        print(commmentsURL)
        getJsonFromCommentURL(getURL: commmentsURL)
    }
    
    func setupNavigation() {
        navigationItem.title = navigationTitle
    }
    
    func getJsonFromCommentURL(getURL: String) {
        guard let url = URL(string: getURL) else {return}
        
        URLSession.shared.dataTask(with: url) { [weak self] (datas, response, error) in
            
            guard let data = datas else {return}
            
            do{
                let one = try JSONDecoder().decode(superoneLine.self, from: data)
                print("one")
                print(one)
                guard let `self` = self else {return}
                
                print(one)
            }catch{
                print("error")
            }
        }.resume()
    }
    
    func getJsonFromURL(getURL: String) {
        guard let url = URL(string: getURL) else {return}
        
        URLSession.shared.dataTask(with: url) { [weak self] (datas, response, error) in
            guard let data = datas else {return}
            
            do{
                let detail = try JSONDecoder().decode(detailMovie.self, from: data)
                
                guard let `self` = self else {return}
                self.movie = detail
                
                DispatchQueue.global().async {
                    let imageURL = URL(string: detail.image)!
                    DispatchQueue.main.async {
                        guard let selectMovie = self.movie else {return}
                        self.movieTitle.text = selectMovie.title
                        self.date.text = selectMovie.date
                        self.genre.text = selectMovie.genre
                        self.reservation_rate.text = "\(String(describing: selectMovie.reservation_rate))"
                        self.user_rating.text = "\(String(describing: selectMovie.user_rating))"
                        self.image.load(url: imageURL)
                        self.audience.text = "\(String(describing: selectMovie.audience))"
                        self.synopsis.text = selectMovie.synopsis
                        self.director.text = selectMovie.director
                        self.actor.text = selectMovie.actor
                    }
                }
            }catch{
                print("Error")
            }
        }.resume()
        
    }

}
