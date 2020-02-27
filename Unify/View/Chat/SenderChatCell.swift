//
//  SenderChatCell.swift
//  Unify
//
//  Created by Phycom  on 9/9/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class SenderChatCell: UITableViewCell {

    @IBOutlet weak var viewMessageBg: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       viewMessageBg.layer.cornerRadius = 5
        
//        viewMessageBg.translatesAutoresizingMaskIntoConstraints = true
//        //viewMessageBg.layer.masksToBounds = false
//
//        let path = UIBezierPath(roundedRect:viewMessageBg.bounds,
//                                byRoundingCorners:[.topRight, .topLeft, .bottomLeft],
//                                cornerRadii: CGSize(width: 10, height:  10))
//
//        let maskLayer = CAShapeLayer()
//
//        maskLayer.path = path.cgPath
//        maskLayer.frame = viewMessageBg.bounds
//        viewMessageBg.layer.mask = maskLayer
       
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        var backgroundImage = UIImageView(image: UIImage(named: "star"))
        //        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFit
        //        self.backgroundView = backgroundImage
    }
/*
    override func draw(_ rect: CGRect) {
        //viewMessageBg.translatesAutoresizingMaskIntoConstraints = true
        //viewMessageBg.layer.masksToBounds = false
        viewMessageBg.clipsToBounds = true
        
        viewMessageBg.isOpaque = false;
        
        let path = UIBezierPath(roundedRect:viewMessageBg.bounds,
                                byRoundingCorners:[.topRight, .topLeft, .bottomLeft],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        maskLayer.frame = viewMessageBg.bounds
        viewMessageBg.layer.mask = maskLayer

    }
 */
 
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        viewMessageBg.translatesAutoresizingMaskIntoConstraints = true
//        //viewMessageBg.layer.masksToBounds = false
//        
//        let path = UIBezierPath(roundedRect:viewMessageBg.bounds,
//                                byRoundingCorners:[.topRight, .topLeft, .bottomLeft],
//                                cornerRadii: CGSize(width: 10, height:  10))
//        
//        let maskLayer = CAShapeLayer()
//        
//        maskLayer.path = path.cgPath
//        maskLayer.frame = viewMessageBg.bounds
//        viewMessageBg.layer.mask = maskLayer
//
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
