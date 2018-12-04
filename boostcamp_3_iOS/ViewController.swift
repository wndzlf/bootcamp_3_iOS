//
//  ViewController.swift
//  boostcamp_3_iOS
//
//  Created by admin on 04/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit
struct orderType:Decodable {
    let order_type: Int
    let movies: [movie]
}

struct movie: Decodable {
    let date: String
    let reservation_rate: Double
    let reservation_grade: Int
    let user_rating: Double
    let thumb: String
    let title: String
    let id : String
    let grade : Int
}

class ViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    
    var movies = [movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "예매율순"
        
        tableview.dataSource = self
        tableview.delegate = self
        
        getJsonFromURL()
    }
    
    func getJsonFromURL() {
        guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movies") else {return}
        
        URLSession.shared.dataTask(with: url) { (datas, response, error) in
            guard let data = datas else {return}
            do {
                let order = try JSONDecoder().decode(orderType.self, from: data)
                self.movies = order.movies
                
            }catch{
                print("Error")
            }
        }.resume()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! tableviewCell
        cell.movieTitle.text = movies[indexPath.row].title
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
}

