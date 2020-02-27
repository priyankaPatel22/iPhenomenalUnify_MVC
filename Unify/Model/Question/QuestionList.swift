//
//  QuestionList.swift
//  Unify
//
//  Created by Phycom  on 8/31/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

typealias QuestionCompletedBlock = (Any?, NSError?) -> Void
class QuestionList: NSObject {
    static let sharedInstance = QuestionList()
    var TAG = ""
    
    /*
     *Store all the services of logged in user
     */
    var arrGetQuestions:[Any] = []
    var arrGetAnswer:[Any] = []
    
    /*
     *Get the current order list of user
     */
    func getQuestionList() -> [Any] {
        return arrGetQuestions
    }
    func getAnswerList() -> [Any] {
        return arrGetAnswer
    }
    
    // MARK: - get Questions Api Block
    func loadQuestionsList(_ param:[String : Any],_ block: @escaping QuestionCompletedBlock) {
        TAG = API_GET_QUESTIONS_LIST
        
        startRequest(API_GET_QUESTIONS_LIST, "POST", param, block)
    }
    
    // MARK: - Like Api Block
    func likeQuestion(_ param:[String : Any],_ block: @escaping QuestionCompletedBlock) {
        TAG = API_LIKE_QUESTION
        
        startRequest(API_LIKE_QUESTION, "POST", param, block)
    }
    // MARK: - Unlike Api Block
    func unlikeQuestion(_ param:[String : Any],_ block: @escaping QuestionCompletedBlock) {
        TAG = API_UNLIKE_QUESTION
        
        startRequest(API_UNLIKE_QUESTION, "POST", param, block)
    }
    
    // MARK: - Add Question Api Block
    func addQuestion(_ param:[String : Any],_ block: @escaping QuestionCompletedBlock) {
        TAG = API_ADD_QUESTION
        
        startRequest(API_ADD_QUESTION, "POST", param, block)
    }
    
    // MARK: - Add Answer Api Block
    func addAnswer(_ param:[String : Any],_ block: @escaping QuestionCompletedBlock) {
        TAG = API_ADD_ANSWER
        
        startRequest(API_ADD_ANSWER, "POST", param, block)
    }
    
    // MARK: - get Questions Api Block
    func loadAnswerList(_ param:[String : Any],_ block: @escaping QuestionCompletedBlock) {
        TAG = API_GET_ANSWER_LIST
        
        startRequest(API_GET_ANSWER_LIST, "POST", param, block)
    }
    
    // MARK: -
    func RequestDidSucceed(_ data: Any,_ block: @escaping RequestCompletedBlock){
        if(TAG == API_GET_QUESTIONS_LIST){
            
            if let allValue = data as? [String:Any]
            {
                if let value = allValue["data"] as? [Any]{
                    print(value)
                    
                    self.arrGetQuestions = Array()
                    for dict in value{
                        if dict is [String:Any]{
                            let getQuestions = QuestionListInfo.shared.parseWithDict(dict as! [String : Any])
                            arrGetQuestions.append(getQuestions)
                        }
                    }
                }
            }
            
            
            block(data,nil)
        }else if TAG == API_GET_ANSWER_LIST {
            if let allValue = data as? [String:Any]
            {
                if let value = allValue["data"] as? [String:Any]{
                    print(value)
                    
                    if let valueAns = value["answers"] as? [Any]{
                        print(valueAns)
                        
                        self.arrGetAnswer = Array()
                        for dict in valueAns{
                            if dict is [String:Any]{
                                let getQuestions = AnswerListInfo.shared.parseWithDict(dict as! [String : Any])
                                arrGetAnswer.append(getQuestions)
                            }
                        }
                    }
                    
                }
            }
            
            
            block(data,nil)
        }else if(TAG == API_LIKE_QUESTION || TAG == API_UNLIKE_QUESTION || TAG == API_ADD_QUESTION || TAG == API_ADD_ANSWER){
            block(data,nil)
        }
    }
    func RequestDidFail(_ error: NSError?,_ block: @escaping RequestCompletedBlock){
        block(nil,error)
    }
    
    // MARK: -
    func startRequest(_ postURL:String,_ methodType:String,_ params:[String : Any],_ block: @escaping RequestCompletedBlock) {
        
        if methodType == "POST" {
            let finalData:[String : Any] = ["data":params]
            print(finalData)
            
            AlmofireRequest.sharedInstance.requestPOSTURL(postURL, params: finalData, headers: nil, success: { (data) in
                let value = data as? [String: Any]
                
                if value!["status"] as! String == "1"{
                    self.RequestDidSucceed(data!,block)
                }else{
                    self.RequestDidFail(NSError(domain: value!["message"] as! String, code: 200, userInfo: data as? [String : Any]),block)
                }
                
            }) { (error) in
                self.RequestDidFail(error as NSError,block)
            }
        }else if methodType == "GET" {
            
            AlmofireRequest.sharedInstance.requestGETURL(postURL, success: { (data) in
                let value = data as? [String: Any]
                
                if value!["status"] as! String == "1"{
                    self.RequestDidSucceed(data!,block)
                }else{
                    self.RequestDidFail(NSError(domain: value!["message"] as! String, code: 200, userInfo: data as? [String : Any]),block)
                }
            }) { (error) in
                self.RequestDidFail(error as NSError,block)
            }
        }
    }

}
