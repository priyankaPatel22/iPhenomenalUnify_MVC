//
//  Account.swift
//  DataBaseDemo
//
//  Created by Priyanka Patel on 16/05/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

typealias RequestCompletedBlock = (Any?, NSError?) -> Void

enum RequestMethod : Int {
    case get = 1
    case post = 2
    case put = 3
    case delete = 4
    case patch = 5
}
class Account: NSObject, NSCoding {

    static let sharedInstance = Account()

    let ENCODING_VERSION = 2
    var TAG = ""

    /*
     {
     "status": "1",
     "message": "Login Successfully.",
     "data": {
     "user_id": "17",
     "username": "krunalsojitra",
     "fullname": "krunal sojitra",
     "email": "ksojitra00023@gmail.com",
     "phone": "",
     "address": "C-404 ganegh",
     "dob": "2018-04-26",
     "latitude": "23.022505",
     "longitude": "72.571362",
     "profile_image": ""
     }
     }
 
     
     
     "user_balance": "0",
     
     "university_id": "1",
     "university_name": "Anand Agricultural University",
     "profile_image": "",
     
     "images": [
     {
     "user_images_id": "1",
     "image": "http://jobandoffers.com/demo/unify/upload/images/1.png"
     },
     {
     "user_images_id": "2",
     "image": "http://jobandoffers.com/demo/unify/upload/images/2.png"
     }
     ]
     }
     
     "about": "hhelo man",
     "years": "1 yr",
     "course": "Computer Scuence",
     "speakes": "English",
     "friends": "180",
 */

    var user_id: Int = 0
    var username = ""
    var fullname = ""
    var email = ""
    
    var phone = ""
    var address = ""
    var dob = ""
    
    var latitude = ""
    var longitude = ""
    
    var profile_image = ""
   
    var user_balance = ""
    
    var university_id = ""
    var university_name = ""
    
    var about = ""
    var years = ""
    var course = ""
    var speakes = ""
    var friends = ""
    
    var images = [Any]()
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()

        if aDecoder.decodeCInt(forKey: "version") == ENCODING_VERSION {

            if let id = aDecoder.decodeObject(forKey: "user_id") {
                user_id = id as! Int
            }

            if let id = aDecoder.decodeObject(forKey: "username") {
                username = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "fullname") {
                fullname = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "email") {
                email = id as! String
            }

            if let id = aDecoder.decodeObject(forKey: "phone") {
                phone = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "address") {
                address = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "dob") {
                dob = id as! String
            }
           
            if let id = aDecoder.decodeObject(forKey: "latitude") {
                latitude = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "longitude") {
                longitude = id as! String
            }
            
            if let id = aDecoder.decodeObject(forKey: "profile_image") {
                profile_image = id as! String
            }
            
            if let id = aDecoder.decodeObject(forKey: "user_balance") {
                user_balance = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "university_id") {
                university_id = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "university_name") {
                university_name = id as! String
            }
            
            if let id = aDecoder.decodeObject(forKey: "about") {
                about = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "years") {
                years = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "course") {
                course = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "speakes") {
                speakes = id as! String
            }
            if let id = aDecoder.decodeObject(forKey: "friends") {
                friends = id as! String
            }
            
            if let id = aDecoder.decodeObject(forKey: "images"){
                images = id as! [Any]
            }
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encodeCInt(Int32(ENCODING_VERSION), forKey: "version")

        aCoder.encode(user_id as NSNumber, forKey: "user_id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(fullname, forKey: "fullname")
        aCoder.encode(email, forKey: "email")
        
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(dob, forKey: "dob")
        
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        
        aCoder.encode(profile_image, forKey: "profile_image")
        
        aCoder.encode(user_balance, forKey: "user_balance")
        aCoder.encode(university_id, forKey: "university_id")
        aCoder.encode(university_name, forKey: "university_name")
        
        aCoder.encode(about, forKey: "about")
        aCoder.encode(years, forKey: "years")
        aCoder.encode(course, forKey: "course")
        aCoder.encode(speakes, forKey: "speakes")
        aCoder.encode(friends, forKey: "friends")
        
        aCoder.encode(images, forKey: "images")
    }

    

    // MARK: - Login Api Block
    func loginUser(_ param:[String : Any],_ block: @escaping RequestCompletedBlock) {
        TAG = API_LOGIN
       
        startRequest(API_LOGIN, "POST", param, block)
    }
    
    // MARK: - Register User Api Block
    func getUniversityList(_ block: @escaping RequestCompletedBlock) {
        TAG = API_GET_UNIVERSITY_LIST
        
        startRequest(API_GET_UNIVERSITY_LIST, "GET", [:], block)
    }
    // MARK: - Register User Api Block
    func registerUser(_ param:[String : Any],_ block: @escaping RequestCompletedBlock) {
        TAG = API_REGISTER
        
        startRequest(API_REGISTER, "POST", param, block)
    }
    
    // MARK: - Logout Api Block
    func logoutUser(_ param:[String : Any],_ block: @escaping RequestCompletedBlock) {
        TAG = API_LOGOUT
        
        startRequest(API_LOGOUT, "POST", param, block)
    }
    
    // MARK: - forgot Password Api Block
    func forgotPassword(_ param:[String : Any],_ block: @escaping RequestCompletedBlock) {
        TAG = API_FORGOT_PASSWORD

        startRequest(API_FORGOT_PASSWORD, "POST", param, block)
    }

    // MARK: - change Password Api Block
    func changePassword(_ param:[String : Any],_ block: @escaping RequestCompletedBlock) {
        TAG = API_CHANGEPASSWORD_PASSWORD
        
        startRequest(API_CHANGEPASSWORD_PASSWORD, "POST", param, block)
    }
    
    // MARK: - get User Detail Api Block
    func getUserDetail(_ param:[String : Any],_ isCurrentUser:Bool ,_ block: @escaping RequestCompletedBlock) {
        if isCurrentUser{
            TAG = API_GET_USER_DETAIL
        }else{
            TAG = "0"
        }
        
        startRequest(API_GET_USER_DETAIL, "POST", param, block)
    }
    // MARK: - Update Profile Api Block
    func updateProfile(_ param:[String : Any],_ block: @escaping RequestCompletedBlock) {
        TAG = API_UPDATE_PROFILE
       
        startRequest(API_UPDATE_PROFILE, "POST", param, block)
    }
    
    // MARK: - Update Profile Image
    func updateProfileImage(_ imgdata: Data?,withBlock block: @escaping RequestCompletedBlock) {
        
        TAG = API_IMAGE_UPLOAD
    
//        let headers: HTTPHeaders = [
//            /* "Authorization": "your_access_token",  in case you need authorization header */
//            "Content-type": "multipart/form-data"
//        ]
        

        Alamofire.upload(multipartFormData: { multipartFormData in

            if let data = imgdata{
                multipartFormData.append(data, withName: "image",fileName: "hi \(self.user_id).jpeg", mimeType: "image/jpeg")
            }

        },
                         to: UPLOAD_IMAGE_BASE_URL+API_IMAGE_UPLOAD, method: .post)
        { (result) in
            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })

                upload.responseJSON { response in
                    if let err = response.error{
                        block(nil,err as NSError)
                    }else{
                        print(response.result.value!)
                        block(response.result.value,nil)
                    }
                }

            case .failure(let encodingError):
                print(encodingError)
                block(nil,encodingError as NSError)
            }
        }
    }
    
    
    // MARK: -
    func RequestDidSucceed(_ data: Any,_ block: @escaping RequestCompletedBlock){
        if(TAG == API_LOGIN || TAG == API_GET_USER_DETAIL){
            
            let value = data as? [String: Any]
            print(value)
            
            if value != nil{
                let dict = value!["data"] as! [String: Any]
                print(dict)
                
                
                if TAG == API_LOGIN{
                    if let id = value!["university_id"] as? String{
                        self.university_id = id
                    }else{
                        self.university_id = ""
                    }
                    
                    if let id = value!["university_name"] as? String{
                        self.university_name = id
                    }else{
                        self.university_name = ""
                    }
                }else{
                    if let id = dict["university_id"] as? String{
                        self.university_id = id
                    }else{
                        self.university_id = ""
                    }
                    
                    if let id = dict["university_name"] as? String{
                        self.university_name = id
                    }else{
                        self.university_name = ""
                    }
                }
                
                if let id = dict["user_id"] as? String, let i = Int(id){
                    self.user_id  = i
                }else{
                    self.user_id  = 0
                }
                
                if let id = dict["username"] as? String{
                    self.username = id
                }else{
                    self.username = ""
                }
                if let id = dict["fullname"] as? String{
                    self.fullname = id
                }else{
                    self.fullname = ""
                }
                if let id = dict["email"] as? String{
                    self.email = id
                }else{
                    self.email = ""
                }
               
                if let id = dict["phone"] as? String{
                    self.phone = id
                }else{
                    self.phone = ""
                }
                if let id = dict["address"] as? String{
                    self.address = id
                }else{
                    self.address = ""
                }
                if let id = dict["dob"] as? String{
                    self.dob = id
                }else{
                    self.dob = ""
                }
                
                if let id = dict["latitude"] as? String{
                    self.latitude = id
                }else{
                    self.latitude = ""
                }
                if let id = dict["longitude"] as? String{
                    self.longitude = id
                }else{
                    self.longitude = ""
                }
                
                if let id = dict["profile_image"] as? String{
                    self.profile_image = id
                }else{
                    self.profile_image = ""
                }
                
                if let id = dict["user_balance"] as? String{
                    self.user_balance = id
                }else{
                    self.user_balance = ""
                }
                
                
                
                if let id = dict["about"] as? String{
                    self.about = id
                }else{
                    self.about = ""
                }
                if let id = dict["years"] as? String{
                    self.years = id
                }else{
                    self.years = ""
                }
                if let id = dict["course"] as? String{
                    self.course = id
                }else{
                    self.course = ""
                }
                if let id = dict["speakes"] as? String{
                    self.speakes = id
                }else{
                    self.speakes = ""
                }
                if let id = dict["friends"] as? String{
                    self.friends = id
                }else{
                    self.friends = ""
                }
                
                if let id = dict["images"] as? [Any]{
                    self.images = id
                }else{
                    self.images = []
                }
                
                AccountManager.Instance.activeAccount = self
            }
            
            block(data,nil)
        }else{
            block(data,nil)
        }
        /*
        else if(TAG == API_REGISTER || TAG == API_LOGOUT || TAG == API_FORGOT_PASSWORD || TAG == API_GET_UNIVERSITY_LIST || TAG == API_UPDATE_PROFILE ||  TAG == API_CHANGEPASSWORD_PASSWORD){
            
            let value = data as? [String: Any]
            print(value)
            block(data,nil)
        }
         */
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
