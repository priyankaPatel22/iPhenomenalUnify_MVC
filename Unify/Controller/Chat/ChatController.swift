//
//  ChatController.swift
//  Unify
//
//  Created by Phycom  on 9/9/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChatController: BaseViewController {

    @IBOutlet weak var lblUserTitle: UILabel!
    
    @IBOutlet weak var tblChat: UITableView!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var textMessage: UITextField!
    
    var reciverID = ""
    var title_text = ""
    
    var timer:Timer = Timer()
    
    // MARK: - Init
    static func initViewController() -> ChatController {
        let sb = UIStoryboard(name: "LeftSideMenu", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "ChatController") as? ChatController else{
            return UIViewController() as! ChatController
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblUserTitle.text = title_text
        loadChatData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tblChat.estimatedRowHeight = 50;
        self.tblChat.rowHeight = UITableViewAutomaticDimension;
        
        viewText.layer.cornerRadius = 5
        viewText.layer.borderColor = UIColor.black.cgColor
        viewText.layer.borderWidth = 1
        btnSend.layer.cornerRadius = 5
        
        timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(ChatController.loadChatData), userInfo: nil, repeats: false)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadChatData() {
        if(AppDelegate.sharedInstance.isReachable()){
            //SVProgressHUD.show()
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            //{"data":{"user_id":"1","oldpassword":"123456","newpassword":"123456"}}
            
            param["user_id"] = account?.user_id
            param["receiver_id"] = reciverID//"2"//reciverID
            
            ChatList.sharedInstance.getChatDetailList(param) { (data, error) in
                //SVProgressHUD.dismiss()
                
//                guard error==nil else {
//                    self.showAlert(withUserInfo: error?.userInfo, isLogin: false)
//                    return
//                }
//
//                let value = data as? [String: Any]
//                guard (value != nil) else {
//                    self.showAlert(withTestMessage:value!["message"] as? String)
//                    return
//                }
                
                self.tblChat.reloadData()
                self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ChatController.loadChatData), userInfo: nil, repeats: false)
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
    
    // MARK:- IBAction
    @IBAction func onBtnAddClicked(_ sender: UIButton) {
    }
    @IBAction func onBtnSendClicked(_ sender: UIButton) {
        if textMessage.text == "" || textMessage.text == nil {
            self.showAlert(withTestMessage: "Please enter text message")
            return
        }
        
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            //{"data":{"sender_id":"1","receiver_id":"2","message":"test","image":"test.png"}}
            
            param["sender_id"] = reciverID//account?.user_id
            param["receiver_id"] = account?.user_id//reciverID //"2"//reciverID
            param["message"] = textMessage.text
            param["image"] = "test.png"
            
            ChatList.sharedInstance.sendMessage(param) { (data, error) in
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
                
                self.textMessage.text = ""
                self.tblChat.reloadData()
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
    
}
extension ChatController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatList.sharedInstance.getChatDetailList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict:ChatDetailInfo = ChatList.sharedInstance.getChatDetailList()[indexPath.row] as! ChatDetailInfo
        
        let act = AccountManager.Instance.activeAccount
        if dict.receiver_id == "\(act?.user_id ?? 0)" {
//        if dict.is_sender == "0"{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReceiverChatCell.self), for: indexPath) as? ReceiverChatCell else {
                preconditionFailure("Unregistered table view cell")
            }
            
            if dict.sender_image != ""{
                cell.imgProfilePic.af_setImage(withURL: URL(string: dict.sender_image)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
            }
            
            //cell.viewMessageBg.translatesAutoresizingMaskIntoConstraints = true
            //cell.lblDate.layer.masksToBounds = false;
            //cell.lblDate.clipsToBounds = false;
            
            cell.lblMessage.text = dict.message
            cell.lblDate.text = dict.messagetime
            
           // cell.viewMessageBg.translatesAutoresizingMaskIntoConstraints = true
            //viewMessageBg.layer.masksToBounds = false
//
//            let path = UIBezierPath(roundedRect:cell.viewMessageBg.bounds,
//                                    byRoundingCorners:[.topRight, .topLeft, .bottomLeft],
//                                    cornerRadii: CGSize(width: 10, height:  10))
//
//            let maskLayer = CAShapeLayer()
//
//            maskLayer.path = path.cgPath
//            maskLayer.frame = cell.viewMessageBg.bounds
//            cell.viewMessageBg.layer.mask = maskLayer

            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SenderChatCell.self), for: indexPath) as? SenderChatCell else {
                preconditionFailure("Unregistered table view cell")
            }
            
           // cell.lblDate.layer.masksToBounds = false;
//            
////            cell.viewMessageBg.translatesAutoresizingMaskIntoConstraints = false
////
            cell.lblMessage.text = dict.message
            cell.lblDate.text = dict.messagetime

           // cell.setNeedsDisplay()
            //
//            cell.viewMessageBg.translatesAutoresizingMaskIntoConstraints = true
            //viewMessageBg.layer.masksToBounds = false

//            let path = UIBezierPath(roundedRect:cell.viewMessageBg.bounds,
//                                    byRoundingCorners:[.topRight, .topLeft, .bottomLeft],
//                                    cornerRadii: CGSize(width: 10, height:  10))
//
//            let maskLayer = CAShapeLayer()
//
//            maskLayer.path = path.cgPath
//            maskLayer.frame = cell.viewMessageBg.bounds
//            cell.viewMessageBg.layer.mask = maskLayer
//
//            cell.setNeedsDisplay()
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
