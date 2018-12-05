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
    
    @IBAction func flteringButton(_ sender: Any) {
        print("asdgasdgasdg")
        let actionSheet = UIAlertController(title: "정렬 방식 선택", message:"영화를 어떤 방식으로 정렬할까요?", preferredStyle: .actionSheet)
        
        let reservationRate = UIAlertAction(title: "예매율", style: .default) { [weak self] (action) in
            
            guard let `self` = self else {return}
            
            let sorted = self.movies.sorted(by: { $0.reservation_rate > $1.reservation_rate })
            self.movies = sorted
            self.tableview.reloadData()
        }
        let quaration = UIAlertAction(title: "큐레이션", style: .default) { (action) in
            
        }
        let openTime = UIAlertAction(title: "개봉일", style: .default) { (action) in
            
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel) { (action) in
            
        }
        
        actionSheet.addAction(reservationRate)
        actionSheet.addAction(quaration)
        actionSheet.addAction(openTime)
        actionSheet.addAction(cancle)
        
        self.present(actionSheet, animated: true, completion: nil)
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

extension ViewController: UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! tableviewCell
        let movie = movies[indexPath.row]
        
        //date는 formatt형식 바꾸기
        cell.movieDate.text = "개봉일: \(movie.date)"
        cell.movieReserRate.text = "예매율:\(movie.reservation_rate)"
        cell.movieGrade.text = "예매순위:\(movie.reservation_grade)"
        cell.movieRate.text = "평점:\(movie.user_rating)"
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
//GCD개념 숙지
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

