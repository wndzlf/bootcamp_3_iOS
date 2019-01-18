//
//  CollectionVC.swift
//  boostcamp_3_iOS
//
//  Created by admin on 09/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

enum filteringMethod: Int {
    case reservation_rate = 0
    case quration = 1
    case open = 2
}

class CollectionVC: UIViewController {
    var movies = [Movie]()
    var filterType: filteringMethod?
    private var refreshControl = UIRefreshControl()

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupFiltering(filterType)
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFilter(_:)), name: Notification.Name(rawValue: "filtering2"), object: nil)
    }
    
    @objc func refreshData() {
        if let filter = filterType {
            fetchData(filter)
            self.refreshControl.endRefreshing()
        }
    }
    
    func setupFiltering(_ filterType: filteringMethod?) {
        if let filter = filterType {
            if filter.rawValue == 0 {
                self.navigationItem.title = "예매율순"
                fetchData(filter)
            } else if filter.rawValue == 1 {
                self.navigationItem.title = "큐레이션"
                fetchData(filter)
            } else if filter.rawValue == 2 {
                self.navigationItem.title = "개봉일순"
                fetchData(filter)
            }
        } else {
                self.navigationItem.title = "예매율순"
                self.filterType = filteringMethod.init(rawValue: 0)
                guard let temp = self.filterType else { return }
                fetchData(temp)
        }
    }
    
    @objc func changeFilter(_ notification: Notification) {
        print("changeFilter")
        if let dict = notification.userInfo as NSDictionary? {
            if let id = dict["filterType"] as? filteringMethod {
                if id.rawValue == 0 {
                    self.navigationItem.title = "예매율순"
                    fetchData(id)
                } else if id.rawValue == 1 {
                    self.navigationItem.title = "큐레이션"
                    fetchData(id)
                } else {
                    self.navigationItem.title = "개봉일순"
                    fetchData(id)
                }
            }
        }
    }
    
    @IBAction func filteringButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: "정렬 방식 선택", message: "영화를 어떤 방식으로 정렬할까요?", preferredStyle: .actionSheet)
        
        //예매율 , 큐레이션, 개봉일 정렬
        let reservationRate = UIAlertAction(title: "예매율", style: .default) { [weak self] (action) in
            guard let `self` = self else { return }
            
            self.navigationItem.title = "예매율순"
            self.filterType = filteringMethod.init(rawValue: 0)
            
            guard let filter = self.filterType else { return }
            
            self.fetchData(filter)
            
            let dictat = ["filterType": self.filterType]
            NotificationCenter.default.post(name: Notification.Name("filtering"), object: nil, userInfo: dictat as [AnyHashable : Any])
        }
        
        let quaration = UIAlertAction(title: "큐레이션", style: .default) { [weak self] (action) in
            guard let `self` = self else { return }
            
            self.navigationItem.title = "큐레이션"
            self.filterType = filteringMethod.init(rawValue: 1)
            
            guard let filter = self.filterType else { return }
            
            self.fetchData(filter)
            
            let dictat = ["filterType": self.filterType]
            NotificationCenter.default.post(name: Notification.Name("filtering"), object: nil, userInfo: dictat as [AnyHashable : Any])
        }
        
        let openTime = UIAlertAction(title: "개봉일", style: .default) { [weak self] (action) in
            guard let `self` = self else { return }
            
            self.navigationItem.title = "개봉일순"
            self.filterType = filteringMethod.init(rawValue: 2)
            
            guard let filter = self.filterType else { return }
            
            self.fetchData(filter)
            
            let dictat = ["filterType": self.filterType]
            NotificationCenter.default.post(name: Notification.Name("filtering"), object: nil, userInfo: dictat as [AnyHashable : Any])
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

    
    func fetchData(_ filterType: filteringMethod) {
        MovieListAPI.shared.getJsonFromUrlWithFilter(filterType: filterType) { [weak self] (movieList, error) in
            guard let `self` = self else { return }
            guard let movieList = movieList else { return }
            self.movies = movieList.movies
            
            if error != nil {
                let alter = UIAlertController(title: "네트워크 장애", message: "네트워크 신호가 불안정 합니다.", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension CollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailmoiveVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailMovie") as! DetailMovieVC
        print("objectIdentifier \(ObjectIdentifier(detailmoiveVC).debugDescription)")
        
        let backButton = UIBarButtonItem.init(title: "영화목록", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        detailmoiveVC.navigationTitle = movies[indexPath.row].title
        detailmoiveVC.id = movies[indexPath.row].id
        self.navigationController?.pushViewController(detailmoiveVC, animated: true)
    }
}

extension CollectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CollectionViewCell
        
        let movie = self.movies[indexPath.row]
        cell.title.text = movie.title
        cell.title.sizeToFit()
        cell.rating.text = "  / \(movie.reservation_rate)%"
        cell.rating.sizeToFit()
        cell.date.text = movie.date
        cell.date.sizeToFit()
        cell.rate.text = "\(indexPath.row+1)위 (\(movie.user_rating))"
        cell.rate.sizeToFit()
        
        if movie.grade == 0 {
            cell.movieAge.image = UIImage(named:"all")
        } else if movie.grade == 12 {
            cell.movieAge.image = UIImage(named:"12")
        } else if movie.grade == 15 {
            cell.movieAge.image = UIImage(named:"15")
        } else {
            cell.movieAge.image = UIImage(named:"19")
        }
        
        let imageURL = URL(string: movie.thumb)!
        cell.poster.load(url: imageURL)
        
        return cell
    }
}
