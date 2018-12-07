//
//  DetailMovieViewController.swift
//  boostcamp_3_iOS
//
//  Created by admin on 05/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

struct oneLine: Decodable {
    let rating:Double
    let timestamp:Double
    let writer: String
    let movie_id: String
    let contents: String
}

struct superoneLine: Decodable {
    let comments: [oneLine]
    let movie_id: String
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
    
    @IBOutlet var tableView: UITableView!
    
    var comments = [oneLine]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        let url = "http://connect-boxoffice.run.goorm.io/movie?id=\(id!)"
        getJsonFromURL(getURL: url)
        
        let commmentsURL = "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(id!)"
        getJsonFromCommentURL(getURL: commmentsURL)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigation() {
        navigationItem.title = navigationTitle
    }
    
    func getJsonFromCommentURL(getURL: String) {
        guard let url = URL(string: getURL) else {return}
        
        URLSession.shared.dataTask(with: url) { [weak self] (datas, response, error) in
            guard let data = datas else {return}
            guard let `self` = self else {return}
            do{
                let one = try JSONDecoder().decode(superoneLine.self, from: data)
                self.comments = one.comments
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print("Error")
            }
        }.resume()
        
    }
}

extension DetailMovieVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }else if indexPath.section == 1{
            return 120
        }else {
            return 60
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = .lightGray
        return label
    }
    
}

extension DetailMovieVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else {
            return self.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellId") as! posterCell
            if let movie = self.movie {
                cell.title.text = movie.title
                cell.date.text = movie.date
                cell.genre.text = movie.genre
                cell.reservation_rate.text = "\(movie.reservation_rate)"
                cell.user_rating.text = "\(movie.user_rating)"
                cell.audience.text = "\(movie.audience)"
            }
            return cell
        }else if indexPath.section == 1{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellId1") as! contentsCell
            cell.content.text = self.movie?.synopsis
            return cell
        }else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellId2") as! commentCell
            
            let comment = self.comments[indexPath.row]
            cell.writer.text = comment.writer
            cell.rating.text = "\(comment.rating)"
            cell.timestamp.text = "\(comment.timestamp)"
            cell.contents.text = comment.contents
            return cell
        }
        
    }
}
