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
        
        let url = "http://connect-boxoffice.run.goorm.io/movies"
        getJsonFromURL(getURL: url)
    }
    
    @IBAction func flteringButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: "정렬 방식 선택", message:"영화를 어떤 방식으로 정렬할까요?", preferredStyle: .actionSheet)
        
        //예매율 , 큐레이션, 개봉일 정렬
        let reservationRate = UIAlertAction(title: "예매율", style: .default) { [weak self] (action) in
            guard let `self` = self else {return}
            
            let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=0"
            self.getJsonFromURL(getURL: url)
        }
        let quaration = UIAlertAction(title: "큐레이션", style: .default) { [weak self](action) in
            guard let `self` = self else {return}
            
            let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=1"
            self.getJsonFromURL(getURL: url)
        }
        let openTime = UIAlertAction(title: "개봉일", style: .default) { [weak self] (action) in
            guard let `self` = self else {return}
            
            let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=2"
            self.getJsonFromURL(getURL: url)
        }
        
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        
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
    
    func getJsonFromURL(getURL: String) {
        guard let url = URL(string: getURL) else {return}
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailmoiveVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailMovie") as! DetailMovieVC
        
        let backButton = UIBarButtonItem.init(title: "영화목록", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        detailmoiveVC.navigationTitle = movies[indexPath.row].title
        detailmoiveVC.id = movies[indexPath.row].id
        self.navigationController?.pushViewController(detailmoiveVC, animated: true)
        
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

