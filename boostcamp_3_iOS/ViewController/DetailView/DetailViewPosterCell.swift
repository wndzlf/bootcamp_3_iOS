//
//  posterCell.swift
//  boostcamp_3_iOS
//
//  Created by admin on 07/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class DetailViewPosterCell: UITableViewCell {
    
    @IBOutlet var poster: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var genre: UILabel!
    @IBOutlet var reservation_rate: UILabel!
    @IBOutlet var user_rating: UILabel!
    @IBOutlet var audience: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
