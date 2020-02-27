//
//  ChatInfo.swift
//  Unify
//
//  Created by Phycom  on 9/10/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class ChatDetailInfo: NSObject {
    static let shared = ChatDetailInfo()
 
    var user_chat_id = ""
    var receiver_id = ""
    var message = ""
    var sender_image = ""
    var image = ""
    var messagetime = ""
    var is_sender = ""
    
    func parseWithDict(_ dict:[String:Any]) -> ChatDetailInfo{
        let info = ChatDetailInfo()
        
        if let id = dict["user_chat_id"]{
            if id is String{
                info.user_chat_id = id as! String
            }
        }
        if let id = dict["receiver_id"]{
            if id is String{
                info.receiver_id = id as! String
            }
        }
        if let id = dict["message"]{
            if id is String{
                info.message = id as! String
            }
        }
        if let id = dict["sender_image"]{
            if id is String{
                info.sender_image = id as! String
            }
        }
        if let id = dict["image"]{
            if id is String{
                info.image = id as! String
            }
        }
        if let id = dict["messagetime"]{
            if id is String{
                info.messagetime = id as! String
            }
        }
        if let id = dict["is_sender"]{
            if id is String{
                info.is_sender = id as! String
            }
        }
        
        return info
    }
}

class ChatListInfo: NSObject {
    static let shared = ChatListInfo()
  
    var user_chat_id = ""
    var sender_id = ""
    var receiver_id = ""
    var message = ""
    var image = ""
    var created = ""
    var timeago = ""
    var username = ""
    var fullname = ""
    var university_id = ""
    var profile_image = ""
    var university_name = ""
    
    func parseWithDict(_ dict:[String:Any]) -> ChatListInfo{
        let info = ChatListInfo()
        
        if let id = dict["user_chat_id"]{
            if id is String{
                info.user_chat_id = id as! String
            }
        }
        if let id = dict["sender_id"]{
            if id is String{
                info.sender_id = id as! String
            }
        }
        if let id = dict["receiver_id"]{
            if id is String{
                info.receiver_id = id as! String
            }
        }
        if let id = dict["message"]{
            if id is String{
                info.message = id as! String
            }
        }
        if let id = dict["image"]{
            if id is String{
                info.image = id as! String
            }
        }
        if let id = dict["created"]{
            if id is String{
                info.created = id as! String
            }
        }
        if let id = dict["timeago"]{
            if id is String{
                info.timeago = id as! String
            }
        }
        if let id = dict["username"]{
            if id is String{
                info.username = id as! String
            }
        }
        if let id = dict["fullname"]{
            if id is String{
                info.fullname = id as! String
            }
        }
        if let id = dict["university_id"]{
            if id is String{
                info.university_id = id as! String
            }
        }
        if let id = dict["profile_image"]{
            if id is String{
                info.profile_image = id as! String
            }
        }
        if let id = dict["university_name"]{
            if id is String{
                info.university_name = id as! String
            }
        }
        return info
    }
}
