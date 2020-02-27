//
//  SideMenuController.swift
//  PillDoctor
//
//  Created by Priyanka Patel on 01/05/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import UIKit
import SVProgressHUD

class SideMenuController: BaseViewController {

    @IBOutlet weak var tblSideMenuView: UITableView!

    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var imgCoverPic: UIImageView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUniversityname: UILabel!
    
    var arrTitle:NSArray!
    var arrImage:NSMutableArray!
    var arrTemp :NSMutableArray!
    
    // MARK: - Init
    static func initViewController() -> SideMenuController {
        let sb = UIStoryboard(name: "LeftSideMenu", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController else{
            return UIViewController() as! SideMenuController
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrTitle = [kTITLE_BADGE,
                    kTITLE_GROUPS,
                    kTITLE_MESSAGE,
                    kTITLE_NOTIFICATIONS,
                    kTITLE_INTERESTS,
                    kTITLE_DISCOUNTS,
                    kTITLE_HELP,
                    kTITLE_SHARE_APP,
                    kTITLE_CHANGE_PASSWORD,
                    kTITLE_LOGOUT]
     
        arrImage = ["ic_sm_Badge","ic_sm_Groups","ic_sm_Message","ic_sm_Notification","ic_sm_Interests","ic_sm_Discounts","ic_sm_Help","ic_sm_ShareThisApp","ic_sm_Logout","ic_sm_Logout"]

        let tap = UITapGestureRecognizer(target: self, action: #selector(SideMenuController.redirectMyProfile))
        self.imgProfilePic.addGestureRecognizer(tap)
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let account = AccountManager.Instance.activeAccount
        //self.lblUsername.text = account?.fullname
        
        if account?.fullname == ""{
            self.lblUsername.text = account?.username
        }else{
            self.lblUsername.text = account?.fullname
        }
        
        self.lblUniversityname.text = account?.university_name
        
//        if (account?.images.count)! > 0{
//            //self.imgProfilePic.af_setImage(withURL: URL(string: ((account?.images.last as! [String:Any])["image"] as? String)!)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
//
//            self.imgProfilePic.af_setImage(withURL: URL(string: ((account?.images.last as! [String:Any])["image"] as? String)!)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER)) { (_) in
//                self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.layer.frame.height / 2
//                self.imgProfilePic.clipsToBounds = true
//            }
//
//        }else{
//             self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.layer.frame.height / 2
//        }
        
        let image_url = account?.profile_image
        if image_url != ""{
            self.imgProfilePic.af_setImage(withURL: URL(string: image_url!)!, placeholderImage: UIImage(named: kPROFILE_PLACEHOLDER))
            self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.layer.frame.height / 2
            self.imgProfilePic.clipsToBounds = true

        }else{
            self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.layer.frame.height / 2
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -
    func logoutPermission() {
        weak var weakself: SideMenuController? = self
        ShowAlertClass.init().showAlert(withTitle: kAppName, message: kLOGOUT_PERMITION, handler: { (_ buttonIndex: Int) in
            if buttonIndex == 1 {
                weakself?.logout()
            }
        }, withAlertButtons: [kALERT_NO, kALERT_YES], target: self)
    }
    func logout() {
        if(AppDelegate.sharedInstance.isReachable()){
            SVProgressHUD.show()
            let account = AccountManager.Instance.activeAccount
            
            var param:[String : Any] = [:]
            
            param["user_id"] = account?.user_id
            
            account?.logoutUser(param, { (data, error) in
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
                
                AppDelegate.sharedInstance.logout()
                
            })
            
        }else{
            self.showAlert(withTestMessage: kNO_CONNECTION_MESSAGE)
        }
    }
    
    @objc func redirectMyProfile() {
        mm_drawerController.closeDrawer(animated: true, completion: {(_ finished: Bool) -> Void in
            let controller:MyProfileController = MyProfileController.initViewController()
            controller.isEditData = true
            self.mm_drawerController.setCenterView(controller, withCloseAnimation: true, completion: nil)
        })
    }
}

// MARK: - UITableViewDataSource
extension SideMenuController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrTitle.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SideMenuCell.self), for: indexPath) as? SideMenuCell else {
            preconditionFailure("Unregistered table view cell")
        }
        
        cell.lblTitle.text = arrTitle.object(at: indexPath.row) as? String
        cell.imgView.image = UIImage(named: arrImage.object(at: indexPath.row) as! String)
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return viewHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let strTitle = arrTitle.object(at: indexPath.row) as? String
        
        mm_drawerController.closeDrawer(animated: true, completion: {(_ finished: Bool) -> Void in
            if strTitle == kTITLE_BADGE {
                let controller:QuestionsController = QuestionsController.initViewController()
                self.mm_drawerController.setCenterView(controller, withCloseAnimation: true, completion: nil)
            }else if strTitle == kTITLE_LOGOUT {
                self.logoutPermission()
            }else if strTitle == kTITLE_CHANGE_PASSWORD{
                let controller:ChangePasswordController = ChangePasswordController.initViewController()
                self.mm_drawerController.setCenterView(controller, withCloseAnimation: true, completion: nil)
            }else if strTitle == kTITLE_MESSAGE{
                let controller:MessagesController = MessagesController.initViewController()
                self.mm_drawerController.setCenterView(controller, withCloseAnimation: true, completion: nil)
            }
        })
    }
}
extension SideMenuController:UIScrollViewDelegate {
    //Refer demo here
    //Creating a sticky header for a UITableView
    //https://medium.com/@jeremysh/creating-a-sticky-header-for-a-uitableview-40af71653b55
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y < 0 {
            self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.layer.frame.height / 2
            self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if self.headerHeightConstraint.constant > 160 {
            animateHeader()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       
        if self.headerHeightConstraint.constant > 160 {
            animateHeader()
        }
    }
    
    func animateHeader() {
        self.headerHeightConstraint.constant = 160
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.layer.frame.height / 2
        }, completion: nil)
    }
}

