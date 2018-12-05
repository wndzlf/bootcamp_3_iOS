//
//  ViewController.swift
//  boostcamp_3_iOS
//
//  Created by admin on 04/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet var tableview: UITableView!
    var movies = [movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        setupNavigation()
        getJsonFromURL()
    }
    
    func setupNavigation() {
        navigationItem.title = "예매율순"
        let barColor = UIColor(red:0.47, green:0.42, blue:0.91, alpha:1.0)
        navigationController?.navigationBar.barTintColor = barColor
    }
    
    func getJsonFromURL() {
        guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movies") else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (datas, response, error) in
            guard let data = datas else {return}
            do {
                let order = try JSONDecoder().decode(orderType.self, from: data)
                guard let `self` = self else {return}
                self.movies = order.movies
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }catch{
                print("Error")
            }
            
        }.resume()
    }
}

extension ViewController: UITableViewDataSource, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("Download finished: \(location)")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(movies.count)
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! tableviewCell
        let movie = movies[indexPath.row]
        //date는 formatt형식 바꾸기
        cell.movieDate.text = "개봉일: \(movie.date)"
        cell.movieReserRate.text = "\(movie.reservation_rate)"
        cell.movieGrade.text = "\(movie.reservation_grade)"
        cell.movieRate.text = "\(movie.user_rating)"
        cell.movieTitle.text = movie.title
        
        //download in background
        let imageURL = URL(string: movie.thumb)!
        cell.movieImage.load(url: imageURL)
    
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

//https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
//GCD에 대해 공부하자
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

