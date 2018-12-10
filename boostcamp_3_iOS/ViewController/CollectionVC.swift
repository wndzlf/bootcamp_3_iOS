//
//  CollectionVC.swift
//  boostcamp_3_iOS
//
//  Created by admin on 09/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

enum filteringMethod:Int {
    case reservation_rate = 0
    case quration = 1
    case open = 2
}

class CollectionVC: UIViewController {
    var movies = [movie]()
    var filterType: filteringMethod?

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupFiltering(filterType?.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFilter(_:)), name: Notification.Name(rawValue: "filtering2"), object: nil)
    }
    //
    func setupFiltering(_ filterTypeRaw: Int?){
        if let filter = filterTypeRaw {
            if filter == 0 {
                self.navigationItem.title = "예매율순"
                let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=0"
                self.getJsonFromURL(getURL: url)
            }else if filter == 1 {
                self.navigationItem.title = "큐레이션"
                let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=1"
                self.getJsonFromURL(getURL: url)
            }else if filter == 2{
                self.navigationItem.title = "개봉일순"
                let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=2"
                self.getJsonFromURL(getURL: url)
            }
        }else {
            self.navigationItem.title = "예매율순"
            let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=0"
            self.getJsonFromURL(getURL: url)
            filterType = filteringMethod.init(rawValue: 0)
        }
    }
    
    @objc func changeFilter(_ notification: Notification) {
        print("changeFilter")
        if let dict = notification.userInfo as NSDictionary? {
            if let id = dict["filterType"] as? filteringMethod{
                if id.rawValue == 0 {
                    self.navigationItem.title = "예매율순"
                    let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=0"
                    self.getJsonFromURL(getURL: url)
                }else if id.rawValue == 1 {
                    self.navigationItem.title = "큐레이션"
                    let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=1"
                    self.getJsonFromURL(getURL: url)
                }else {
                    self.navigationItem.title = "개봉일순"
                    let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=2"
                    self.getJsonFromURL(getURL: url)
                }
            }
        }
    }
    
    @IBAction func filteringButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: "정렬 방식 선택", message:"영화를 어떤 방식으로 정렬할까요?", preferredStyle: .actionSheet)
        //예매율 , 큐레이션, 개봉일 정렬
        let reservationRate = UIAlertAction(title: "예매율", style: .default) { [weak self] (action) in
            guard let `self` = self else {return}
            self.navigationItem.title = "예매율순"
            self.filterType = filteringMethod.init(rawValue: 0)
            let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=0"
            self.getJsonFromURL(getURL: url)
            
            let dictat = ["filterType": self.filterType]
            NotificationCenter.default.post(name: Notification.Name("filtering"), object: nil, userInfo: dictat as [AnyHashable : Any])
        }
        
        let quaration = UIAlertAction(title: "큐레이션", style: .default) { [weak self](action) in
            guard let `self` = self else {return}
            self.navigationItem.title = "큐레이션"
            self.filterType = filteringMethod.init(rawValue: 1)
            let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=1"
            self.getJsonFromURL(getURL: url)
            
            let dictat = ["filterType": self.filterType]
            NotificationCenter.default.post(name: Notification.Name("filtering"), object: nil, userInfo: dictat as [AnyHashable : Any])
        }
        
        let openTime = UIAlertAction(title: "개봉일", style: .default) { [weak self] (action) in
            guard let `self` = self else {return}
            self.navigationItem.title = "개봉일순"
            self.filterType = filteringMethod.init(rawValue: 2)
            let url = "http://connect-boxoffice.run.goorm.io/movies?order_type=2"
            self.getJsonFromURL(getURL: url)
            
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
    

    func getJsonFromURL(getURL: String) {
        guard let url = URL(string: getURL) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (datas, response, error) in
            
            guard let `self` = self else {return}
            
            if error != nil {
                let alter = UIAlertController(title: "네트워크 장애", message: "네트워크 신호가 불안정 합니다.", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                alter.addAction(action)
                self.present(alter, animated: true, completion: nil)
            }
            
            guard let data = datas else {return}
            
            do {
                let order = try JSONDecoder().decode(orderType.self, from: data)
                
                self.movies = order.movies
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }catch{
                
                print("Error")
            }
            
            }.resume()
    }
}

extension CollectionVC: UICollectionViewDelegateFlowLayout {
    
}

extension CollectionVC: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CollectionViewCell
        
        let movie = self.movies[indexPath.row]
        cell.title.text = movie.title
        cell.rating.text = "\(movie.reservation_rate)"
        cell.date.text = movie.date
        
        let imageURL = URL(string: movie.thumb)!
        cell.poster.load(url: imageURL)
        
        return cell
    }
}
