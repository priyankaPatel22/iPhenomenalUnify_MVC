//
//  Utils.swift
//  PocketAngelDonor
//
//  Created by Priyanka Patel on 20/07/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import UIKit

class Utils: NSObject {

    //MARK :- Check String for empty or not
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
    
}
