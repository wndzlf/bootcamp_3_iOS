//
//  contentsCell.swift
//  boostcamp_3_iOS
//
//  Created by admin on 07/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class contentsCell: UITableViewCell {

    @IBOutlet var content: UITextView!
    
    var heightAnchorOfcontent: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        content.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
