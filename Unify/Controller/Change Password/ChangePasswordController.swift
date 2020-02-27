//
//  ChangePasswordController.swift
//  Unify
//
//  Created by Phycom  on 9/9/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordController: BaseViewController {

    @IBOutlet weak var viewOldPassword: UIView!
     @IBOutlet weak var viewNewPassword: UIView!
     @IBOutlet weak var viewConfirmPassword: UIView!
    
    @IBOutlet weak var textOldPassword: UITextField!
    @IBOutlet weak var textNewPassword: UITextField!
    @IBOutlet weak var textConfirmPassword: UITextField!
    
    @IBOutlet weak var btnChangePassword: UIButton!
    
    // MARK: - Init
    static func initViewController() -> ChangePasswordController {
        let sb = UIStoryboard(name: "LeftSideMenu", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "ChangePasswordController") as? ChangePasswordController else{
            return UIViewController() as! ChangePasswordController
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.giveCornerRadius(viewOldPassword)
        self.giveCornerRadius(viewNewPassword)
        self.giveCornerRadius(viewConfirmPassword)
        self.giveCornerRadius(btnChangePassword)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func clearText() {
        textOldPassword.text = ""
        textNewPassword.text = ""
        textConfirmPassword.text = ""
    }
    
    @IBAction func onBtnChangePasswordClicked(_ sender: UIButton) {
        if textOldPassword.text == "" || textOldPassword.text == nil {
            self.showAlert(withTestMessage: kEMPTY_OLD_PASSWORD)
            return
        }else if textNewPassword.text == "" || textNewPassword.text == nil {
            self.showAlert(withTestMessage: kEMPTY_NEW_PASSWORD)
            return
        }else if textConfirmPassword.text == "" || textConfirmPassword.text == nil {
            self.showAlert(withTestMessage: kEMPTY_CONFIRM_NEW_PASSWORD)
            return
        }else if textNewPassword.text != textConfirmPassword.text {
            self.showAlert(withTestMessage: kEMPTY_CONFIRM_NEW_PASSWORD_NOT_MATCH)
            return
        }
        
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            //{"data":{"user_id":"1","oldpassword":"123456","newpassword":"123456"}}
            
            param["user_id"] = account?.user_id
            param["oldpassword"] = textOldPassword.text
            param["newpassword"] = textNewPassword.text
            
            account?.changePassword(param) { (data, error) in
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
                    self.clearText()
                }, withAlertButtons: [kALERT_OK], target: self)
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
}
