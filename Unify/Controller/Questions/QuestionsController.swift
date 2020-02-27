//
//  QuestionsController.swift
//  Unify
//
//  Created by Phycom  on 8/21/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import SVProgressHUD

class QuestionsController: BaseViewController {

    @IBOutlet weak var tblQuestionList: UITableView!
    // MARK: - Init
    static func initViewController() -> QuestionsController {
        let sb = UIStoryboard(name: "LeftSideMenu", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "QuestionsController") as? QuestionsController else{
            return UIViewController() as! QuestionsController
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tblQuestionList.estimatedRowHeight = 500;
        self.tblQuestionList.rowHeight = UITableViewAutomaticDimension;
        
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
           
            QuestionList.sharedInstance.loadQuestionsList(param) { (data, error) in
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
                
                self.tblQuestionList.reloadData()
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
}

extension QuestionsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuestionList.sharedInstance.getQuestionList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuestionsListCell.self), for: indexPath) as? QuestionsListCell else {
            preconditionFailure("Unregistered table view cell")
        }
        
        let dict:QuestionListInfo = QuestionList.sharedInstance.getQuestionList()[indexPath.row] as! QuestionListInfo
        
        if dict.fullname == ""{
            cell.lblUsername.text = dict.username
        }else{
            cell.lblUsername.text = dict.fullname
        }
        //cell.lblUniversityName.text =
        
        if dict.profile_image != ""{
             cell.imgProfile.af_setImage(withURL: URL(string: dict.profile_image)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
        }
        
//        if dict.image != ""{
//            cell.imgProfile.af_setImage(withURL: URL(string: dict.image)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
//        }
        
       
        cell.lblTime.text = dict.timeago
        cell.lblUniversityName.text = dict.university_name
        cell.lblQueDetails.text = dict.question_title
        
        cell.btnUpvote.tag = indexPath.row
        cell.btnUpvote.addTarget(self, action: #selector(QuestionsController.onBtnLikeClicked(_:)), for: .touchUpInside)
        
        //20 Upvotes  15 Answer 2 Shares
        //total_answer
        //total_share
        // like_question
        
         cell.lblTotalUpvotes.text = "\(dict.total_like) Upvotes"
         cell.lblTotalAnswer.text = "\(dict.total_answer) Answer"
        // cell.lblTotalShare.text = "\(dict.total_share) Shares"
        cell.lblTotalShare.text = ""
        
        if dict.like_question == "0"{
            cell.btnUpvote.isSelected = false
            if let image = UIImage(named:"Unlike") {
                cell.btnUpvote.setImage(image, for: .normal)
            }
            cell.btnUpvote.setTitle("Vote", for: .normal)


        }else{
            cell.btnUpvote.isSelected = true

            if let image = UIImage(named:"Like") {
                cell.btnUpvote.setImage(image, for: .normal)
            }
            cell.btnUpvote.setTitle("Upvote", for: .normal)
        }
        
        cell.btnAnswer.tag = indexPath.row
        cell.btnAnswer.addTarget(self, action: #selector(QuestionsController.onBtnAnswerClicked(_:)), for: .touchUpInside)

        cell.btnShare.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(QuestionsController.onBtnShareClicked(_:)), for: .touchUpInside)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(QuestionsController.onLblUsernameClicked(_:)))
        cell.lblUsername.addGestureRecognizer(tap1)
        cell.lblUsername.tag = indexPath.row
        cell.lblUsername.isUserInteractionEnabled = true
        
        if dict.user_id == "\(AccountManager.Instance.activeAccount?.user_id ?? 0)" {
            cell.btnMore.isHidden = false
        }else{
            cell.btnMore.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - IBAction
    @IBAction func onBtnLikeClicked(_ sender: UIButton) {
        
        if sender.isSelected {
            setUnlikeState(sender)
        }else{
            setLikeState(sender)
        }
    }
    @IBAction func onBtnAnswerClicked(_ sender: UIButton) {
         let dict:QuestionListInfo = QuestionList.sharedInstance.getQuestionList()[sender.tag] as! QuestionListInfo
        
        let controller:AnswerController = AnswerController.initViewController()
        controller.questionID = dict.question_id
        controller.questionTitle = dict.question_title
        navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func onLblUsernameClicked(_ sender: UITapGestureRecognizer) {
        let lblName:UILabel = sender.view as! UILabel
        let dict:QuestionListInfo = QuestionList.sharedInstance.getQuestionList()[lblName.tag] as! QuestionListInfo
        
        let controller:MyProfileController = MyProfileController.initViewController()
        controller.isEditData = false
        controller.user_pass_id = dict.user_id
        if dict.username == ""{
            controller.title_text = dict.fullname
        }else{
            controller.title_text = dict.username
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //a5bikpnkuu
    
    @IBAction func onBtnShareClicked(_ sender: UIButton) {
         let dict:QuestionListInfo = QuestionList.sharedInstance.getQuestionList()[sender.tag] as! QuestionListInfo
        
        // set up activity view controller
        let textToShare = [dict.question_title]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Like,Unlke Api Call
    func setLikeState(_ sender: UIButton)  {
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let dict:QuestionListInfo = QuestionList.sharedInstance.getQuestionList()[sender.tag] as! QuestionListInfo
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            param["user_id"] = account?.user_id//dict.user_id//account?.user_id
            param["question_id"] = dict.question_id
            
            QuestionList.sharedInstance.likeQuestion(param) { (data, error) in
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
                
                let btnPos:CGPoint = sender.convert(CGPoint.zero, to: self.tblQuestionList)
                let indexPath = self.tblQuestionList.indexPathForRow(at: btnPos)
                
                guard let cell = self.tblQuestionList.cellForRow(at: indexPath!) as? QuestionsListCell else{
                    return
                }
                
                dict.like_question = "1"
                dict.total_like = "\(Int(dict.total_like)! + 1)"
                QuestionList.sharedInstance.arrGetQuestions[sender.tag] = dict
                
//                cell.btnUpvote.isSelected = true
//                if let image = UIImage(named:"Like") {
//                    cell.btnUpvote.setImage(image, for: .normal)
//                }
//                cell.btnUpvote.setTitle("Upvote", for: .normal)
                
                self.tblQuestionList.reloadData()
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
    func setUnlikeState(_ sender: UIButton)  {
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            
            let dict:QuestionListInfo = QuestionList.sharedInstance.getQuestionList()[sender.tag] as! QuestionListInfo
            
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            param["user_id"] = account?.user_id
            param["question_id"] = dict.question_id
            
            QuestionList.sharedInstance.unlikeQuestion(param) { (data, error) in
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
                
                let btnPos:CGPoint = sender.convert(CGPoint.zero, to: self.tblQuestionList)
                let indexPath = self.tblQuestionList.indexPathForRow(at: btnPos)
                
                guard let cell = self.tblQuestionList.cellForRow(at: indexPath!) as? QuestionsListCell else{
                    return
                }
                
                dict.like_question = "0"
                dict.total_like = "\(Int(dict.total_like)! - 1)"
                QuestionList.sharedInstance.arrGetQuestions[sender.tag] = dict
                
//                cell.btnUpvote.isSelected = false
//                if let image = UIImage(named:"Unlike") {
//                    cell.btnUpvote.setImage(image, for: .normal)
//                }
//                cell.btnUpvote.setTitle("Vote", for: .normal)
                
                 self.tblQuestionList.reloadData()
            }
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
}
