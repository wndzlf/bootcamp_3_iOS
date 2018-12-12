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
    @IBOutlet var rating: UILabel!
    @IBOutlet var timestamp: UILabel!
    @IBOutlet var contents: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
