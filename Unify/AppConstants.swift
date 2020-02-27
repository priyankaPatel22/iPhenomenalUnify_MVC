//
//  AppConstants.swift
//  SideMenuDemo
//
//  Created by Priyanka Patel on 23/05/18.
//  Copyright © 2018 Priyanka Patel. All rights reserved.
//

import Foundation

//******** Application Name ************//
let kAppName = "Unify"

//******** Font applyed in Application ************//
let kFontAvenirBook = "Avenir-Book"
let kFontAvenirHeavy = "Avenir-Heavy"
let kFontAvenirBlack = "Avenir-Black"
let kFontAvenirMedium = "Avenir-Medium"

//******** General Keys ************//
let USER_LOGIN = "firstAppLaunched"

let kDeviceType = 1
let kSAMPLE_DEVICE_TOKEN = "740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad"


//******** General Message ************//

//Alert Message
let kALERT_OK = "OK"
let kALERT_CANCEL = "CANCEL"
let kALERT_CONTINUE = "CONTINUE"
let kALERT_RESEND = "RESEND"
let kALERT_SETTING = "SETTING"
let kALERT_LOGOUT = "LOGOUT"

let kALERT_NO = "NO"
let kALERT_YES = "YES"

let kLOGOUT_PERMITION = "Are you sure you want to logout?"
let kNO_CONNECTION_MESSAGE = "Please check your internet connection & try again"

let kCHECKBOX_UNSELECTED = "Please accept the terms and conditions to register your account."

let kPROFILE_PLACEHOLDER = "placeholder_profile_pic"

/********* Login Screen ******************/
let kEMPTY_LOGIN_EMAIL = "Please enter email address"
let kEMPTY_LOGIN_PASSWORD = "Please enter password"

/********* Registartion Screen ******************/
let kEMPTY_REGISTRATION_FULLNAME = "Please enter full name"
let kEMPTY_REGISTRATION_EMAIL = "Please enter email address"
let kEMPTY_REGISTRATION_UNIVERSITY = "Please select university"
let kEMPTY_REGISTRATION_PASSWORD = "Please enter password"

/********* Forgot Password ******************/
let kEMPTY_FORGOT_PASSWORD_EMAIL = "Please enter email address"

/********* Change Password ******************/
let kEMPTY_OLD_PASSWORD = "Please enter old password"
let kEMPTY_NEW_PASSWORD = "Please enter new password"
let kEMPTY_CONFIRM_NEW_PASSWORD = "Please enter confirm new password"
let kEMPTY_CONFIRM_NEW_PASSWORD_NOT_MATCH = "New password and confirm new password not match"

/********* Questions ******************/
let kEMPTY_ADD_QUESTION_TITLE = "Please enter question"

//***************************************************//
/////////////////////-SIDEMENU CONTENTS-///////////////////////////
let kTITLE_BADGE = "Questions"
let kTITLE_GROUPS = "Groups"
let kTITLE_MESSAGE = "Message"
let kTITLE_NOTIFICATIONS = "Notifications"
let kTITLE_INTERESTS = "Interests"
let kTITLE_DISCOUNTS = "Discounts"
let kTITLE_HELP = "Help"
let kTITLE_SHARE_APP = "Share This App"
let kTITLE_CHANGE_PASSWORD = "Change Password"
let kTITLE_LOGOUT = "Logout"


///////////////////////////////////////////////////////////////////////////
//////////////////////////////-API BLOCK DECLARATION-/////////////////////////////////////
typealias DataAddedBlock = (Any?, Error?) -> Void
typealias ItemLoadedBlock = (Any?, Error?) -> Void
typealias DataLoadedBlock = (Any?, Error?) -> Void

