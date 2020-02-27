//
//  AlmofierRequest.swift
//  AlamofireDemo
//
//  Created by Priyanka Patel on 17/05/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import UIKit
import Alamofire

class AlmofireRequest: NSObject {

    static let sharedInstance = AlmofireRequest()

    //TODO :-
    /* Handle Time out request alamofire */


    func requestGETURL(_ strURL: String, success:@escaping (_ data: Any?) -> Void, failure:@escaping (Error) -> Void)
    {
        Alamofire.request(BASE_URL+strURL).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = responseObject.result.value!
                //let title = resJson["title"].string
                //print(title!)
                success(resJson)
            }

            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }

    func requestPOSTURL(_ strURL : String, params : [String : Any]?, headers : [String : String]?, success:@escaping (_ data: Any?) -> Void, failure:@escaping (Error) -> Void){

        
        Alamofire.request(BASE_URL+strURL, method: .post, parameters: params!, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON
            { (responseObject) -> Void in
                //print(responseObject)
                if responseObject.result.isSuccess {
                    let resJson = responseObject.result.value!
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
        }
        
//        Alamofire.request(BASE_URL+strURL,
//                         method: .post,
//                         parameters: params!,
//                         encoding: .JSON)
//            .validate()
//            .responseJSON
//            { (responseObject) -> Void in
//            //print(responseObject)
//            if responseObject.result.isSuccess {
//                let resJson = responseObject.result.value!
//                success(resJson)
//            }
//            if responseObject.result.isFailure {
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
//        }
    }

}


