//
//  MyProfileController.swift
//  Unify
//
//  Created by Phycom  on 8/22/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyProfileController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnAddFriend: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var imgCoverPic: UIImageView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUniversityname: UILabel!
    
    @IBOutlet weak var viewAbout: UIView!
    @IBOutlet weak var viewUniversity: UIView!
    @IBOutlet weak var viewCourse: UIView!
    @IBOutlet weak var viewYear: UIView!
    @IBOutlet weak var viewSpeakes: UIView!
    @IBOutlet weak var viewFriends: UIView!
    
    @IBOutlet weak var textAbout: UITextField!
    @IBOutlet weak var textUniversity: UITextField!
    @IBOutlet weak var textCourse: UITextField!
    @IBOutlet weak var textYear: UITextField!
    @IBOutlet weak var textSpeakes: UITextField!
    @IBOutlet weak var textFriends: UITextField!
    
    @IBOutlet weak var btnUpdateProfile: UIButton!
    
    let DROPDOWN_UNIVERSITY = 101
    
    var arrPickerData = [Any]()
    var pickerView: UIPickerView?
    
    var imageProfile:UIImage!
    
    var isEditData:Bool = false
    var user_pass_id = ""
    var title_text = ""
    var receiverID = ""
    // MARK: - Init
    static func initViewController() -> MyProfileController {
        let sb = UIStoryboard(name: "LeftSideMenu", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "MyProfileController") as? MyProfileController else{
            return UIViewController() as! MyProfileController
        }
        return controller
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.layer.frame.height / 2
        self.imgProfilePic.clipsToBounds = true
        
        if !isEditData{
            btnBack.setImage(UIImage(named: "Back-Arrow"), for: .normal)
            btnBack.addTarget(self, action: #selector(BaseViewController.onBtnBackClicked(_:)), for: .touchUpInside)
            self.lblUsername.text = title_text
        }else{
            btnBack.setImage(UIImage(named: "Menu"), for: .normal)
            btnBack.addTarget(self, action: #selector(BaseViewController.onBtnMenuClicked(_:)), for: .touchUpInside)
            
            let account = AccountManager.Instance.activeAccount
            //self.lblUsername.text = account?.fullname
            
            if account?.fullname == ""{
                self.lblUsername.text = account?.username
            }else{
                self.lblUsername.text = account?.fullname
            }
            
            addRightView(toTextFeild: textUniversity, imageName: "Down")
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(MyProfileController.onBtnProfilePicClicked))
            self.imgProfilePic.addGestureRecognizer(tap1)
            self.imgProfilePic.isUserInteractionEnabled = true
        }
        
       
        
        self.giveCornerRadius(viewAbout)
        self.giveCornerRadius(viewUniversity)
        self.giveCornerRadius(viewCourse)
        self.giveCornerRadius(viewYear)
        self.giveCornerRadius(viewSpeakes)
        self.giveCornerRadius(viewFriends)
        
        self.giveCornerRadius(btnUpdateProfile)
        self.giveCornerRadius(btnAddFriend)
        self.giveCornerRadius(btnChat)
        
        
        
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        //loadUserDetail()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isEditData{
            textAbout.isEnabled = false
            textUniversity.isEnabled = false
            textCourse.isEnabled = false
            textYear.isEnabled = false
            textSpeakes.isEnabled = false
            textFriends.isEnabled = false
            btnUpdateProfile.isEnabled = false
            
            btnAddFriend.isHidden = false
            btnChat.isHidden = false
            btnUpdateProfile.isHidden = true
            
            lblTitle.text = title_text
            
            btnProfilePic.isHidden = true
            
        }else{
            btnAddFriend.isHidden = true
            btnChat.isHidden = true
            
            btnUpdateProfile.isHidden = false
             btnProfilePic.isHidden = false
            
            lblTitle.text = "My Profile"
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Load User Detail
    func loadData() {
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            let account = AccountManager.Instance.activeAccount
            
            account?.getUniversityList { (data, error) in
                SVProgressHUD.dismiss()
                
                guard error==nil else {
                    self.showAlert(withUserInfo: error?.userInfo, isLogin: false)
                    return
                }
                
                let value = data as? [String: Any]
                guard (value != nil),
                    let _ = value!["data"] as? [String: Any] else {
                        self.showAlert(withTestMessage:value!["message"] as? String)
                        return
                }
                
                let dataVal = value!["data"] as? [String: Any]
                self.arrPickerData = dataVal!["university_list"] as! [Any]
                
                self.loadUserDetail()
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
    func loadUserDetail() {
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            var isCurrentUser:Bool = false
            if !isEditData{
                param["user_id"] = user_pass_id
            }else{
                param["user_id"] = account?.user_id
                isCurrentUser = true
            }
            
            account?.getUserDetail(param,isCurrentUser, { (data, error) in
                SVProgressHUD.dismiss()
                
                guard error==nil else {
                    self.showAlert(withUserInfo: error?.userInfo, isLogin: false)
                    return
                }
                
                let value = data as? [String: Any]
                guard (value != nil),
                    let _ = value!["data"] as? [String: Any] else {
                        self.showAlert(withTestMessage:value!["message"] as? String)
                        return
                }
                
                if !self.isEditData{
                    
                    let dict = value!["data"] as? [String: Any]
                    
                    self.receiverID = (dict?["user_id"] as? String)!
                    
                    self.lblUniversityname.text = dict?["university_name"] as? String

                    self.textAbout.text = dict?["about"] as? String
                    self.textUniversity.text = dict?["university_name"] as? String
                    self.textUniversity.tag = Int(dict?["university_id"] as? String ?? "0")!
                    self.textCourse.text = dict?["course"] as? String
                    self.textYear.text = dict?["years"] as? String
                    self.textSpeakes.text = dict?["speakes"] as? String
                    self.textFriends.text = dict?["friends"] as? String

                    let image_url = dict?["profile_image"] as? String
                    if image_url != ""{
                        self.imgProfilePic.af_setImage(withURL: URL(string: image_url!)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
                    }
                    
//                    var arrImages = [Any]()
//
//                    if let _ = dict?["images"]{
//                        arrImages = dict?["images"] as! [Any]
//
//                        if (arrImages.count) > 0{
//                            self.imgProfilePic.af_setImage(withURL: URL(string: ((arrImages.last as! [String:Any])["image"] as? String)!)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
//                        }
//                    }
                    
                }else{
                    let act = AccountManager.Instance.activeAccount
                    
                    self.lblUniversityname.text = act?.university_name
                    
                    self.receiverID = "\(act?.user_id)"
                    
                    self.textAbout.text = act?.about
                    self.textUniversity.text = act?.university_name
                    self.textUniversity.tag = Int(act?.university_id ?? "0")!
                    self.textCourse.text = act?.course
                    self.textYear.text = act?.years
                    self.textSpeakes.text = act?.speakes
                    self.textFriends.text = act?.friends
                    
//                    if (act?.images.count)! > 0{
//                        self.imgProfilePic.af_setImage(withURL: URL(string: ((act?.images.last as! [String:Any])["image"] as? String)!)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
//                    }


                    let image_url = act?.profile_image
                    if image_url != ""{
                        self.imgProfilePic.af_setImage(withURL: URL(string: image_url!)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
                    }
                }
                
            })
            
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
    
    // MARK: - TextField Delegate
    //******************** TextField Delegate ********************//
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textUniversity {
            if arrPickerData.count > 0{
                textField.tintColor = UIColor.clear
                pickerView?.tag = DROPDOWN_UNIVERSITY
                openPicker(for: textUniversity)
            }
        }
        return true
    }
    
    func openPicker(for textField: UITextField?) {
        let date_accessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        date_accessory.tintColor = UIColor.white
        date_accessory.isTranslucent = false
        date_accessory.barTintColor = UIColor(hexString: "2698C4")
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let date_button = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(RegistrationController.showSelectedTitleFromPickerView))
        let cancel_button = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(RegistrationController.pickerViewDidCancel))
        date_accessory.items = [cancel_button, flexibleItem, date_button]
        textField?.inputView = pickerView
        textField?.inputAccessoryView = date_accessory
    }
    
    @IBAction func pickerViewDidCancel()  {
        self.view.endEditing(true)
    }
    @IBAction func showSelectedTitleFromPickerView()  {
        
        let row: Int = pickerView!.selectedRow(inComponent: 0)
        
        let dict:[String:Any] = self.arrPickerData[row] as! [String : Any]
        
        if  pickerView?.tag == DROPDOWN_UNIVERSITY {
            textUniversity.text = dict["name"] as? String
            textUniversity.tag = Int(dict["university_id"] as! String)!
        }
        self.view.endEditing(true)
    }
    // MARK: - IBAction
    @IBAction func onBtnAddFriendClicked(_ sender: UIButton) {
    }
    @IBAction func onBtnChatClicked(_ sender: UIButton) {
        let controller:ChatController = ChatController.initViewController()
        controller.reciverID = receiverID
        controller.title_text = self.title_text
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func onBtnProfilePicClicked(_ sender: UIButton) {
        self.addPhoto({ (success, object) in
            if success{
                DispatchQueue.main.async {
                    
                    self.imageProfile = (object as? UIImage)!
                    self.imgProfilePic.image = self.imageProfile
                    
//                    let image = object as? UIImage
//                    self.imgProfilePic.image = image
//
//                    //Image Upload task remaining......
//
//                    let size = CGSize(width: 100.0, height: 100.0)
//
//                   guard let smallImage = image?.af_imageAspectScaled(toFill: size) else{
//                        return
//                    }
                   
                }
            }
        })
    }
    @IBAction func setCoverPic(_ sender: UIView) {
        self.addPhoto({ (success, object) in
            if success{
                DispatchQueue.main.async {
                    
                    let image = object as? UIImage
                    self.imgCoverPic.image = image
                }
            }
        })
    }
   
    @IBAction func onBtnUpdateProfileClicked(_ sender: UIButton) {
        
        if textAbout.text == "" || textAbout.text == nil {
            self.showAlert(withTestMessage: "Please enter about")
            return
        }else if textUniversity.text == "" || textUniversity.text == nil {
            self.showAlert(withTestMessage: kEMPTY_REGISTRATION_UNIVERSITY)
            return
        }else if textCourse.text == "" || textCourse.text == nil {
            self.showAlert(withTestMessage: "Please enter Course")
            return
        }else if textYear.text == "" || textYear.text == nil {
            self.showAlert(withTestMessage: "Please enter year")
            return
        }else if textSpeakes.text == "" || textSpeakes.text == nil {
            self.showAlert(withTestMessage: "Please enter language")
            return
        }else if textFriends.text == "" || textFriends.text == nil {
            self.showAlert(withTestMessage: "Please enter friends")
            return
        }
        
        uploadProfilePic()
        
    }
    
    func uploadProfilePic() {
        if self.imageProfile != nil {
            let imageData = UIImageJPEGRepresentation(self.imgProfilePic.image!, 0.5)
            
            if(AppDelegate.sharedInstance.isReachable()){
                SVProgressHUD.show()
                
                let account = AccountManager.Instance.activeAccount
                
                account?.updateProfileImage(imageData, withBlock: { (data, error) in
                    SVProgressHUD.dismiss()
                    guard error==nil else {
                        self.showAlert(withUserInfo: error?.userInfo, isLogin: false)
                        return
                    }
                    
                    let value = data as? [String: Any]
                    guard (value != nil),
                        let _ = value!["data"] as? [String: Any] else {
                            self.showAlert(withTestMessage:value!["message"] as? String)
                            return
                    }
                    
                    if let arrImg = value!["data"] as? [String: Any]{
                        if let strImg = arrImg["image"] as? String{
                            print("image name ==> \(strImg)")
                            let arrImage:[Any] = [["image":strImg]]
                            self.uploadProfileDetail(arrImage)
                        }
                    }
                    
                })
            }else{
                self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
            }
        }else{
            let arrImage:[Any] = []
            self.uploadProfileDetail(arrImage)
        }
    }
    
    func uploadProfileDetail(_ arrImage:[Any]) {
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            param["user_id"] = account?.user_id
            param["about"] = self.textAbout.text
            param["university_id"] = "\(textUniversity.tag)"
            param["course"] = self.textCourse.text
            param["years"] = self.textYear.text
            param["speakes"] = self.textSpeakes.text
            param["friends"] = self.textFriends.text
            if(arrImage.count > 0){
                param["profile_image"] = (arrImage[0] as! [String:Any])["image"] as? String
                param["images"] = arrImage
            }
            
            
            account?.updateProfile(param, { (data, error) in
                SVProgressHUD.dismiss()
                
                guard error==nil else {
                    self.showAlert(withUserInfo: error?.userInfo, isLogin: false)
                    return
                }
                
                let value = data as? [String: Any]
                guard (value != nil) else {
                        self.showAlert(withTestMessage:value!["message"] as? String)
                        return
                }
                
                //self.showAlert(withTestMessage:value!["message"] as? String)
                //self.loadUserDetail()
                
                let act:Account = AccountManager.Instance.activeAccount!
                
                
                act.university_id = "\(self.textUniversity.tag)"
                act.university_name = self.textUniversity.text!
                
                if(arrImage.count > 0){
                    act.profile_image = "http://jobandoffers.com/demo/unify/upload/images/\((arrImage[0] as! [String:Any])["image"] ?? "")"//((arrImage[0] as! [String:Any])["image"] as? String)!
                }
                
                if let id = self.textAbout.text{
                    act.about = id
                }else{
                    act.about = ""
                }
                
                if let id = self.textYear.text{
                    act.years = id
                }else{
                    act.years = ""
                }
                if let id = self.textCourse.text{
                    act.course = id
                }else{
                    act.course = ""
                }
                if let id = self.textSpeakes.text{
                    act.speakes = id
                }else{
                    act.speakes = ""
                }
                if let id = self.textFriends.text{
                    act.friends = id
                }else{
                    act.friends = ""
                }
            
                AccountManager.Instance.activeAccount = act
                
            })
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
}

// MARK: -
extension MyProfileController: UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if  pickerView.tag == DROPDOWN_UNIVERSITY {
            return self.arrPickerData.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let dict:[String:Any] = self.arrPickerData[row] as! [String : Any]
        
        if  pickerView.tag == DROPDOWN_UNIVERSITY {
            return dict["name"] as? String
        }
        
        return ""
    }
}
