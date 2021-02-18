import Foundation
import UIKit
class Define {
    //MARK: - Object.
    static let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
    static let USERDEFAULT = UserDefaults.standard
    
    static var Globalimagearr = [[String:Any]]()
    //MARK: - Color.
    //3B7188
    static let APPCOLOR = UIColor(red: 59/255.0,
                                  green: 113/255.0,
                                  blue: 136/255.0,
                                  alpha: 1)
    //006692
    static let MAINVIEWCOLOR = UIColor(red: 0/255.0,
                                       green: 102/255.0,
                                       blue: 146/255.0,
                                       alpha: 1)
    //00202F
    static let MAINVIEWCOLOR2 = UIColor(red: 0/255.0,
                                       green: 32/255.0,
                                       blue: 47/255.0,
                                       alpha: 1)
    //F4B33D
    static let BUTTONCOLOR = UIColor(red: 244/255.0,
                                     green: 179/255.0,
                                     blue: 61/255.0,
                                     alpha: 1)
    //MARK: - Alert Message
    static let ERROR_SERVER = "We’ve run into a problem. Please try again later."
    static let ERROR_INTERNET = "No Internet"
    static let ERROR_TITLE = "CBit"
    
    //MARK: - URL
    
//    //Live
    
//   static let APP_URL = "http://207.154.223.43:3500/api/"
//   static let SOCKET_URL = "http://207.154.223.43:3500"
    
    //  Test
    
    static let APP_URL = "http://207.154.223.43:3600/api/"
    static let SOCKET_URL = "http://207.154.223.43:3600"
    
   static let SHARE_URL = "https://admin.cbitoriginal.com/deeplink?url=ashvh.com&code="
    
//    static let APP_URL = "https://admin.cbitoriginal.com/api/"
//    static let SOCKET_URL = "https://admin.cbitoriginal.com" 
//    static let SHARE_URL = "https://admin.cbitoriginal.com/deeplink?url=ashvh.com&code="
    
    //static let PRIVACYPOLICY_URL = "https://admin.cbitoriginal.com/page/privacy"
    static let APP_VERSION = "3.31"
    
    static let PRIVACYPOLICY_URL = "http://cbitoriginal.com/privacy-policy-app.html"
    static let LIGALITY_URL = "https://admin.cbitoriginal.com/page/legality"
    static let AAPINFO_URL = "https://admin.cbitoriginal.com/page/termsofuse_mobileapp"
    static let JticketInfo_URl = "https://cbitoriginal.com/j_tickit.html"
    static let FAQsURL = "https://cbitoriginal.com/faq.html"
    
    
    //MARK: - PayKun
   // static let PAYMENT_ACCESS_TOKEN = "65063B484A2F0DC8F014B82912DA6289"
     static let PAYMENT_ACCESS_TOKEN = "A943C3B11109149D5D78BC3770DA49CA"
    static let PAYMENT_MARCHANT_ID = "140686552067082"
    static let ISLIVE = true
    
//    static let PAYMENT_ACCESS_TOKEN = "236D48639BC0FEB1B2F1ECF312ADD15C"
//    static let PAYMENT_MARCHANT_ID = "097003172226272"
//    static let ISLIVE = false
    
    //MARK: - KEY
    static let KEY = "dePQ8#NtBSxUcgHM"
    
    //MARK: - API
    static let API_SIGNUP = "signup_new"
    static let API_SIGNIN = "signIn_new"
    static let API_MOBILESIGNIN = "LoginSendOtp"
    static let API_OTPMOBILEVERIFY = "LoginOtp"
    static let API_FORGOT_PASSWORD = "forgotPassword"
    static let API_CHANGE_PASSWORD = "changePassword"
    static let API_ADD_MONEY = "addMoney"
    static let API_GET_CONTEST = "getAllContest"
    static let API_MY_CONTEST = "getMyContest"
    static let API_CONTEST_DETAIL = "contestDetails"
    static let API_JOIN_CONTEST = "joinContest"
    static let API_PASSBOOK = "getPassbook"
    static let API_WINNER_LIST = "winnerList"
    static let API_CONTEST_HISTORY = "contestHistory"
    static let API_UPLOAD_PROFILE_IMAGE = "uploadProfileImage"
    static let API_ADD_PRIVATE_CONTEST = "addPrivateContest"
    static let API_JOIN_BY_CODE = "getByCode"
    static let API_GET_PRIVATE_CONTEST = "getPrivateContest"
    static let API_GET_PRIVATE_CONTEST_DETAIL = "getPrivateContestDetails"
    static let API_GET_PACKAGE = "getPackages"
    static let API_BUY_PACKAGE = "buyPackage"
    static let API_MY_PACKAGE = "myPackage"
    static let API_LOGOUT = "logout"
    static let API_SEND_OTP = "sendOtp"
    static let API_ADD_WALLET = "addWallate"
    static let API_NOTIFICATION = "getNotification"
    static let API_SETNOTIFICATION = "setNotification"
    static let API_GET_ADS = "getAds"
    static let API_UPDATE_KYC = "updateKYC"
    static let API_GET_OTP = "sendOtpAuth"
    static let API_CHECK_USER_NAME = "checkUserName"
    static let API_PROFILE = "profile"
    static let API_LINK_BANK = "addBank"
    static let API_DELETE_BANK = "deleteBank"
    static let API_GET_ACCOUNTS = "accounts"
    static let API_REDEEM = "redeeem"
    static let API_JOIN_USER_LIST = "joinUserList"
    static let API_getCCPassbook = "getCCPassbook"
    static let API_GETCITYSTATE = "state_city"
    static let API_GETSPECIALCONTEST = "getAllSpecialContest"
    
    static let API_CHECKVERSION = "CheckVersion"
    
     static let API_AUTOPILOTUPDATE = "AutoPilotUpdate"
     static let API_REDEEMDAILYQOUTAUPDATE = "RedeemDailyQoutaUpdate"
    static let API_ALLJTICKETDATAS = "getAllJticketDatas"
    
    static let API_ANYTIMEGAMELIST = "getAnyTimeGameList"
    
    //MARK: - Socket Event
    static let EVENT_LOGINT = "login"
    static let EVENT_CONTEST_DETAIL = "contestDetails"
    static let EVENT_ON_CONTEST_START = "onContestStart"
    static let EVENT_ON_CONTEST_END = "onContestEnd"
    static let EVENT_UPDATE_CONTEST = "updateGame"
    static let EVENT_UNAUTHORIZED = "unauthorized"
    static let EVENT_ON_CONTEST_UPDATE = "onContestUpdate"
    static let EVENT_ON_PAYMENT_UPDATE = "onPaymentUpdate"
    static let EVENT_HOST_NOTIFY = "hostNotify"
    static let EVENT_ON_CONTEST_LIVE_UPDATE = "onContestLiveUpdate"
    static let EVENT_ON_CONTEST_ALERT = "onContestAlert"
    static let VERSION_UPDATE = "VersionUpdate"
    
    //MARK: - Notification Identifire
    static let PLAYGAME = "PlayGame"
    static let NOTIFICATION_IDENTIFIRE = "NofificationContest"
    static let ACTION_IDENTIFIRE = "ContestAction"
    
    static let NOTIFY_NOTIFICATION_ID = "IsNotifyNotification"
    static let NOTIFY_ACTION_ID = "IsNotifyAction"
    static let NOTIFY_ACTION_NAME = "ShowContest"
    
    static let GET_REFERRALDETAILS = "referralDetail"
    static let GET_AllJticket = "getAllJTicket"
    static let ADD_Jticket = "addJTicket"
    static let getUserJTicket = "getUserJTicket"
    static let getWaitingroom = "getWaitingList"
    static let ApplyJtciket = "ApplyJtciket"
    
    static let getUserJTicketDate = "getUserJTicketDate"
    static let getUserJTicketName = "getUserJTicketName"
    
    static let getSpinningMachine = "getSpinningMachine"
    
    static let CONTEST_DAYS = "contestDays"
    static let CONTEST_TIME = "contestTime"
    
    
    static let ADD_PRIVATE_GROUP = "addPrivateGroup"
    static let ALL_REQUEST_PRIVATE_GROUP = "allRequestsPrivateGroup"
    static let REQUEST_JOIN_GROUP = "requestToJoinPrivateGroup"
    static let ALL_PRIVATE_GROUP = "allPrivateGroup"
    static let ALL_USER_PRIVATE_GROUP = "allUsersPrivateGroup"
    
    //MARK: - PlaceHolderImage
    static let PLACEHOLDER_PROFILE_IMAGE = #imageLiteral(resourceName: "sidemenuicon1")
     static let PLACEHOLDER_PROFILE_SIDE_IMAGE = #imageLiteral(resourceName: "sidemenuicon")
    static let PLACEHOLDER_PROFILE_IMAGE1 = #imageLiteral(resourceName: "ic_ractangle")
 }

