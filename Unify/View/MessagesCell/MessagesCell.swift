//
//  MessagesCell.swift
//  Unify
//
//  Created by Phycom  on 9/9/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {

    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUniversityName: UILabel!
    
    @IBOutlet weak var lblStatusTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgProfilePic.layer.cornerRadius = imgProfilePic.layer.frame.height / 2
        imgProfilePic.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
