//
//  AnswerCell.swift
//  Unify
//
//  Created by Phycom  on 8/23/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {

    @IBOutlet weak var viewBg: UIView!
    
    @IBOutlet weak var textAnswer: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.giveCornerRadius(viewBg)
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
