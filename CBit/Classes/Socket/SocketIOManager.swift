import UIKit
import SocketIO
import UserNotifications


class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var lastViewController: UIViewController?
  
    let manager = SocketManager(socketURL: URL(string: Define.SOCKET_URL)!,
                                config:[.log(true),
                                        .reconnectWait(1),
                                        .compress,
                                        .forceWebsockets(true),
                                        .path("/socket.io"),
                                        .reconnects(true)])
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { (data, ack) in
            Define.APPDELEGATE.hideLoading()
            print("➤ Socket Connected")
            if MyModel().isLogedIn() {
               
                let dictData = ["user_id": Define.USERDEFAULT.value(forKey: "UserID")!]
                
                let jsonString = MyModel().getJSONString(object: dictData)
                let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
                let strBase64 = encriptString.toBase64()
                
                SocketIOManager.sharedInstance.socket.emitWithAck("login",
                                                            strBase64!).timingOut(after: 0, callback:
                { (data) in
                    print("---->: ",data)
           
                    let strValue = data[0] as! String
                    
                    let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
                    let dictData = MyModel().convertToDictionary(text: strJSON)
                    print("---> LogIn Data: ", dictData!)
                    
                    let status = dictData!["statusCode"] as? Int ?? 0
                    if status == 200 {
                        
                        let dictWallet = dictData!["content"] as! [String: Any]
                        Define.USERDEFAULT.set(dictWallet["pbAmount"] as? Double ?? 0.0, forKey: "PBAmount")
                        Define.USERDEFAULT.set(dictWallet["sbAmount"] as? Double ?? 0.0, forKey: "SBAmount")
                        Define.USERDEFAULT.set(dictWallet["tbAmount"] as? Double ?? 0.0, forKey: "TBAmount")
                        Define.USERDEFAULT.set(dictWallet["ccAmount"] as? Double ?? 0.0, forKey: "ccAmount")
                        NotificationCenter.default.post(name: .paymentUpdated, object: nil)
                        
                    }
                })
                if self.lastViewController != nil && self.lastViewController is GamePlayVC {
                    print("Game Play Screen.")
                    NotificationCenter.default.post(name: .startGame, object: nil)
                }
                //UpComingContest
                NotificationCenter.default.post(name: .upComingContest, object: nil)
                //MyContest
                NotificationCenter.default.post(name: .myContest, object: nil)
                NotificationCenter.default.post(name: .getAllspecialContest, object: nil)
            }
            
            self.setEvents()
        }
        socket.on(clientEvent: .error) { (data, ack) in
            if MyModel().isLogedIn() {
                Define.APPDELEGATE.showLoading()
            }
            print("➤ Error To Connect Socket.")
            //NotificationCenter.default.post(name: .errorConnectSocket, object: nil)
        }
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print("➤ Socket Desconnected.")
            
        }
    }
    
    func setEvents() {
        //TODO: UnAuthorized
        socket.on(Define.EVENT_UNAUTHORIZED) { (data, ack) in
            print("➤ Un Authorized")
            Define.APPDELEGATE.handleLogout()
        }
        
        //TODO: VersionUpdate
        socket.on(Define.VERSION_UPDATE) { (data, ack) in
                   print("➤ VersionUpdate",data)
                //   Define.APPDELEGATE.handleversionupdate()
            print("Data: \(data)")
            let strValue = data[0] as! String
            
            let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
            let dictData = MyModel().convertToDictionary(text: strJSON)
            
            //let strContestId = "\(dictData!["contestId"]!)"
            //self.createNotification(strContestID: strContestId, strMessage: "Contest Start")
            
           // NotificationCenter.default.post(name: .startGame, object: nil, userInfo: dictData)
            
         //   let appVersion =
            let current = Define.APP_VERSION
           // let current = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
            let appStore = dictData!["Version"] as! String
            let versionCompare = current.compare(appStore, options: .numeric)
            if versionCompare == .orderedSame {
                print("same version")
            } else if versionCompare == .orderedAscending {
                // will execute the code here
                print("ask user to update")
                 Define.APPDELEGATE.handleLogout()
            } else if versionCompare == .orderedDescending {
                // execute if current > appStore
                print("don't expect happen...")
            }
        }
        //TODO: Game Start
        socket.on(Define.EVENT_ON_CONTEST_START) { (data, ack) in
            print("➤ On Contest Start")
            print("Data: \(data)")
            let strValue = data[0] as! String
            
            let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
            let dictData = MyModel().convertToDictionary(text: strJSON)
            
            //let strContestId = "\(dictData!["contestId"]!)"
            //self.createNotification(strContestID: strContestId, strMessage: "Contest Start")
            
            NotificationCenter.default.post(name: .startGame, object: nil, userInfo: dictData)
        }
        
        //TODO: Game End
        socket.on(Define.EVENT_ON_CONTEST_END) { (data, ack) in
            print("➤ On Contest End")
            print("Data: \(data)")
            
            let strValue = data[0] as! String
            
            let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
            let dictData = MyModel().convertToDictionary(text: strJSON)
            
            NotificationCenter.default.post(name: .endGame, object: nil, userInfo: dictData)
            
        }
        
        //TODO: Start game time
            socket.on("onContestLive") { (data, ack) in
                print("➤ On Contest End")
                print("Data: \(data)")
                
                let strValue = data[0] as! String
                
                let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
                let dictData = MyModel().convertToDictionary(text: strJSON)
                
                NotificationCenter.default.post(name: .EnterGamePage, object: nil, userInfo: dictData)
                
            }    //TODO: Game End
                socket.on(Define.EVENT_ON_CONTEST_END) { (data, ack) in
                    print("➤ On Contest End")
                    print("Data: \(data)")
                    
                    let strValue = data[0] as! String
                    
                    let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
                    let dictData = MyModel().convertToDictionary(text: strJSON)
                    
                    NotificationCenter.default.post(name: .endGame, object: nil, userInfo: dictData)
                    
                }
        
        //TODO: Contest Alert
        socket.on(Define.EVENT_ON_CONTEST_ALERT) { (data, ack) in
            
            print("➤ On Contest Start Alert")
            print("Data: \(data)")
            let strValue = data[0] as! String
            
            let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
            let dictData = MyModel().convertToDictionary(text: strJSON)
            
            if dictData != nil {
              
                let strContestId = "\(dictData!["contestId"]!)"
                
                self.createNotification(strContestID: strContestId, strMessage:"Hurry! Your Game starts in a min. All the best.")
                
                
            } else {
                
                print("--->> Something is missing in alert notification")
                
            }
            
        }
        
        //TODO: Contest Update
        socket.on(Define.EVENT_ON_CONTEST_UPDATE) { (data, ack) in
            print("➤ Contest Updated")
            //UpComingContest
            NotificationCenter.default.post(name: .upComingContest, object: nil)
            
            //MyContest
            NotificationCenter.default.post(name: .myContest, object: nil)
            
            NotificationCenter.default.post(name: .updatePrivateContest, object: nil)
            NotificationCenter.default.post(name: .getAllspecialContest, object: nil)
        }
        
        //TODO: Paymet Update
        socket.on(Define.EVENT_ON_PAYMENT_UPDATE) { (data, ack) in
            print("➤ Payment Update")
            print(data)
            
            let strValue = data[0] as! String
            
            let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
            let dictData = MyModel().convertToDictionary(text: strJSON)
            
            Define.USERDEFAULT.set(dictData!["pbAmount"] as? Double ?? 0.0, forKey: "PBAmount")
            Define.USERDEFAULT.set(dictData!["sbAmount"] as? Double ?? 0.0, forKey: "SBAmount")
            Define.USERDEFAULT.set(dictData!["tbAmount"] as? Double ?? 0.0, forKey: "TBAmount")
            Define.USERDEFAULT.set(dictData!["ccAmount"] as? Double ?? 0.0, forKey: "ccAmount")
            Define.USERDEFAULT.set(dictData!["WalletAuth"] as? Double ?? 0.0, forKey: "WalletAuth")
                  
                
            
          
            NotificationCenter.default.post(name: .paymentUpdated, object: nil)
        }
        
        //TODO: Host Notify
        socket.on(Define.EVENT_HOST_NOTIFY) { (data, ack) in
            print("➤ Host Notify")
            print("Data: \(data)")
            let strValue = data[0] as! String
            
            let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
            let dictData = MyModel().convertToDictionary(text: strJSON)
            
            print("Notify Data: \(dictData!)")
            
            let strContestName = dictData!["contestName"] as? String ?? "No Name"
            let strContestID = "\(dictData!["contestId"] as? Int ?? 0)"
            let strMessage = dictData!["msg"] as? String ?? "No Message Available"
            
            self.createIsNotifyNotification(strContestID: strContestID,
                                            strContestName: strContestName,
                                            strMessage: strMessage)
        }
        
        //TODO: Contest Detail Live Update
        socket.on(Define.EVENT_ON_CONTEST_LIVE_UPDATE) { (data, ack) in
            print("➤Live Updata")
            print("Data: \(data)")
            
            let strValue = data[0] as! String
            
            let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
            let arrData = MyModel().convertToArrayOfDictionary(text: strJSON)
            
            let dictData:[String: Any] = ["contest": arrData!]
            NotificationCenter.default.post(name: .onContestLiveUpdate,
                                            object: nil,
                                            userInfo: dictData)
        }
    }
    
    func createNotification(strContestID: String, strMessage: String) {
        if Define.USERDEFAULT.bool(forKey: "SetNotification") {
            if lastViewController != nil && lastViewController is GamePlayVC {
                print("Notification Not Register")
            } else {
                let content = UNMutableNotificationContent()
                content.title = "CBIT Original"
                content.body = strMessage
                 content.sound = UNNotificationSound.default
                content.categoryIdentifier = Define.ACTION_IDENTIFIRE
                content.userInfo = ["id": strContestID] as [String: Any]
                 content.sound = UNNotificationSound.default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: Define.NOTIFICATION_IDENTIFIRE,content: content,trigger: trigger)
                let curret = UNUserNotificationCenter.current()
                curret.add(request) { (error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("Notification Registered.")
                    }
                }
            }
        }
    }
    
    func createIsNotifyNotification(strContestID: String, strContestName: String, strMessage: String) {
        if Define.USERDEFAULT.bool(forKey: "SetNotification") {
           
            let content = UNMutableNotificationContent()
            content.title = "CBit"
            content.subtitle = strContestName
            content.body = strMessage
            content.categoryIdentifier = Define.NOTIFY_ACTION_ID
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: Define.NOTIFY_NOTIFICATION_ID,content: content,trigger: trigger)
            let curret = UNUserNotificationCenter.current()
            curret.add(request) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Notification Registered.")
                }
            }
        }
    }
    
    func establisConnection() {
        socket.connect()
       
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
