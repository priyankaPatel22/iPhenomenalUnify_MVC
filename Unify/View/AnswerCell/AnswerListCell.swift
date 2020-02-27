//
//  AnswerListCell.swift
//  Unify
//
//  Created by Phycom  on 8/23/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class AnswerListCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var btnMore: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.giveCornerRadius(viewBg)
        
        imgProfile.layer.cornerRadius = imgProfile.layer.frame.height / 2
        imgProfile.clipsToBounds = true
    }
    func giveCornerRadius(_ view:AnyObject) {
        view.layer.cornerRadius = 5
        //self.viewBg.clipsToBounds = true
        
        view.layer.shadowColor = UIColor(red: 180.0 / 255.0, green: 180.0 / 255.0, blue: 180.0 / 255.0, alpha: 0.7).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.5
    }
}
