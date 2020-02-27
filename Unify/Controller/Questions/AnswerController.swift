//
//  AnswerController.swift
//  Unify
//
//  Created by Phycom  on 8/22/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import  SVProgressHUD

class AnswerController: BaseViewController {

    @IBOutlet weak var lblMainQuestion: UILabel!
    @IBOutlet weak var tblAnswer: UITableView!
    @IBOutlet weak var btnPostAnswer: UIButton!
    
    var questionTitle = ""
    var questionID = ""
    
    // MARK: - Init
    static func initViewController() -> AnswerController {
        let sb = UIStoryboard(name: "LeftSideMenu", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "AnswerController") as? AnswerController else{
            return UIViewController() as! AnswerController
        }
        return controller
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.giveCornerRadius(btnPostAnswer)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblMainQuestion.text = questionTitle
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - load data
    func loadData() {
       
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            param["user_id"] = account?.user_id
            param["question_id"] = self.questionID
            
            QuestionList.sharedInstance.loadAnswerList(param) { (data, error) in
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
                
                self.tblAnswer.reloadData()
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
    
    @IBAction func onBtnPostAnswer(_ sender: UIButton) {
        
       let indexPath = IndexPath(row: 0, section: 0)
        
        guard let cell = self.tblAnswer.cellForRow(at: indexPath) as? AnswerCell else{
            return
        }
        
        if cell.textAnswer.text == "" || cell.textAnswer.text == nil {
            self.showAlert(withTestMessage: "Please enter answer")
            return
        }
        
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
          
            
            param["question_id"] = self.questionID
            param["user_id"] = account?.user_id
            param["answer"] = cell.textAnswer.text
            param["image"] = "sojitra"
            param["video"] = "asd@gmail.com"
            
            QuestionList.sharedInstance.addAnswer(param) { (data, error) in
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
                
                self.loadData()
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
}

extension AnswerController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
           return 1
        }else{
            return QuestionList.sharedInstance.getAnswerList().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AnswerCell.self), for: indexPath) as? AnswerCell else {
                preconditionFailure("Unregistered table view cell")
            }
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AnswerListCell.self), for: indexPath) as? AnswerListCell else {
                preconditionFailure("Unregistered table view cell")
            }
        
            let dict:AnswerListInfo = QuestionList.sharedInstance.getAnswerList()[indexPath.row] as! AnswerListInfo
            
            //cell.lblUsername.text = dict.username
            cell.lblTime.text = dict.timeago
            cell.lblAnswer.text = dict.answer
            
            if dict.fullname == ""{
                cell.lblUsername.text = dict.username
            }else{
                cell.lblUsername.text = dict.fullname
            }
            
//            if dict.video != ""{
//                cell.imgProfile.af_setImage(withURL: URL(string: dict.video)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
//            }

            if dict.profile_image != ""{
                cell.imgProfile.af_setImage(withURL: URL(string: dict.profile_image)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
            }
            
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
