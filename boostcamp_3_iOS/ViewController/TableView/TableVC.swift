//
//  ViewController.swift
//  boostcamp_3_iOS
//
//  Created by admin on 04/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class TableVC: UIViewController  {
    // Mark:- outlet
    @IBOutlet var tableview: UITableView!
    
    // Mark:- Property
    var movies = [Movie]()
    var filterType: filteringMethod?
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        guard let filterType = filteringMethod.init(rawValue: 0) else {return}
        fetchData(filterType)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFilter(_:)), name: Notification.Name(rawValue: "filtering"), object: nil)
    }
    
    func fetchData(_ filterType: filteringMethod) {
        MovieListAPI.shared.getJsonFromURL(filterType: filterType) { [weak self] (movieList, error) in
            guard let `self` = self else {return}
            guard let movieList = movieList else {return}
            self.movies = movieList.movies
            
            if error != nil {
                let alter = UIAlertController(title: "네트워크 장애", message: "네트워크 신호가 불안정 합니다.", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
    @objc func refreshWeatherData(_ sender:Any) {
        
    }
    
    @objc func changeFilter(_ notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let filterType = dict["filterType"] as? filteringMethod{
                if filterType.rawValue == 0 {
                    self.navigationItem.title = "예매율순"
                    self.fetchData(filterType)
                }else if filterType.rawValue == 1 {
                    self.navigationItem.title = "큐레이션"
                    self.fetchData(filterType)
                }else {
                    self.navigationItem.title = "개봉일순"
                    self.fetchData(filterType)
                }
            }
        }
    }
    
    @IBAction func flteringButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: "정렬 방식 선택", message:"영화를 어떤 방식으로 정렬할까요?", preferredStyle: .actionSheet)
        
        //예매율 , 큐레이션, 개봉일 정렬
        let reservationRate = UIAlertAction(title: "예매율", style: .default) { [weak self] (action) in
            guard let `self` = self else {return}
            self.navigationItem.title = "예매율순"
            self.filterType = filteringMethod.init(rawValue: 0)
            guard let filter = self.filterType else {return}
            self.fetchData(filter)

            let dictat = ["filterType": self.filterType]
            NotificationCenter.default.post(name: Notification.Name("filtering2"), object: nil, userInfo: dictat as [AnyHashable : Any])
            
            let nc = self.tabBarController?.viewControllers?[1] as! UINavigationController
            if nc.topViewController is CollectionVC {
                let svc = nc.topViewController as! CollectionVC
                svc.filterType = self.filterType
                print(svc.filterType)
            }
        }
        
        let quaration = UIAlertAction(title: "큐레이션", style: .default) { [weak self](action) in
            guard let `self` = self else {return}
            self.navigationItem.title = "큐레이션"
            self.filterType = filteringMethod.init(rawValue: 1)
            guard let filter = self.filterType else {return}
            self.fetchData(filter)
            
            let dictat = ["filterType": self.filterType]
            NotificationCenter.default.post(name: Notification.Name("filtering2"), object: nil, userInfo: dictat as [AnyHashable : Any])
            
            let nc = self.tabBarController?.viewControllers?[1] as! UINavigationController
            if nc.topViewController is CollectionVC {
                let svc = nc.topViewController as! CollectionVC
                svc.filterType = self.filterType
            }
        }
        
        let openTime = UIAlertAction(title: "개봉일", style: .default) { [weak self] (action) in
            guard let `self` = self else {return}
            self.navigationItem.title = "개봉일순"
            self.filterType = filteringMethod.init(rawValue: 2)
            guard let filter = self.filterType else {return}
            self.fetchData(filter)
            
            let dictat = ["filterType": self.filterType]
            NotificationCenter.default.post(name: Notification.Name("filtering2"), object: nil, userInfo: dictat as [AnyHashable : Any])
            
            let nc = self.tabBarController?.viewControllers?[1] as! UINavigationController
            if nc.topViewController is CollectionVC {
                let svc = nc.topViewController as! CollectionVC
                svc.filterType = self.filterType
            }
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
    
}


extension TableVC: UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! TableViewCell
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

extension TableVC: UITableViewDelegate {
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


//https://medium.com/@rashpindermaan68/downloading-files-in-background-with-urlsessiondownloadtask-swift-xcode-download-progress-ios-2e278d6d76cb
extension UIImageView {
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func load(url: URL) {
        self.image = UIImage(named: "profile2")
        getData(from: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            print("Download Finished")
            DispatchQueue.main.async() {
                self?.image = UIImage(data: data)
            }
        }
    }
}

/*
DispatchQueue.global(qos: .userInitiated).async {
    if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data){
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return}
                self.image = image
            }
        }
    }
}
*/

