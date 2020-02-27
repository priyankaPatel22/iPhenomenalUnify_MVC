//
//  LoginController.swift
//  Unify
//
//  Created by Priyanka Patel  on 8/15/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginController: BaseViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    
    
    // MARK: - Init
    static func initViewController() -> LoginController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "LoginController") as? LoginController else{
            return UIViewController() as! LoginController
        }
        return controller
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.giveCornerRadius(viewEmail)
        self.giveCornerRadius(viewPassword)
        self.giveCornerRadius(btnLogin)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: -IBAction
    
    @IBAction func onBtnForgotPasswordClicked(_ sender: UIButton) {
        let controller:ForgotPasswordController = ForgotPasswordController.initViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func onBtnLoginClicked(_ sender: UIButton) {
        
        if textEmail.text == "" || textEmail.text == nil {
            self.showAlert(withTestMessage: kEMPTY_LOGIN_EMAIL)
            return
        }else if textPassword.text == "" || textPassword.text == nil {
            self.showAlert(withTestMessage: kEMPTY_LOGIN_PASSWORD)
            return
        }
        
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = Account()
            
            var param:[String : Any] = [:]
            
            param["username"] = textEmail.text
            param["password"] = textPassword.text
            param["device_type"] = kDeviceType
            param["device_token"] = kSAMPLE_DEVICE_TOKEN
            
            account.loginUser(param) { (data, error) in
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
                
                //self.showAlert(withTestMessage:value!["message"] as? String)
                AppDelegate.sharedInstance.redirectDashboard()
            }
            
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
    @IBAction func onBtnSignUpClicked(_ sender: UIButton) {
        let controller:RegistrationController = RegistrationController.initViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
