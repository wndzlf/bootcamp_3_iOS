//
//  CollectionViewCell.swift
//  boostcamp_3_iOS
//
//  Created by admin on 09/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var poster: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var movieAge: UIImageView!
    @IBOutlet var rate: UILabel!
    
    public func setMovie(movie model: Movie, itemIdx idx: Int) {
        
        title.text = model.title
        title.sizeToFit()
        rating.text = "  / \(model.reservation_rate)%"
        rating.sizeToFit()
        date.text = model.date
        date.sizeToFit()
        rate.text = "\(idx + 1)위 (\(model.user_rating))"
        rate.sizeToFit()
        
        if model.grade == 0 {
            movieAge.image = UIImage(named:"all")
        }else if model.grade == 12 {
            movieAge.image = UIImage(named:"12")
        }else if model.grade == 15 {
            movieAge.image = UIImage(named:"15")
        }else  {
            movieAge.image = UIImage(named:"19")
        }
        
        let imageURL = URL(string: model.thumb)!
        poster.load(url: imageURL)
    }
}
