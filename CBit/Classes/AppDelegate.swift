import UIKit
import IQKeyboardManagerSwift
import SideMenuSwift
import UserNotifications
import FBSDKCoreKit
import Firebase
import FirebaseMessaging
import EventKit
import Fabric
import Crashlytics
import OneSignal
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,OSPermissionObserver,OSSubscriptionObserver,UNUserNotificationCenterDelegate {
    
    
    
    var window: UIWindow?
    var eventStore: EKEventStore?
    
    var gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ArgAppUpdater.getSingleton().showUpdateWithForce()
        UserDefaults.standard.register(defaults: ["isaudio" : true])
     //   ArgAppUpdater.getSingleton().showUpdateWithConfirmation()
//        VersionCheck.shared.isUpdateAvailable() { hasUpdates in
//          print("is update available: \(hasUpdates)")
//        }
        //ReachabilityManager.shared.startMonitoring()
        //        SocketIOManager.sharedInstance.socket.off("onContestLive")
        //        SocketIOManager.sharedInstance.socket.off(clientEvent: "onContestLive")
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
                  // This block gets called when the user reacts to a notification received
                  let payload: OSNotificationPayload? = result?.notification.payload
                  
                  print("Message: ", payload!.body!)
                  print("badge number: ", payload?.badge ?? 0)
                  print("notification sound: ", payload?.sound ?? "No sound")
            
            if let additionalData = result!.notification.payload!.additionalData {
                print("additionalData: ", additionalData)
                
                if let actionSelected = payload?.actionButtons {
                    print("actionSelected: ", actionSelected)
                }
              let mainStoryboard: UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
              
              let GamePlayVC = mainStoryboard.instantiateViewController(withIdentifier: "GamePlayVC") as! GamePlayVC
              let SpinningMachinePlayVC = mainStoryboard.instantiateViewController(withIdentifier: "SpinningMachinePlayVC") as! SpinningMachinePlayVC
              self.window = UIWindow(frame: UIScreen.main.bounds)
              // spinning-machine / 0-9 / rdb
//                if additionalData["NotificationType"] as! String == "spinning-machine"
//              {
//                    SpinningMachinePlayVC.isFromNotification = true
//                    SpinningMachinePlayVC.dictContest["id"] = additionalData["contestId"] as! Int
//                    self.NavigateVC(controller: SpinningMachinePlayVC)
//              }
//              else
//                {
//                    GamePlayVC.isFromNotification = true
//                    GamePlayVC.dictContest["id"] = additionalData["contestId"] as! Int
//                    self.NavigateVC(controller: GamePlayVC)
//                }
                 
              
        
    
                 
              
                // DEEP LINK from action buttons
                if let actionID = result?.action.actionID {
                    // For presenting a ViewController from push notification action button
                    print("actionID = \(actionID)")
                }
            }

        }
        

        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
                    
                    print("Received Notification: ", notification!.payload.notificationID!)
                    print("launchURL: ", notification?.payload.launchURL ?? "No Launch Url")
                    print("content_available = \(notification?.payload.contentAvailable ?? false)")
                }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true, ]
            
            OneSignal.initWithLaunchOptions(launchOptions, appId: "2ebce384-8388-4bff-9973-96dfe41069ab", handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        let userId = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId
        
        UserDefaults.standard.set(userId,forKey:"OnesignalID")
        
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            
            
        })
        
        OneSignal.add(self as OSPermissionObserver)
        OneSignal.add(self as OSSubscriptionObserver)
        
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        IQKeyboardManager.shared.enable = true
        setSideMenu()
        setActionForNotification()
        //FCM Push Notification
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        //        Messaging.messaging().delegate = self
        //        Messaging.messaging().isAutoInitEnabled = true
        //
        //        getFCMToken()
        
        //Facebook
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func NavigateVC(controller:UIViewController)  {
        if MyModel().isLogedIn()
        {
            let navController = UINavigationController.init(rootViewController: controller)
            navController.isNavigationBarHidden = true
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()

        }
      
    }

    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        
        print("SubscriptionStateChange: \n\(String(describing: stateChanges))")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            UserDefaults.standard.set(playerId,forKey:"OnesignalID")
            //kUserDefault.synchronize()
        }
    }
    
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(String(describing: stateChanges))")
    }
    
    //
    //    func applicationDidBecomeActive(_ application: UIApplication) {
    //           AppEvents.activateApp()
    //       }
    //
    //       private func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
    //           return ApplicationDelegate.shared.application(application, open: url as URL, sourceApplication: sourceApplication, annotation: annotation)
    //       }
    //
    //
    //       public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //
    //           return ApplicationDelegate.shared.application(
    //         app,
    //         open: (url as URL?)!,
    //         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
    //         annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    //       )
    //       }
    //
    //       public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    //           return ApplicationDelegate.shared.application(
    //         application,
    //         open: (url as URL?)!,
    //         sourceApplication: sourceApplication,
    //         annotation: annotation)
    //       }
    //
    
    //    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //        //let appId: String = FBSDKSettings.appID()
    //
    //        if let scheme = url.scheme, scheme.localizedCaseInsensitiveCompare("www.cbit.com") == .orderedSame {
    //
    //            var parameters: [String: String] = [:]
    //            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
    //                parameters[$0.name] = $0.value
    //            }
    //            print("Value: \(parameters)")
    //            if !MyModel().isLogedIn()  {
    //
    //            } else if !MyModel().isConnectedToInternet() {
    //
    //            } else {
    //                SocketIOManager.sharedInstance.establisConnection()
    //                presentViewController(parameter: parameters)
    //            }
    //
    //            return true
    //        } else {
    //            return FBSDKApplicationDelegate.sharedInstance().application(app,
    //                                                                         open: url ,
    //                                                                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
    //                                                                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    //        }
    //    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //let appId: String = FBSDKSettings.appID()
        
        if let scheme = url.scheme, scheme.localizedCaseInsensitiveCompare("www.cbit.com") == .orderedSame {
            
            var parameters: [String: String] = [:]
            URLComponents(url: url as URL, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }
            print("Value: \(parameters)")
            if !MyModel().isLogedIn()  {
                
            } else if !MyModel().isConnectedToInternet() {
                
            } else {
                SocketIOManager.sharedInstance.establisConnection()
                
                presentViewController(parameter: parameters)
            }
            
            return true
        } else {
            return ApplicationDelegate.shared.application(app, open: url ,
                                                          sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            
            
        }
    }
    
    //    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    //
    //            return SDKApplicationDelegate.shared.application(app, open: url, sourceApplication: (options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String), annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any)
    //    }
    
    
    func presentViewController(parameter: [String: String]) {
        
        let storyBoard = UIStoryboard(name: "Dashboard", bundle: nil)
        guard
            //            let joinCodeVC = storyBoard.instantiateViewController(withIdentifier: "PrivateContestJoinVC") as? PrivateContestJoinVC,
            let navigation = storyBoard.instantiateViewController(withIdentifier: "JoinNC") as? UINavigationController
        
        else {
            return
        }
        Define.USERDEFAULT.set(parameter, forKey: "LinkParameter")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if MyModel().isLogedIn() {
            SocketIOManager.sharedInstance.closeConnection()
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if MyModel().isLogedIn() {
            SocketIOManager.sharedInstance.establisConnection()
            if MyModel().isConnectedToInternet() {
                NotificationCenter.default.post(name: .upComingContest, object: nil)
                NotificationCenter.default.post(name: .myContest, object: nil)
                NotificationCenter.default.post(name:.getAllspecialContest,object: nil)
                
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Set SideMenu
    func setSideMenu() {
        let screenSize = UIScreen.main.bounds
        SideMenuController.preferences.basic.menuWidth = screenSize.width - 40
        SideMenuController.preferences.basic.defaultCacheKey = "0"
    }
    
    func setActionForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        
        { (granted, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if granted {
                    print("Permission Granted")
                } else {
                    print("Permission Not Granted")
                }
            }
            
            
        }
        
        let playGame = UNNotificationAction(identifier: Define.PLAYGAME,
                                            title: "Play Contest",
                                            options: [.foreground, .destructive])
        let category = UNNotificationCategory(identifier: Define.ACTION_IDENTIFIRE,
                                              actions: [playGame],
                                              intentIdentifiers: [],
                                              options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        print("Continue User Activity called: ")
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print(url.absoluteString)
            
            if MyModel().isLogedIn() {
                var parameters: [String: String] = [:]
                URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                    parameters[$0.name] = $0.value
                }
                print("Value: \(parameters)")
                if !MyModel().isLogedIn()  {
                    
                } else if !MyModel().isConnectedToInternet() {
                    
                } else {
                    SocketIOManager.sharedInstance.establisConnection()
                    presentViewController(parameter: parameters)
                }
            }
            
        }
        
        return true
    }
}

//MARK: - Link
extension AppDelegate {
    func queryParameters(from url: URL) -> [String: String] {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryParams = [String: String]()
        for queryItem: URLQueryItem in (urlComponents?.queryItems)! {
            if queryItem.value == nil {
                continue
            }
            queryParams[queryItem.name] = queryItem.value
        }
        return queryParams
    }
}

//@available(iOS 10, *)
//extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
//
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase Registration token: \(fcmToken)")
//
//        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//        // TODO: If necessary send token to application server.
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//        Define.USERDEFAULT.set(fcmToken, forKey: "FCMToken")
//    }
//
//    func application(application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        Messaging.messaging().apnsToken = deviceToken as Data
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//
//    // Receive displayed notifications for iOS 10 devices.
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//        // Change this to your preferred presentation option
//        completionHandler( [.alert, .badge, .sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        completionHandler()
//    }
//
//    func getFCMToken() {
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instance ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                Define.USERDEFAULT.set(result.token, forKey: "FCMToken")
//            }
//        }
//    }
//}

//MARK: - Loading View
extension AppDelegate {
    func showLoading() {
        var isViewAvailable = Bool()
        
        for view in self.window!.subviews {
            if view.tag == 8989 {
                isViewAvailable = true
                break
            } else {
                isViewAvailable = false
            }
        }
        if !isViewAvailable {
            let viewLoading = UIView()
            viewLoading.frame = self.window!.bounds
            viewLoading.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            viewLoading.tag = 8989
            
            let viewActivityIndicator = ViewAcitvityIndicator.instanceFromNib() as! ViewAcitvityIndicator
            viewLoading.addSubview(viewActivityIndicator)
            viewActivityIndicator.center = viewLoading.center
            
            self.window?.addSubview(viewLoading)
        }
    }
    func hideLoading() {
        for view in self.window!.subviews {
            if view.tag == 8989 {
                view.removeFromSuperview()
                break
            }
        }
    }
    
}


//MARK: - Handle Logout
extension AppDelegate {
    func handleLogout() {
        
        print("============ LOGOUT ============")
        SocketIOManager.sharedInstance.closeConnection()
        MyModel().removeUserData()
        let storyBoard = UIStoryboard(name: "Authentication", bundle: nil)
        guard let navigation = storyBoard.instantiateViewController(withIdentifier: "LoginNC") as? UINavigationController
        else { return }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        
    }
}

//MARK: - Handle Logout
extension AppDelegate {
    func handleversionupdate() {
        
        print("============ VERSIONUPDATE ============")
        SocketIOManager.sharedInstance.closeConnection()
        MyModel().removeUserData()
        let storyBoard = UIStoryboard(name: "Authentication", bundle: nil)
        guard let navigation = storyBoard.instantiateViewController(withIdentifier: "LoginNC") as? UINavigationController
        else { return }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        
    }
}
