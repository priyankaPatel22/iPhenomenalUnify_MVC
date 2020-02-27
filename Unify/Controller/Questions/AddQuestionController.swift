//
//  AddQuestionController.swift
//  Unify
//
//  Created by Phycom  on 8/22/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddQuestionController: BaseViewController {

    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUniName: UILabel!
    
    @IBOutlet weak var viewCircle1: UIView!
    @IBOutlet weak var viewCircle2: UIView!
    @IBOutlet weak var viewCircle3: UIView!
    
    @IBOutlet weak var viewBg: UIView!
    
    @IBOutlet weak var btnAskQuestions: UIButton!
    
    @IBOutlet weak var textQuestionTitle: UITextView!
    
    @IBOutlet weak var btnCheckbox: UIButton!
    
    
    
    // MARK: - Init
    static func initViewController() -> AddQuestionController {
        let sb = UIStoryboard(name: "LeftSideMenu", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "AddQuestionController") as? AddQuestionController else{
            return UIViewController() as! AddQuestionController
        }
        return controller
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.giveCornerRadius(viewBg)
        self.giveCornerRadius(btnAskQuestions)
        
        viewCircle1.layer.cornerRadius = viewCircle1.layer.frame.height/2
        viewCircle2.layer.cornerRadius = viewCircle2.layer.frame.height/2
        viewCircle3.layer.cornerRadius = viewCircle3.layer.frame.height/2
        
        let account = AccountManager.Instance.activeAccount
        //self.lblUserName.text = account?.fullname
        self.lblUniName.text = account?.university_name
        
        if account?.fullname == ""{
            self.lblUserName.text = account?.username
        }else{
            self.lblUserName.text = account?.fullname
        }
        
//        if (account?.images.count)! > 0{
//            self.profilePic.af_setImage(withURL: URL(string: ((account?.images.last as! [String:Any])["image"] as? String)!)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER)) { (_) in
//                self.profilePic.layer.cornerRadius = self.profilePic.layer.frame.height / 2
//                self.profilePic.clipsToBounds = true
//            }
//            
//        }else{
//            self.profilePic.layer.cornerRadius = self.profilePic.layer.frame.height / 2
//        }
        
        let image_url = account?.profile_image
        if image_url != ""{
            self.profilePic.af_setImage(withURL: URL(string: image_url!)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
            self.profilePic.layer.cornerRadius = self.profilePic.layer.frame.height / 2
            self.profilePic.clipsToBounds = true
            
        }else{
            self.profilePic.layer.cornerRadius = self.profilePic.layer.frame.height / 2
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBtnCheckboxClicked(_ sender: UIButton) {
        if(btnCheckbox.tag==1){
            btnCheckbox.tag=2
            btnCheckbox.setImage(UIImage(named: "ic_check"), for: .normal)
        }else{
            btnCheckbox.tag=1
            btnCheckbox.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        }
    }
    
    @IBAction func onBtnAskQuestions(_ sender: UIButton) {
        if textQuestionTitle.text == "" || textQuestionTitle.text == nil {
            self.showAlert(withTestMessage: kEMPTY_ADD_QUESTION_TITLE)
            return
        }
        
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            param["user_id"] = account?.user_id
            param["question_title"] = textQuestionTitle.text
            param["image"] = "sojitra"
            param["video"] = "asd@gmail.com"
            
            QuestionList.sharedInstance.addQuestion(param) { (data, error) in
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
                
                ShowAlertClass.init().showAlert(withTitle: kAppName, message: value!["message"] as? String , handler: { (_ buttonIndex: Int) in
                    self.navigationController?.popViewController(animated: true)
                }, withAlertButtons: [kALERT_OK], target: self)
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
   

}
