//
//  ChatList.swift
//  Unify
//
//  Created by Phycom  on 9/10/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

typealias ChatDetailCompletedBlock = (Any?, NSError?) -> Void
typealias ChatListCompletedBlock = (Any?, NSError?) -> Void
class ChatList: NSObject {
    static let sharedInstance = ChatList()
    var TAG = ""
    
    /*
     *Store all the services of logged in user
     */
    var arrGetChatDetail:[Any] = []
    var arrGetChatList:[Any] = []
    
    /*
     *Get the current order list of user
     */
    func getChatDetailList() -> [Any] {
        return arrGetChatDetail
    }
    func getChatList() -> [Any] {
        return arrGetChatList
    }
    
    // MARK: - get Chat Detail Api Block
    func getChatDetailList(_ param:[String : Any],_ block: @escaping ChatDetailCompletedBlock) {
        TAG = API_GET_CHAT_DETAIL
        
        startRequest(API_GET_CHAT_DETAIL, "POST", param, block)
    }
    
    // MARK: - get send Message Api Block
    func sendMessage(_ param:[String : Any],_ block: @escaping ChatListCompletedBlock) {
        TAG = SEND_MESSAGE
        
        startRequest(SEND_MESSAGE, "POST", param, block)
    }
    
    // MARK: - get Chat List Api Block
    func getChatList(_ param:[String : Any],_ block: @escaping ChatListCompletedBlock) {
        TAG = API_GET_CHAT_LIST
        
        startRequest(API_GET_CHAT_LIST, "POST", param, block)
    }
    
    // MARK: -
    func RequestDidSucceed(_ data: Any,_ block: @escaping ChatDetailCompletedBlock){
        if(TAG == API_GET_CHAT_DETAIL){
            
            if let allValue = data as? [String:Any]
            {
                if let value = allValue["data"] as? [Any]{
                    print(value)
                    
                    self.arrGetChatDetail = Array()
                    for dict in value{
                        if dict is [String:Any]{
                            let getChatDetail = ChatDetailInfo.shared.parseWithDict(dict as! [String : Any])
                            arrGetChatDetail.append(getChatDetail)
                        }
                    }
                }
            }
            
            
            block(data,nil)
        }else if TAG == SEND_MESSAGE{
            if let allValue = data as? [String:Any]
            {
                if let dict = allValue["data"] as? [String:Any]{
                    let getChatDetail = ChatDetailInfo.shared.parseWithDict(dict)
                    arrGetChatDetail.append(getChatDetail)
                }
            }
            
            
            block(data,nil)
        }else if TAG == API_GET_CHAT_LIST {
            if let allValue = data as? [String:Any]
            {
                if let value = allValue["data"] as? [String:Any]{
                    print(value)
                    
                    self.arrGetChatList = Array()
                    for dict in (value["chat_list"] as? [Any])!{
                        if dict is [String:Any]{
                            let getChatList = ChatListInfo.shared.parseWithDict(dict as! [String : Any])
                            arrGetChatList.append(getChatList)
                        }
                    }
                }
            }
            
            
            block(data,nil)
        }
    }
    func RequestDidFail(_ error: NSError?,_ block: @escaping ChatDetailCompletedBlock){
        block(nil,error)
    }
    
    // MARK: -
    func startRequest(_ postURL:String,_ methodType:String,_ params:[String : Any],_ block: @escaping ChatDetailCompletedBlock) {
        
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
