//
//  ForgotPasswordController.swift
//  Unify
//
//  Created by Priyanka Patel  on 8/15/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordController: BaseViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var btnResetPassword: UIButton!
    
    
    @IBOutlet weak var viewEmail: UIView!
    
    // MARK: - Init
    static func initViewController() -> ForgotPasswordController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "ForgotPasswordController") as? ForgotPasswordController else{
            return UIViewController() as! ForgotPasswordController
        }
        return controller
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.giveCornerRadius(viewEmail)
        self.giveCornerRadius(btnResetPassword)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -IBAction
    @IBAction func onBtnResetPasswordClicked(_ sender: UIButton) {
        if textEmail.text == "" || textEmail.text == nil {
            self.showAlert(withTestMessage: kEMPTY_FORGOT_PASSWORD_EMAIL)
            return
        }
        
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = Account()
            
            var param:[String : Any] = [:]
            
            param["email"] = textEmail.text
           
            account.forgotPassword(param) { (data, error) in
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
                
                ShowAlertClass.init().showAlert(withTitle: kAppName, message: value!["message"] as? String , handler: { (_ buttonIndex: Int) in
                    
                }, withAlertButtons: [kALERT_OK], target: self)
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
}
