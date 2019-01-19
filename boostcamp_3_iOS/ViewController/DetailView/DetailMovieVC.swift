//
//  DetailMovieViewController.swift
//  boostcamp_3_iOS
//
//  Created by admin on 05/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class DetailMovieVC: UIViewController {
    var id: String?
    var navigationTitle: String?
    var comments = [Comment]()
    var movie: MovieDetail?
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        fetchData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func fetchData() {
        if let movieId = self.id {
            let movieUrlString = "comments?movie_id=" + "\(movieId)"
            MovieListAPI.shared.getJsonFromUrl(movieUrlString) { [weak self] (CommentList: CommentList?, error: Error?) in
                if error != nil {
                    let alter = UIAlertController(title: "네트워크 장애", message: "네트워크 신호가 불안정 합니다.", preferredStyle: UIAlertController.Style.alert)
                    let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    
                    alter.addAction(action)
                    
                    self?.present(alter, animated: true, completion: nil)
                }
                
                guard let CommentList = CommentList else { return }
                self?.comments = CommentList.comments
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            
            let movieDetailUrlString = "movie?id=" + "\(movieId)"
            MovieListAPI.shared.getJsonFromUrl(movieDetailUrlString) { [weak self] (MovieDetail: MovieDetail?, error: Error?) in
                if error != nil {
                    let alter = UIAlertController(title: "네트워크 장애", message: "네트워크 신호가 불안정 합니다.", preferredStyle: UIAlertController.Style.alert)
                    let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    
                    alter.addAction(action)
                    
                    self?.present(alter, animated: true, completion: nil)
                }
                
                guard let MovieDetail = MovieDetail else { return }
                self?.movie = MovieDetail
            
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let tappedImage = tapGestureRecognizer.view as? UIImageView else {
            return
        }
        
        guard let showVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieFullImageVC") as? MovieFullImageVC else {
            return
        }
        
        self.present(showVC, animated: false) {
            showVC.fullScreen.image = tappedImage.image
        }
    }
    
    func setupNavigation() {
        navigationItem.title = navigationTitle
    }
}

extension DetailMovieVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 240
        //줄거리 길이에 따라 섹션 height 수정하기
        } else if indexPath.section == 1 {
            return UITableView.automaticDimension
        } else {
            return 120
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
        } else if section == 1 {
            return 1
        } else {
            return self.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellId") as? DetailViewPosterCell else {
                return UITableViewCell()
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            
            cell.poster.isUserInteractionEnabled = true
            cell.poster.addGestureRecognizer(tapGestureRecognizer)
            
            if let movie = self.movie {
                guard let url = URL(string: movie.image) else {
                    return UITableViewCell()
                }
                
                cell.poster.image = UIImage(named: "cinema")
                cell.poster.load(url: url)
                cell.title.text = movie.title
                cell.title.sizeToFit()
                cell.date.text = movie.date
                cell.date.sizeToFit()
                cell.genre.text = movie.genre
                cell.genre.sizeToFit()
                cell.reservation_rate.text = "\(movie.reservation_rate)"
                cell.reservation_rate.sizeToFit()
                cell.user_rating.text = "\(movie.user_rating)"
                cell.user_rating.sizeToFit()
                cell.audience.text = "\(movie.audience)"
            }
            
            return cell
        } else if indexPath.section == 1 {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellId1") as? DetailViewContentsCell else {
                return UITableViewCell()
            }
            
            cell.content.text = self.movie?.synopsis
            cell.content.isScrollEnabled = false
            cell.content.isEditable = false
            
            return cell
        } else {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellId2") as? DetailViewCommentCell else {
                return UITableViewCell()
            }
            
            let comment = self.comments[indexPath.row]
            
            cell.writer.text = comment.writer
            cell.writer.sizeToFit()
            //cell.rating.text = "\(comment.rating)"
            let date = Date(timeIntervalSince1970: comment.timestamp)
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let strDate = dateFormatter.string(from: date)
            
            cell.star1.image = nil
            cell.star2.image = nil
            cell.star3.image = nil
            cell.star4.image = nil
            cell.star5.image = nil
            
            switch comment.rating {
                case 0...1.0:
                    cell.star1.image = UIImage(named: "halfStar")
                    break
                case 1.1...2.0:
                    cell.star1.image = UIImage(named: "Star")
                    break
                case 2.1...3.0:
                    cell.star1.image = UIImage(named: "Star")
                    cell.star2.image = UIImage(named: "halfStar")
                    break
                case 3.1...4.0:
                    cell.star1.image = UIImage(named: "Star")
                    cell.star2.image = UIImage(named: "Star")
                    break
                case 4.1...5.0:
                    cell.star1.image = UIImage(named: "Star")
                    cell.star2.image = UIImage(named: "Star")
                    cell.star3.image = UIImage(named: "halfStar")
                    break
                case 5.1...6.0:
                    cell.star1.image = UIImage(named: "Star")
                    cell.star2.image = UIImage(named: "Star")
                    cell.star3.image = UIImage(named: "Star")
                    break
                case 6.1...7.0:
                    cell.star1.image = UIImage(named: "Star")
                    cell.star2.image = UIImage(named: "Star")
                    cell.star3.image = UIImage(named: "Star")
                    cell.star4.image = UIImage(named: "halfStar")
                    break
                case 7.1...8.0:
                    cell.star1.image = UIImage(named: "Star")
                    cell.star2.image = UIImage(named: "Star")
                    cell.star3.image = UIImage(named: "Star")
                    cell.star4.image = UIImage(named: "Star")
                    break
                case 8.1...9.0:
                    cell.star1.image = UIImage(named: "Star")
                    cell.star2.image = UIImage(named: "Star")
                    cell.star3.image = UIImage(named: "Star")
                    cell.star4.image = UIImage(named: "Star")
                    cell.star5.image = UIImage(named: "halfStar")
                    break
                case 9.1...10.0:
                    cell.star1.image = UIImage(named: "Star")
                    cell.star2.image = UIImage(named: "Star")
                    cell.star3.image = UIImage(named: "Star")
                    cell.star4.image = UIImage(named: "Star")
                    cell.star5.image = UIImage(named: "Star")
                    break
                default:
                    break
            }
            
            cell.timestamp.text = "\(strDate)"
            cell.timestamp.sizeToFit()
            cell.contents.text = comment.contents
            return cell
        }
        
    }
}
