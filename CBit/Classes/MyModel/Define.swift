import Foundation
import UIKit
import Alamofire

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
    static let ERROR_TITLE = "CBit Original"
    
    //MARK: - URL
    
//    //Live
    
   static let APP_URL = "http://207.154.223.43:3500/api/"
   static let SOCKET_URL = "http://207.154.223.43:3500"
    
    //  Test
    
//    static let APP_URL = "http://207.154.223.43:3600/api/"
//    static let SOCKET_URL = "http://207.154.223.43:3600"
    
   static let SHARE_URL = "https://admin.cbitoriginal.com/deeplink?url=ashvh.com&code="
    
//    static let APP_URL = "https://admin.cbitoriginal.com/api/"
//    static let SOCKET_URL = "https://admin.cbitoriginal.com" 
//    static let SHARE_URL = "https://admin.cbitoriginal.com/deeplink?url=ashvh.com&code="
    
    //static let PRIVACYPOLICY_URL = "https://admin.cbitoriginal.com/page/privacy"
    static let APP_VERSION = "3.34"
    
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
    static let API_ANYTIMEGAMECONTESTLIST = "getAnyTimeGameContestList"
    static let contestDetailsAnyTimeGame = "contestDetailsAnyTimeGame"
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
    static let getUserWaitingList = "getUserWaitingList"
    static let ApplyJtciket = "ApplyJtciket"
    static let ApplyJtciketApproach = "ApplyJtciketApproach"
    static let ApplyApproachNegotiate = "ApproachNegotiate"
    static let ApplyUserApproachNegotiate = "UserApproachNegotiate"
    static let ApplyApproachComfirm = "ApproachComfirm"
    
    
    
    static let getUserJTicketDate = "getUserJTicketDate"
    static let getUserJTicketName = "getUserJTicketName"
    
    static let getJAssets = "getJAssets"
    
    static let getSpinningMachine = "getSpinningMachine"
    
    static let CONTEST_DAYS = "contestDays"
    static let CONTEST_TIME = "contestTime"
    
    static let referal_criteria_chart = "referal_criteria_chart"
    static let referal_criteria = "referal_criteria"
    static let getReferralPopup = "getReferralPopup"
    
    
    static let ADD_PRIVATE_GROUP = "addPrivateGroup"
    static let ALL_REQUEST_PRIVATE_GROUP = "allRequestsPrivateGroup"
    static let REQUEST_JOIN_GROUP = "requestToJoinPrivateGroup"
    static let ALL_PRIVATE_GROUP = "allPrivateGroup"
    static let ALL_USER_PRIVATE_GROUP = "allUsersPrivateGroup"
    static let ALL_Contest_Request = "allContestRequests"
    static let ALL_Private_Group_User_List = "PrivateGroupUserList"
    
    static let PrivateGroup_EditPrivateGroup = "privateGroupjoinContest"
    
    static let ALL_PRIVATE_GROUP_REQUEST_JOIN = "requestToJoinPrivateGroup"
    static let ALL_PRIVATE_GROUP_REQUEST_ACCEPT_DECLINE = "acceptDeclineRequest"
    
    static let ALL_Category_list = "selectCategoryImages"
    
    //MARK: - PlaceHolderImage
    static let PLACEHOLDER_PROFILE_IMAGE = #imageLiteral(resourceName: "sidemenuicon1")
     static let PLACEHOLDER_PROFILE_SIDE_IMAGE = #imageLiteral(resourceName: "sidemenuicon")
    static let PLACEHOLDER_PROFILE_IMAGE1 = #imageLiteral(resourceName: "ic_ractangle")
 }

class VersionCheck {

  public static let shared = VersionCheck()

  func isUpdateAvailable(callback: @escaping (Bool)->Void) {
    let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    Alamofire.request("https://itunes.apple.com/lookup?bundleId=\(bundleId)").responseJSON { response in
      if let json = response.result.value as? NSDictionary, let results = json["results"] as? NSArray, let entry = results.firstObject as? NSDictionary, let versionStore = entry["version"] as? String, let versionLocal = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        let arrayStore = versionStore.split(separator: ".")
        let arrayLocal = versionLocal.split(separator: ".")

        if arrayLocal.count != arrayStore.count {
          callback(true) // different versioning system
        }

        // check each segment of the version
        for (key, value) in arrayLocal.enumerated() {
          if Int(value)! < Int(arrayStore[key])! {
            callback(true)
          }
        }
      }
      callback(false) // no new version or failed to fetch app store version
    }
  }

}


// ---------- START VERSION CHECK CODE ---------------------

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
    //let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
    // You can add many thing based on "http://itunes.apple.com/lookup?bundleId=\(identifier)"  response
    // here version and trackViewUrl are key of URL response
    // so you can add all key beased on your requirement.

}

enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class ArgAppUpdater: NSObject {
    private static var _instance: ArgAppUpdater?;

    private override init() {

    }

    public static func getSingleton() -> ArgAppUpdater {
        if (ArgAppUpdater._instance == nil) {
            ArgAppUpdater._instance = ArgAppUpdater.init();
        }
        return ArgAppUpdater._instance!;
    }

    private func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }

                print("Data:::",data)
                print("response###",response!)

                let result = try JSONDecoder().decode(LookupResult.self, from: data)

                let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

                print("dictionary",dictionary!)


                guard let info = result.results.first else { throw VersionError.invalidResponse }
                print("result:::",result)
                completion(info, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()

        print("task ******", task)
        return task
    }
    private  func checkVersion(force: Bool) {
        let info = Bundle.main.infoDictionary
        let currentVersion = info?["CFBundleShortVersionString"] as? String
        _ = getAppInfo { (info, error) in

            let appStoreAppVersion = info?.version

            if let error = error {
                print(error)



            }else if appStoreAppVersion!.compare(currentVersion!, options: .numeric) == .orderedDescending {
                //                print("needs update")
               // print("hiiii")
                DispatchQueue.main.async {
                    let topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!

                    topController.showAppUpdateAlert(Version: (info?.version)!, Force: force, AppURL: (info?.trackViewUrl)!)
            }

            }
        }


    }
    
    

    func showUpdateWithConfirmation() {
        checkVersion(force : false)


    }

    func showUpdateWithForce() {
        checkVersion(force : true)
    }



}

extension UIViewController {


    fileprivate func showAppUpdateAlert( Version : String, Force: Bool, AppURL: String) {
        print("AppURL:::::",AppURL)

        let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as! String;
        let alertMessage = "\(bundleName) Version \(Version) is available on AppStore."
        let alertTitle = "New Version"


        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)


        if !Force {
            let notNowButton = UIAlertAction(title: "Not Now", style: .default) { (action:UIAlertAction) in
                print("Don't Call API");


            }
            alertController.addAction(notNowButton)
        }

        let updateButton = UIAlertAction(title: "Update", style: .default) { (action:UIAlertAction) in
            print("Call API");
            print("No update")
            guard let url = URL(string: AppURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }

        }

        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}

// ---------- END VERSION CHECK CODE ---------------------
