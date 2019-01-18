//
//  commentCell.swift
//  boostcamp_3_iOS
//
//  Created by admin on 07/12/2018.ew
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class DetailViewCommentCell: UITableViewCell {
    
    @IBOutlet var writer: UILabel!
    @IBOutlet var timestamp: UILabel!
    @IBOutlet var contents: UITextView!
    
    @IBOutlet var star1: UIImageView!
    @IBOutlet var star2: UIImageView!
    @IBOutlet var star3: UIImageView!
    @IBOutlet var star4: UIImageView!
    @IBOutlet var star5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
