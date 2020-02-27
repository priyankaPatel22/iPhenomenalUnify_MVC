//
//  NavigationViewController.swift
//  Unify
//
//  Created by Phycom  on 8/21/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    static func initViewController() -> UINavigationController {
        let sb = UIStoryboard(name: "LeftSideMenu", bundle: nil)
        guard let controller = sb.instantiateViewController(withIdentifier: "NavigationViewController") as? NavigationViewController else{
            return UINavigationController()
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
