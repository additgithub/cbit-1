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
    static let ERROR_TITLE = "Cbit Original"
    
    //MARK: - URL
    
    // AWS Server
    
    
//    static let APP_URL = "http://13.127.63.200:3500/api/"
//    static let SOCKET_URL = "http://13.127.63.200:3500"
    
//    //Live
    
//   static let APP_URL = "http://207.154.223.43:3500/api/"
//   static let SOCKET_URL = "http://207.154.223.43:3500"
    
    //--------------TESTING SERVER-------------------//

//    static let APP_URL = "http://103.35.165.112:3500/api/"
//    static let SOCKET_URL = "http://103.35.165.112:3500"
    
//    URL: http://103.35.165.112:3500/login
//
//    USERNAME: cbit@cbit.com
//
//    PASSWORD: Magic_0074
   
    //  Test
    
    static let APP_URL = "http://207.154.223.43:3600/api/"
    static let SOCKET_URL = "http://207.154.223.43:3600"
    
   static let SHARE_URL = "https://admin.cbitoriginal.com/deeplink?url=ashvh.com&code="
    
//    static let APP_URL = "https://admin.cbitoriginal.com/api/"
//    static let SOCKET_URL = "https://admin.cbitoriginal.com" 
//    static let SHARE_URL = "https://admin.cbitoriginal.com/deeplink?url=ashvh.com&code="
    
    //static let PRIVACYPOLICY_URL = "https://admin.cbitoriginal.com/page/privacy"
    static let APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String 
    
    static let PRIVACYPOLICY_URL = "http://cbitoriginal.com/privacy-policy-app.html"
 //   static let LIGALITY_URL = "https://admin.cbitoriginal.com/page/legality"
    static let LIGALITY_URL = "https://www.cbitoriginal.com/legality.html"
 //   static let AAPINFO_URL = "https://admin.cbitoriginal.com/page/termsofuse_mobileapp"
    static let AAPINFO_URL = "https://www.cbitoriginal.com/terms_conditions.html"
    static let JticketInfo_URl = "https://cbitoriginal.com/j_tickit.html"
    static let FAQsURL = "https://cbitoriginal.com/faq.html"
    
    
    //MARK: - PayKun
   // static let PAYMENT_ACCESS_TOKEN = "65063B484A2F0DC8F014B82912DA6289"
     static let PAYMENT_ACCESS_TOKEN = "2A067CCCE0D692371CB780A95C61C424"
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
    static let API_CONTEST_DETAILANYTIME = "contestDetailsAnyTimeGame"
    static let API_ANYTIMEJOIN_CONTEST = "AnyTimejoinContest"
    static let API_JOIN_CONTEST = "joinContest"
    static let API_PASSBOOK = "getPassbook"
    static let API_WINNER_LIST = "winnerList"
    static let API_ANYTIMEWINNER_LIST = "anytimeWinnerList"
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
    
    static let API_SPINNINGITEMCATEGORY = "spinningItemCategory"
    static let API_GETANYTIMEGAMELIST = "getAnyTimeGameList"
   // static let contestDetailsAnyTimeGame = "contestDetailsAnyTimeGame"
    
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
    
    static let getaddmoneystatus = "getaddmoneystatus"
    static let getautopilotcontent = "getautopilotcontent"
    static let getDemoScreen = "getDemoScreen"
    static let getUserInfo = "getUserInfo"
    static let getUserData = "getUserData"
    
    static let getJhitsTotalAmount = "getJhitsTotalAmount"
    static let getReferralCommitionTotalAmount = "getReferralCommitionTotalAmount"
    
    static let setUserDefaultTicketPrice = "setUserDefaultTicketPrice"
    static let getdefaultJoinTicket = "getdefaultJoinTicket"
    
    static let easyJoinContest = "easyJoinContest"
    static let easyjoinContestPrice = "easyjoinContestPrice"
    static let getUserJoinDateTime = "getUserJoinDateTime"
    
    static let setAutoRenewEasyJoin = "setAutoRenewEasyJoin"
    static let setAutoRenewEasyJoinStatus = "setAutoRenewEasyJoinStatus"
    static let getAutoRenewEasyJoin = "getAutoRenewEasyJoin"
    
    static let reportslisting = "reportslisting"
    static let setUserIssues = "setUserIssues"
    
    static let getUserQrCode = "getUserQrCode"
    
    static let jtradingInfo = "jtradingInfo"
    static let storeTradingData = "storeTradingData"
    static let jtradingChart = "jtradingChart"
    
    static let AnytimeGameNotificationCount = "AnytimeGameNotificationCount"
    static let checkForReferral = "checkForReferral"
    static let updateIsWatch = "updateIsWatch"
    static let checkLiveContest = "checkLiveContest"

    
    
    
    
    static let whatsappapi = "https://api.whatsapp.com/send/?phone=918591497179&text=hi"
    
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
// https://itunes.apple.com/lookup?id=1565769563
    // https://itunes.apple.com/lookup?bundleId=\(identifier)
    // "https://itunes.apple.com/lookup?bundleId=\(identifier)&country=IN"
    private func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?id=1565769563") else {
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
    func clearTempFolder() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                if fileURL.pathExtension == "png" {
                    try FileManager.default.removeItem(at: fileURL)
                    print("DELETED:",fileURL)
                }
            }
        } catch  { print(error) }
    }

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
          //  self.clearTempFolder()
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



public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "AudioAccessory5,1":                       return "HomePod mini"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
