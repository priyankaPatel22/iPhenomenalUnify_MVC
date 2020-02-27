//
//  AccountManager.swift
//  AlamofireDemo
//
//  Created by Priyanka Patel on 17/05/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import UIKit

class AccountManager: NSObject {

    let kActiveUserKey = "EncodedActiveClikUser"
     static let Instance = AccountManager()

    //var activeAccount: Account?
    var activeAccount: Account? = nil {
        willSet(activeAccount) {
            self.activeAccount = activeAccount
            saveAccount()
        }
        didSet {

        }
    }
    
    var savedAccounts = [AnyHashable: Any]()

    func accountFilename() -> String? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        return URL(fileURLWithPath: documentsPath ?? "").appendingPathComponent("Unify.dat").absoluteString
    }

    override init() {
        super.init()

        let accountData = UserDefaults.standard.object(forKey: kActiveUserKey) as? Data
        if accountData != nil {
            if let aData = accountData {
                activeAccount = NSKeyedUnarchiver.unarchiveObject(with: aData) as? Account
            }
        }

        guard ((NSKeyedUnarchiver.unarchiveObject(withFile: accountFilename()!) as? [AnyHashable : Any]) != nil) else {
            savedAccounts = [AnyHashable: Any]()
            return
        }

        savedAccounts = NSKeyedUnarchiver.unarchiveObject(withFile: accountFilename()!) as! [AnyHashable : Any]
    }

    func saveAccounts() {
        NSKeyedArchiver.archiveRootObject(savedAccounts, toFile: accountFilename()!)
    }

    func saveAccount() {
        var data: Data? = nil
        if (activeAccount != nil) {
            data = NSKeyedArchiver.archivedData(withRootObject: activeAccount!)
        }
        if data != nil {
            UserDefaults.standard.set(data, forKey: kActiveUserKey)
        } else {
            UserDefaults.standard.removeObject(forKey: kActiveUserKey)
        }
        if (activeAccount != nil) {
            saveAccounts()
        }
        UserDefaults.standard.synchronize()
    }
}


