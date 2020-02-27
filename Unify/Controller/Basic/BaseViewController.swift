//
//  BaseViewController.swift
//  ExtensionDemo
//
//  Created by Priyanka Patel on 14/05/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController {

    
    
    // MARK: - ShareIndtsnce
    static let sharedInstance = BaseViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation Buttion
    func addLeftMenuBarButton() {
        navigationItem.setHidesBackButton(true, animated: true)
        let menuitem = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(BaseViewController.onBtnMenuClicked(_:)))
        menuitem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = menuitem
    }
    func addLeftBarButton() {
        self.navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false)
        //navigationItem.setHidesBackButton(true, animated: true)
        let menuitem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(BaseViewController.onBtnBackClicked(_:)))
        menuitem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = menuitem
    }
   

    // MARK: - IBButton Action
    @IBAction func onBtnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onBtnMenuClicked(_ sender: UIButton) {
        view.endEditing(true)
        mm_drawerController.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
//    @IBAction func onBtnMenuClicked(_ sender: UIBarButtonItem) {
//        view.endEditing(true)
//
//    }
   
    // MARK: - showAlert
    func showAlert(withTestMessage testMsg: String?) {
        ShowAlertClass.init().showAlert(withTitle: kAppName, message: testMsg , handler: { (_ buttonIndex: Int) in

        }, withAlertButtons: [kALERT_OK], target: self)

    }
    func showAlert(withUserInfo userinfo: [AnyHashable: Any]?, isLogin:Bool) {
        if let message = userinfo!["message"] {
            let alertController = UIAlertController(title: kAppName, message: message as? String, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: kALERT_OK, style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            }))
            
            present(alertController, animated: true) {() -> Void in }
        }else{
            let alertController = UIAlertController(title: kAppName, message: "Some thing went wrong!", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: kALERT_OK, style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            }))
            
            present(alertController, animated: true) {() -> Void in }
        }
    }

    // MARK: - String Validation
    func isEmpty(_ str: String?) -> Bool {
        if str == nil {
            return true
        }
        let stringStr = "\(str ?? "")"
        let trimmed = stringStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmed.count == 0 {
            return true
        }
        if (stringStr == "<null>") || (stringStr == "(null)") {
            return true
        }
        return false
    }
    
    func addRightView(toTextFeild textfield: UITextField?, imageName: String? = "Down") {
        let arrow = UIImageView(image: UIImage(named: imageName ?? ""))
        arrow.frame = CGRect(x: (arrow.image?.size.width ?? 0.0) - 30.0, y: -10, width: 30, height: 30)
        arrow.contentMode = .center
        textfield?.rightView = arrow
        textfield?.rightViewMode = .always
    }
    func giveCornerRadius(_ view:AnyObject) {
        view.layer.cornerRadius = 5
        //view.clipsToBounds = true
        
        view.layer.shadowColor = UIColor(red: 180.0 / 255.0, green: 180.0 / 255.0, blue: 180.0 / 255.0, alpha: 0.7).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.5
    }
}

