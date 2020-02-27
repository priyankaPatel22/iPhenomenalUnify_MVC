//
//  QuestionInfo.swift
//  Unify
//
//  Created by Phycom  on 8/31/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

/*
 created = "2018-09-03 20:24:11";
 fullname = "Meeet DOshi";
 image = "http://jobandoffers.com/demo/unify/upload/images/sojitra";
 "like_question" = 0;
 "profile_image" = "";
 "question_id" = 10;
 "question_title" = Hello;
 timeago = "8 day ago";
 "total_answer" = 0;
 "total_share" = 0;
 "university_id" = 0;
 "university_name" = "<null>";
 "user_id" = 14;
 username = "";
 video = "http://jobandoffers.com/demo/unify/upload/images/asd@gmail.com";
 view = 0;
 "total_like" = 0;
 */
class QuestionListInfo: NSObject {
    
    static let shared = QuestionListInfo()
    
    var question_id = ""
    var question_title = ""
    var image = ""
    var video = ""
    var view = ""
    var created = ""
    var user_id = ""
    var username = ""
    var fullname = ""
    var profile_image = ""
    var like_question = "0"
    var timeago = ""
    var total_answer = ""
    var total_share = ""
    var total_like = ""
    var university_id = ""
    var university_name = ""
    
    func parseWithDict(_ dict:[String:Any]) -> QuestionListInfo{
        let info = QuestionListInfo()
        
        if let id = dict["question_id"]{
            if id is String{
                info.question_id = id as! String
            }
        }
        if let id = dict["question_title"]{
            if id is String{
                info.question_title = id as! String
            }
        }
        if let id = dict["image"]{
            if id is String{
                info.image = id as! String
            }
        }
        if let id = dict["video"]{
            if id is String{
                info.video = id as! String
            }
        }
        if let id = dict["view"]{
            if id is String{
                info.view = id as! String
            }
        }
        if let id = dict["created"]{
            if id is String{
                info.created = id as! String
            }
        }
        if let id = dict["user_id"]{
            if id is String{
                info.user_id = id as! String
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
        if let id = dict["profile_image"]{
            if id is String{
                info.profile_image = id as! String
            }
        }
        if let id = dict["like_question"]{
            if id is String{
                info.like_question = id as! String
            }
//            if id is Int{
//                info.like_question = "\(id)"
//            }
        }
        if let id = dict["timeago"]{
            if id is String{
                info.timeago = id as! String
            }
        }
        if let id = dict["total_answer"]{
            if id is String{
                info.total_answer = id as! String
            }
        }
        if let id = dict["total_like"]{
            if id is String{
                info.total_like = id as! String
            }
        }
        
        if let id = dict["total_share"]{
            if id is String{
                info.total_share = id as! String
            }
        }
        if let id = dict["university_id"]{
            if id is String{
                info.university_id = id as! String
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
/*
answer = krunal;
created = "2018-08-05 06:05:21";
fullname = jigi;
image = "http://jobandoffers.com/demo/unify/upload/images/sojitra";
"profile_image" = "";
"question_id" = 2;
"questions_ans_id" = 3;
timeago = "1 month ago";
"user_id" = 8;
username = jigi;
video = "http://jobandoffers.com/demo/unify/upload/images/asd@gmail.com";
*/
class AnswerListInfo: NSObject {
    
    static let shared = AnswerListInfo()
    
    var questions_ans_id = ""
    var question_id = ""
    var answer = ""
    var image = ""
    var video = ""
    var user_id = ""
    var created = ""
    var username = ""
    var fullname = ""
    var profile_image = ""
    var timeago = ""
    
    func parseWithDict(_ dict:[String:Any]) -> AnswerListInfo{
        let info = AnswerListInfo()
        
        if let id = dict["question_id"]{
            if id is String{
                info.question_id = id as! String
            }
        }
        if let id = dict["questions_ans_id"]{
            if id is String{
                info.questions_ans_id = id as! String
            }
        }
        if let id = dict["answer"]{
            if id is String{
                info.answer = id as! String
            }
        }
        if let id = dict["image"]{
            if id is String{
                info.image = id as! String
            }
        }
        if let id = dict["video"]{
            if id is String{
                info.video = id as! String
            }
        }
        
        if let id = dict["created"]{
            if id is String{
                info.created = id as! String
            }
        }
        if let id = dict["user_id"]{
            if id is String{
                info.user_id = id as! String
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
        if let id = dict["profile_image"]{
            if id is String{
                info.profile_image = id as! String
            }
        }
        if let id = dict["timeago"]{
            if id is String{
                info.timeago = id as! String
            }
        }
        
        
        return info
    }
    
}

