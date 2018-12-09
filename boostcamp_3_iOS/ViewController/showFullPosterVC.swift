//
//  showFullPosterVC.swift
//  boostcamp_3_iOS
//
//  Created by admin on 07/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit

class showFullPosterVC: UIViewController {

    @IBOutlet var fullScreen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
