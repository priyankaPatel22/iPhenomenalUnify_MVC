//
//  MessagesController.swift
//  Unify
//
//  Created by Phycom  on 9/9/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class MessagesController: BaseViewController {

    @IBOutlet weak var tblMessage: UITableView!
    
    // MARK: - Init
    static func initViewController() -> MessagesController {
        let sb = UIStoryboard(name: "LeftSideMenu", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "MessagesController") as? MessagesController else{
            return UIViewController() as! MessagesController
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadChatData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tblMessage.estimatedRowHeight = 500;
        self.tblMessage.rowHeight = UITableViewAutomaticDimension;
        self.tblMessage.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadChatData() {
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            param["user_id"] = account?.user_id
            
            ChatList.sharedInstance.getChatList(param) { (data, error) in
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
                
                self.tblMessage.reloadData()
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
   
}
extension MessagesController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatList.sharedInstance.getChatList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessagesCell.self), for: indexPath) as? MessagesCell else {
            preconditionFailure("Unregistered table view cell")
        }
        
         let dict:ChatListInfo = ChatList.sharedInstance.getChatList()[indexPath.row] as! ChatListInfo
        
        if dict.profile_image != ""{
            cell.imgProfilePic.af_setImage(withURL: URL(string: dict.profile_image)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
        }
        
        if dict.fullname == ""{
            cell.lblUsername.text = dict.username
        }else{
            cell.lblUsername.text = dict.fullname
        }
        
        cell.lblUniversityName.text = dict.university_name
        cell.lblStatusTitle.text = dict.message
        cell.lblTime.text = dict.timeago
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict:ChatListInfo = ChatList.sharedInstance.getChatList()[indexPath.row] as! ChatListInfo
        
        let controller:ChatController = ChatController.initViewController()
        controller.reciverID = dict.receiver_id
        if dict.fullname == ""{
            controller.title_text  = dict.username
        }else{
            controller.title_text  = dict.fullname
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
