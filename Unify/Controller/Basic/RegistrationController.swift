//
//  RegistrationController.swift
//  Unify
//
//  Created by Priyanka Patel  on 8/15/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegistrationController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var textFullName: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textUniversity: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    
    @IBOutlet weak var btnResetPassword: UIButton!
    
    @IBOutlet weak var viewFullName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewUniversity: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    let DROPDOWN_UNIVERSITY = 101
    
    var arrPickerData = [Any]()
    var pickerView: UIPickerView?
    
    // MARK: - Init
    static func initViewController() -> RegistrationController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "RegistrationController") as? RegistrationController else{
            return UIViewController() as! RegistrationController
        }
        return controller
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.giveCornerRadius(viewFullName)
        self.giveCornerRadius(viewEmail)
        self.giveCornerRadius(viewUniversity)
        self.giveCornerRadius(viewPassword)
        self.giveCornerRadius(btnResetPassword)
        
        addRightView(toTextFeild: textUniversity, imageName: "Down")
        
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Load University data
    func loadData() {
        if(AppDelegate.sharedInstance.isReachable()){
            
            let account = Account()
            
            account.getUniversityList { (data, error) in
                
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
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
    // MARK: -IBAction
    @IBAction func onBtnResetPasswordClicked(_ sender: UIButton) {
        
        if textFullName.text == "" || textFullName.text == nil {
            self.showAlert(withTestMessage: kEMPTY_REGISTRATION_FULLNAME)
            return
        }else if textEmail.text == "" || textEmail.text == nil {
            self.showAlert(withTestMessage: kEMPTY_REGISTRATION_EMAIL)
            return
        }else if textUniversity.text == "" || textUniversity.text == nil {
            self.showAlert(withTestMessage: kEMPTY_REGISTRATION_UNIVERSITY)
            return
        }else if textPassword.text == "" || textPassword.text == nil {
            self.showAlert(withTestMessage: kEMPTY_REGISTRATION_PASSWORD)
            return
        }
        
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = Account()
            
            var param:[String : Any] = [:]
            
            /*
            "username": "krunalsojitra",
            "fullname": "krunal sojitra",
            "university_name":"teset",
            "email": "ksojitra00023@gmail.com",
            "password": "123456",
            "university_id":"1",
            "images": [
            {"image": "1.png"},
            {"image": "2.png"}
            ]
            */
            
            param["fullname"] = textFullName.text
            param["university_name"] = textUniversity.text
            param["email"] = textEmail.text
            param["password"] = textPassword.text
            param["university_id"] = "\(textUniversity.tag)"
            
            account.registerUser(param) { (data, error) in
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

    @IBAction func onBtnLoginClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            //textUniversity.tag = (dict["university_id"] as? Int)!
            textUniversity.tag = Int(dict["university_id"] as! String)!
        }
        self.view.endEditing(true)
    }
}

// MARK: -
extension RegistrationController: UIPickerViewDataSource,UIPickerViewDelegate{
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
