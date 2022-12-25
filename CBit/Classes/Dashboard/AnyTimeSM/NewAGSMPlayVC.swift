//
//  NewAGSMPlayVC.swift
//  CBit
//
//  Created by Mobcast on 22/06/22.
//  Copyright © 2022 Bhavik Kothari. All rights reserved.
//

import UIKit
import AVFoundation
import SocketIO

class NewAGSMPlayVC: UIViewController,URLSessionDelegate, URLSessionDataDelegate {
    
    //    @IBOutlet weak var imgminus: UIImageView!
    //    @IBOutlet weak var imgzero: UIImageView!
    //    @IBOutlet weak var imgplus: UIImageView!
        
        @IBOutlet weak var collection_lockall: UICollectionView!
        @IBOutlet var collection_slot: UICollectionView!
        @IBOutlet weak var collection_original: UICollectionView!
        @IBOutlet weak var fadevw: UIView!
        
        var timerautoscroll:Timer?
        var timerfade:Timer?
        var w:CGFloat=0.0
        var slotarr  = [UIImage]()
        var randomarr  = [UIImage]()
        var itemarr  = [UIImage]()
        var originalarr  = [UIImage]()
       // var timecount = 0
        var speed:Double = 50
        var LoadSpeed:Double = 0.0001
      //  var startTimer: Timer?
        var StartSecond = 15
        var storeimage = [[String:Any]]()
    var smitemarr = [[String: Any]]()
    var smitemarrcopy = [[String: Any]]()

        @IBOutlet weak var btnlock: UIImageView!
        

        
      //  @IBOutlet weak var buttonAnsMinus: ButtonWithRadius!
        
        @IBOutlet weak var labelanswerselected: UILabel!
        
      //  @IBOutlet weak var buttonAnsZero: ButtonWithRadius!
        
        
      //  @IBOutlet weak var buttonAnsPlus: ButtonWithRadius!
        
        @IBOutlet weak var viewrdb: UIView!
        
        @IBOutlet weak var btnlockall: ButtonWithRadius!
        
        
        var lockall :String = ""
        var gametype : String = ""
        var strDisplayValuelockall: String?
        
    //    @IBOutlet weak var labelAnsMinus: UILabel!
    //    @IBOutlet weak var labelAnsZero: UILabel!
    //
    //    @IBOutlet weak var labelAnsPlus: UILabel!
        
        //MARK: - Properites
        @IBOutlet weak var viewTimmer: UIView!
        @IBOutlet weak var collectionGame: UICollectionView!
        @IBOutlet weak var tableAnswer: UITableView!
        @IBOutlet weak var labelContestName: UILabel!
        @IBOutlet weak var labelTimer: UILabel!
       
        @IBOutlet var lbllockedat: UILabel!
        
        @IBOutlet weak var constrainCollectionViewHeight: NSLayoutConstraint!
        
        @IBOutlet weak var imgselected: UIImageView!
        
        @IBOutlet weak var imgplaypause: UIImageView!
        @IBOutlet weak var lblplaypause: UILabel!
        @IBOutlet weak var btnplaypause: UIButton!
        
        var dictContest = [String: Any]()
        var isFromNotification = Bool()
        
        var dictGameData = [String: Any]()
        private var arrTickets = [[String: Any]]()
        private var arrSelectedTicket = [[String: Any]]()
        private var arrRandomNumbers = [Int]()
        private var arrBrackets = [[String: Any]]()
        private var currentDate = Date()
        var gamelevel = Int()
        
        private var isGameStart = Bool()
        private var isStartEventCall = Bool()
        
        var timer: Timer?
        var second = 30
        var msecond:Int = 999
        
        var endGameTimer: Timer?
        var endGameSecond = 30
        
        var startTimer: Timer?
       // var startSecond = Int()
       // var miliSecondValue = 0
        var differenceSecond = Int()
        

        var arrBarcketColor = [BracketData]()
        
        private var indexOfElement = Int()
        private var indexOfPath = 2
        var gameMode = String()
        
        var isShowLoading = Bool()
        //Sound
        var setSoundEffect: AVAudioPlayer?
        var soundURL: URL?
        
        var viewAnimation: ViewAnimation?
        var Lockall1: LockAll?
        
        
        // Speed Test
        
          var speedtimer: Timer?
          
        
        typealias speedTestCompletionHandler = (_ megabytesPerSecond: Double? , _ error: Error?) -> Void

        var speedTestCompletionBlock : speedTestCompletionHandler?

        var startTime: CFAbsoluteTime!
        var stopTime: CFAbsoluteTime!
        var bytesReceived: Int!
        
        var arrSelectedTikets = [[String: Any]]()
        var AnyTimedictContest = [[String: Any]]()
        var arrSloat = [[String:Any]]()
        
        @IBOutlet weak var imgTower: UIImageView!
        
        //MARK: - Default Method
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let width = (view.frame.width-20)/5
            
            let coln = [collection_slot,collection_original]
            
            for cln in coln {
                cln?.layer.cornerRadius = 10
                cln?.layer.borderColor = UIColor.black.cgColor
                cln?.layer.borderWidth = 3
                
                let layout = cln?.collectionViewLayout as! UICollectionViewFlowLayout
                layout.itemSize = CGSize(width: width, height: width-10)
              
            }
            
    //     //   collection_lockall.register(lockallcell.self, forCellWithReuseIdentifier: "lockallcell")
    //        let nib = UINib(nibName: "UICollectionElementKindCell", bundle:nil)
    //        self.collection_lockall.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
            let layout = collection_lockall?.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: 50, height: 50)
            
            
            Loading().showLoading(viewController: self)

            
            //collection_slot.semanticContentAttribute = .forceRightToLeft
            storeimage = Define.Globalimagearr
            for _ in 1..<8
            {
                for dict in storeimage {
                    itemarr.append(loadImageFromDocumentDirectory(nameOfImage: dict["name"] as! String))
                }

            }

           slotarr = itemarr
            
            tableAnswer.rowHeight = UITableView.automaticDimension
            tableAnswer.tableFooterView = UIView()
            
            if !isFromNotification {
                
                gamelevel = dictGameData["level"] as? Int ?? 1
            }
            

            
    //        NotificationCenter.default.addObserver(self,
    //                                                      selector: #selector(handleNotificationEnterPage(_:)),
    //                                                      name: .EnterGamePage,
    //                                                      object: nil)
            
//            NotificationCenter.default.addObserver(self,
//                                                   selector: #selector(handleNotification(_:)),
//                                                   name: .startGame,
//                                                   object: nil)
//            NotificationCenter.default.addObserver(self,
//                                                   selector: #selector(handleEndGameNotication(_:)),
//                                                   name: .endGame,
//                                                   object: nil)
//            let path = Bundle.main.path(forResource: "Tick Tock.mp3", ofType: nil)!
//            soundURL = URL(fileURLWithPath: path)
            
            
           // isShowLoading = true
           // arrSelectedTicket = arrSelectedTikets
            fetchdata()
            
        }
    func fetchdata()  {
            for _ in 1..<300
            {
                for dict in self.AnyTimedictContest {
                   if dict["name"] as! String != "Draw"
                    {
                       self.randomarr.append(self.loadImageFromDocumentDirectory(nameOfImage: dict["name"] as! String))
                   }
                }
            }
     
        Loading().hideLoading(viewController: self)
        configStartTimer()
        joinContest()
    }
        
        func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath = paths.first{
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
                let image    = UIImage(contentsOfFile: imageURL.path) ?? UIImage()
                return image
            }
            return UIImage.init(named: "default.png")!
        }
        
        override func viewDidAppear(_ animated: Bool) {
            configAutoscrollTimer()
          //  configFadeTimer()
          //  configStartTimer()
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            deconfigAutoscrollTimer()
            deconfigFadeTimer()
          //  startTimer?.invalidate()
        }
        
        func configAutoscrollTimer()
        {
            
            timerautoscroll=Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(SpinningMachinePlayVC.autoScrollView), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timerautoscroll!, forMode: .common)
        }
        
        func configFadeTimer()
        {
            timerfade=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SpinningMachinePlayVC.FedeinOut), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timerfade!, forMode: .common)
        }
        

        
        
        func deconfigAutoscrollTimer()
        {
            timerautoscroll?.invalidate()
        }
        
        func deconfigFadeTimer()
        {
            timerfade?.invalidate()
        }

        
        @objc func FedeinOut()
        {
          //  timecount+=1
            fadevw.fadeIn()
            fadevw.fadeOut()
            
           

            
            slotarr.shuffle()
          //  collection_slot.scrollToLast()
            collection_slot.reloadData()
        }
        
        @objc func autoScrollView()
        {
            let initailPoint = CGPoint(x: 0,y :w)
            if(LoadSpeed > 0.70 || speed < 10){
                speed = 10
            }else if(LoadSpeed > 0.50){
                LoadSpeed = (LoadSpeed * 1.005)
            }else{
            LoadSpeed = (LoadSpeed * 1.09)
            }
            speed = speed-LoadSpeed
            if(speed <= 0){
                speed = 0
                deconfigAutoscrollTimer()
            }
            var LessSpeed = speed-(speed*2)
            if(speed >= 47){
                LessSpeed = 60
            }
    //        LessSpeed = -5
//            print("LOADSPPED",LoadSpeed)
//            print("LessSpeed",LessSpeed)
//            print("SPPED",speed)
            if __CGPointEqualToPoint(initailPoint, collection_slot.contentOffset)
            {
                if w<collection_slot.contentSize.height
                {
                    w += CGFloat(LessSpeed)
                }
                else
                {
                    w = -self.view.frame.size.height
                }
                
                let offsetPoint = CGPoint(x: 0,y :w)
                collection_slot.contentOffset=offsetPoint
            }
            else
            {
                w=collection_slot.contentOffset.y
            }
        }
        


        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if !isFromNotification {
                labelTimer.text = "Game starts in \(timeString(time: TimeInterval(StartSecond)))"
            }
            SocketIOManager.sharedInstance.lastViewController = self
           // SwiftPingPong.shared.startPingPong()
         //   self.startlistner()
            
        }
    
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            SocketIOManager.sharedInstance.lastViewController = nil
            SwiftPingPong.shared.stopPingPong()
            startTimer?.invalidate()
        }
        
        func configStartTimer()
        {
            startTimer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(NewAGSMPlayVC.HandleGameStartTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(self.startTimer!, forMode: .common)
        }
        
        func deconfigStartTimer()
        {
            startTimer?.invalidate()
        }
        
        @objc func HandleGameStartTimer()
        {
            StartSecond = StartSecond-1

            labelTimer.text = "Game starts in: \(StartSecond)"
                    if StartSecond == 0 {
                        dictGameData["gameStatus"] = "start"
                        self.setData(isfromtime: true)
                       // getContestDetail(isfromtimer: true, isStart: 0)
                        btnplaypause.isHidden = true
                        imgplaypause.isHidden = true
                        lblplaypause.isHidden = true
                    }
            if StartSecond == 0
            {
                deconfigStartTimer()
            }
        }
        
        @IBAction func btn_lockall(_ sender: Any) {
            

            print("selection",strDisplayValuelockall ?? "")
            if strDisplayValuelockall == nil
            {
               
            }
            else{
              //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.locakall()
              //  }
            }
            
        }
        
        func locakall()
        {
            if Lockall1 == nil {
                   Lockall1 = LockAll.instanceFromNib() as? LockAll
                   Lockall1!.frame = view.bounds
                   view.addSubview(Lockall1!)

               }
            
             btnlockall.isHidden = true
               btnlockall.isEnabled = false
               btnlockall.alpha = 0.5
               btnlock.isHidden = false
    //           buttonAnsMinus.isEnabled = false
    //           buttonAnsPlus.isEnabled = false
    //           buttonAnsZero.isEnabled = false
            collection_lockall.isUserInteractionEnabled = false
            
//                   let parameter:[String: Any] = ["userId": Define.USERDEFAULT.value(forKey: "UserID")!,
//                                                  "contestId": dictGameData["id"]!,
//                                                  "DisplayValue":strDisplayValuelockall ?? ""
//
//                   ]
//
//
//                   print("Parameter: \(parameter)")
            
            var arrSelectedcontestid = [String]()
            var arrSelectedticketsIds = [String]()
            var arrallselected = [[String:Any]]()
            var selecteddict = [String:Any]()
           var arrgameno =  [String]()
            
            for item in arrSelectedTikets {
                let isSelected = item["isPurchased"] as! Bool
                if isSelected {
                    let strID = "\(item["contestpriceID"]!)"
                    arrSelectedticketsIds.append(strID)
                    
                    let strcontestId = "\(item["contestId"]!)"
                    arrSelectedcontestid.append(strcontestId)
                    
                    let strgame_played = "\(item["game_played"]!)"
                    arrgameno.append(strgame_played)
                    
                    selecteddict["game_no"] = strgame_played
                    selecteddict["contestPriceId"] = strID
                    arrallselected.append(selecteddict)
                }
            }
            let strSelectedID = arrSelectedcontestid.joined(separator: ",")
            let strSelectedID1 = arrSelectedticketsIds.joined(separator: ",")
            let strSelectedID2 = arrgameno.joined(separator: ",")
            
            var startValue: Int?
            var endValue: Int?
          //  var strDisplayValue: String?
            
            let arrSloatsSelect = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
            
            for item in arrSloatsSelect {
                let displayValue = item["displayValue"] as? String ?? ""
                    if strDisplayValuelockall == displayValue {
                        startValue = item["startValue"] as? Int
                        endValue = item["endValue"] as? Int
                    //    strDisplayValue = item["displayValue"] as? String
                        break
                    }
            }

               
            
                   let parameter:[String: Any] = ["userId": "\(Define.USERDEFAULT.value(forKey: "UserID")!)",
                                                  "contestId": "\(strSelectedID)",
                                                  "contestPriceId":strSelectedID1,
                                                  "gameNo":strSelectedID2,
                                                  "startValue":String(startValue!),
                                                  "endValue":String(endValue!),
                                                  "IsLockAll":"1",
                                                  "DisplayValue":strDisplayValuelockall ?? ""
                                                  
                   ]
            
            
                   print("Parameter: \(parameter)")
                   
                   let jsonString = MyModel().getJSONString(object: parameter)
                   let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
                   let strBase64 = encriptString.toBase64()
                 //  cell.buttonLockNow.isEnabled = false
                   SocketIOManager.sharedInstance.socket.emitWithAck("AnytimeUpdateGameAll", strBase64!).timingOut(after: 0) { (data) in
                       print("Data: \(data)")
                       
                       guard let strValue = data[0] as? String else {
                           Alert().showAlert(title: "Alert",
                                             message: Define.ERROR_SERVER,
                                             viewController: self)
                           return
                       }
                       
                       let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
                       let dictData = MyModel().convertToDictionary(text: strJSON)
                       print("Get Data: \(dictData!)")
                       
                       let status = dictData!["statusCode"] as? Int ?? 0
                       if status == 200 {
                           self.Lockall1?.removeFromSuperview()
                           
                        let dictItemData1 = dictData!["content"] as! [[String: Any]]
                           print(dictItemData1)
                           
                        let i = 0
                           
                           for i in i..<self.arrSelectedTicket.count {
                               
                            let dictItemData = dictItemData1[i]
                           var dictTicket = self.arrSelectedTicket[i]
                           dictTicket["isLock"] = dictItemData["isLockAll"]
                           dictTicket["displayValue"] = dictItemData["DisplayValue"]
                        //   dictTicket["lockTime"] = dictItemData["isLockTime"]
                            dictTicket["lockTime"] = dictItemData["lockTime"]
                           self.arrSelectedTicket[i] = dictTicket
                           
    //                       let indexPath = IndexPath(row:i, section: 0)
    //                       self.tableAnswer.reloadRows(at: [indexPath], with: .none)
                           }
                        self.tableAnswer.reloadData()
                        self.getContestDetail(isfromtimer: true, isStart: 0)
                        self.setlockalldata(dictdata: dictItemData1[0])
                       }
                   }
            
            
        }
        
    //    @IBAction func btnAnsMinus(_ sender: Any) {
    //
    //        buttonAnsMinus.layer.borderColor = UIColor.black.cgColor
    //        buttonAnsMinus.layer.borderWidth = 2
    //
    //        buttonAnsPlus.layer.borderWidth = 0
    //        buttonAnsZero.layer.borderWidth = 0
    //
    //
    //        let arrSloats = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
    //
    //      // labelanswerselected.text! = arrSloats[0]["displayValue"] as? String ?? "-"
    //        //labelanswerselected.text! = labelAnsMinus.text ?? ""
    //
    //
    //        strDisplayValuelockall = arrSloats[0]["displayValue"] as? String ?? ""
    //        if strDisplayValuelockall == "Draw" {
    //            labelanswerselected.isHidden = false
    //            imgselected.isHidden = true
    //            labelanswerselected.text = strDisplayValuelockall
    //        }
    //        else
    //        {
    //            labelanswerselected.isHidden = true
    //            imgselected.isHidden = false
    //            imgselected.image = loadImageFromDocumentDirectory(nameOfImage: strDisplayValuelockall ?? "").imageByMakingWhiteBackgroundTransparent()
    //        }
    //
    //
    //    }
        
        
    //    @IBAction func btnAnsZero(_ sender: Any) {
    //
    //        buttonAnsZero.layer.borderColor = UIColor.black.cgColor
    //        buttonAnsZero.layer.borderWidth = 2
    //
    //        buttonAnsPlus.layer.borderWidth = 0
    //        buttonAnsMinus.layer.borderWidth = 0
    //
    //
    //        let arrSloats = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
    //      //  labelanswerselected.text! = arrSloats[1]["displayValue"] as? String ?? "0"
    //
    //       // labelanswerselected.text! = labelAnsZero.text ?? ""
    //
    //
    //         strDisplayValuelockall = arrSloats[1]["displayValue"] as? String ?? ""
    //        if strDisplayValuelockall == "Draw" {
    //            labelanswerselected.isHidden = false
    //            imgselected.isHidden = true
    //            labelanswerselected.text = strDisplayValuelockall
    //        }
    //        else
    //        {
    //            labelanswerselected.isHidden = true
    //            imgselected.isHidden = false
    //            imgselected.image = loadImageFromDocumentDirectory(nameOfImage: strDisplayValuelockall ?? "").imageByMakingWhiteBackgroundTransparent()
    //        }
    //
    //    }
        
    //    @IBAction func btnAnsPlua(_ sender: Any) {
    //
    //        buttonAnsPlus.layer.borderColor = UIColor.black.cgColor
    //        buttonAnsPlus.layer.borderWidth = 2
    //
    //        buttonAnsZero.layer.borderWidth = 0
    //        buttonAnsMinus.layer.borderWidth = 0
    //
    //          let arrSloats = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
    //        // labelanswerselected.text = arrSloats[2]["displayValue"] as? String ?? "+"
    //        //  labelanswerselected.text! = labelAnsPlus.text ?? ""
    //
    //         strDisplayValuelockall = arrSloats[2]["displayValue"] as? String ?? ""
    //        if strDisplayValuelockall == "Draw" {
    //            labelanswerselected.isHidden = false
    //            imgselected.isHidden = true
    //            labelanswerselected.text = strDisplayValuelockall
    //        }
    //        else
    //        {
    //            labelanswerselected.isHidden = true
    //            imgselected.isHidden = false
    //            imgselected.image = loadImageFromDocumentDirectory(nameOfImage: strDisplayValuelockall ?? "").imageByMakingWhiteBackgroundTransparent()
    //        }
    //
    //    }
        
        override func viewWillLayoutSubviews() {
            
            viewTimmer.layer.cornerRadius = 15
            viewTimmer.layer.masksToBounds = true
            
            labelContestName.text = dictGameData["name"] as? String ?? "No Name"
            
            
        }
        
         var socket: SocketIOClient!
        

        var gamestart = true
        func setnewData()  {
                
          //  arrTickets = dictGameData["tickets"] as? [[String: Any]] ?? []
            arrBrackets = dictGameData["boxJson"] as? [[String: Any]] ?? []
            gameMode = dictGameData["gameMode"] as? String ?? "public"
               
                if isFromNotification {
                    dictContest["id"] = dictGameData["id"]!
                    dictContest["level"] = dictGameData["level"]!
                    dictContest["name"] = dictGameData["name"]!
                    dictContest["rows"] = dictGameData["rows"]!
                    dictContest["startDate"] = dictGameData["startDate"]!
                    dictContest["type"] = dictGameData["type"]!
                    
                    viewWillAppear(true)
                    gamelevel = dictContest["level"] as? Int ?? 1
                    
                }
                
                
                if arrBarcketColor.count <= 0 {
                  //  SetRandomNumber()
                }
                

                
                print("Set Data",dictGameData)
                let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"

                if (gameStatus == "start") {
                    
                    isGameStart = true
                   
                    print("secondss",second)

            
                    if gamestart {
                        
                        collection_original.isHidden = false
                        collection_slot.isHidden = true
                        deconfigAutoscrollTimer()
                        
                        self.arrBrackets = self.dictGameData["boxJson"] as! [[String: Any]]
                        let winning_options = self.dictGameData["winning_options"] as! [[String: Any]]
                        self.originalarr = [UIImage]()
                        for box in self.arrBrackets {
                            for option in winning_options {
                                let number = box["number"]!
                                let objectNo = option["objectNo"]!
                                if number as? NSObject == objectNo as? NSObject{
                                    self.originalarr.append(self.loadImageFromDocumentDirectory(nameOfImage: option["Item"] as! String))
                                }
                            }
                        }

                        self.collection_original.reloadData()
                        
                        
                        
                        tableAnswer.reloadData()
                        gamestart = false

                                            btnlockall.alpha = 1.0
                                               btnlockall.isEnabled = true
                                               btnlockall.isHidden = false
                                               btnlock.isHidden = true
                                               lbllockedat.isHidden = true
    //                                           buttonAnsMinus.isEnabled = true
    //                                           buttonAnsPlus.isEnabled = true
    //                                           buttonAnsZero.isEnabled = true
                        collection_lockall.isUserInteractionEnabled = true
                    }
                    
                
                    
                } else if gameStatus == "gameEnd" {
                    
//                    NotificationCenter.default.removeObserver(self)
//                    SocketIOManager.sharedInstance.lastViewController = nil
//                    let NewAGSMResultVC = self.storyboard?.instantiateViewController(withIdentifier: "NewAGSMResultVC") as! NewAGSMResultVC
//                    NewAGSMResultVC.dictContest = dictGameData
//                    NewAGSMResultVC.arrSelectedTikets = arrSelectedTikets
//                    self.navigationController?.pushViewController(NewAGSMResultVC, animated: true)
                    
                } else {
                    isGameStart = false

                }

            }
        
        private var isGetContest = Bool()
        private var isJoinContest = Bool()
        
    func joinContest() {
        Loading().showLoading(viewController: self)
        var arrSelectedcontestid = [String]()
        var arrSelectedticketsIds = [String]()
        var randomlistarr = [[String:Any]]()
        var listarr = [[String:Any]]()
        for (_,dict) in smitemarr.enumerated() {
            let singledict = ["Image":dict["image"],
                              "Item":dict["name"],
                              "id":dict["id"],
            ]
            listarr.append(singledict as [String : Any])
        }
        
        let singledict = ["Image":smitemarrcopy[smitemarrcopy.count-1]["image"],
                          "Item":smitemarrcopy[smitemarrcopy.count-1]["name"],
                          "id":smitemarrcopy[smitemarrcopy.count-1]["id"],
        ]
        randomlistarr.append(singledict as [String : Any])
        
        for item in arrSelectedTikets {
            let isSelected = item["isPurchased"] as! Bool
            if isSelected {
                let strID = "\(item["contestpriceID"]!)"
                arrSelectedticketsIds.append(strID)
                
                let strcontestId = "\(item["contestId"]!)"
                arrSelectedcontestid.append(strcontestId)
            }
        }
        
        let strSelectedID = arrSelectedcontestid.joined(separator: ",")
        let strSelectedID1 = arrSelectedticketsIds.joined(separator: ",")
        
        let parameter:[String: Any] = ["contest_id":strSelectedID ,
                                       "tickets": strSelectedID1,"list":MyModel().getJSONString(object: listarr)!,"Randomlist":MyModel().getJSONString(object: randomlistarr)!]
        let strURL = Define.APP_URL + Define.API_ANYTIMEJOIN_CONTEST
        
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data":strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        {  (result, error) in
            if error != nil {
                
                Loading().hideLoading(viewController: self)
                print("Error: \(error!.localizedDescription)")
                self.isGetContest = false
                self.isJoinContest = true
                //self.retry()
                self.joinContest()
                
                
            } else {
                Loading().hideLoading(viewController: self)
                print("Result: \(result!)")
                let status = result!["statusCode"] as? Int ?? 0
                if status == 200 {
                    
                    let dictData = result!["content"] as! [String: Any]
                    
                    Define.USERDEFAULT.set(dictData["pbAmount"] as? Double ?? 0.0, forKey: "PBAmount")
                    Define.USERDEFAULT.set(dictData["sbAmount"] as? Double ?? 0.0, forKey: "SBAmount")
                    Define.USERDEFAULT.set(dictData["tbAmount"] as? Double ?? 0.0, forKey: "TBAmount")
                    
                    let GameNumberarr = result!["GameNumber"] as! [[String: Any]]
                    let arrSelectedTiketscopy = self.arrSelectedTikets
                    
                    for (_,dictouter) in GameNumberarr.enumerated() {
                        for (indexinner,dictinner) in arrSelectedTiketscopy.enumerated() {
                            if dictouter["contestPriceId"] as! Int == dictinner["contestpriceID"] as! Int {
                                self.arrSelectedTikets[indexinner]["game_played"] = dictouter["game_no"] as! Int
                            }
                        }
                    }
                    
                    self.getContestDetail(isfromtimer: true, isStart: 0)

                 //   DispatchQueue.main.async { [self] in
                 
                 //   }
                   
                  //  NotificationCenter.default.post(name: .paymentUpdated, object: nil)
                  //  self.getContestDetail(isfromtimer: true, isStart: 0)
                 //   configStartTimer()
//                    self.createReminder(strTitle: self.dictContest["name"] as? String ?? "No Name",strDate: self.dictContest["startDate"] as! String)
//                    let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSummaryVC") as! PaymentSummaryVC
//                    paymentVC.isFromLink = self.isFromLink
//                    self.navigationController?.pushViewController(paymentVC, animated: true)
                    
                    //UpComingContest
//                    NotificationCenter.default.post(name: .upComingContest, object: nil)
//
//                    //MyContest
//                    NotificationCenter.default.post(name: .myContest, object: nil)
//                     NotificationCenter.default.post(name: .getAllspecialContest, object: nil)
                    
                } else if status == 401 {
                    Define.APPDELEGATE.handleLogout()
                } else {
                    Alert().showAlert(title: "Error",
                                      message: result!["message"] as? String ?? "No Message",
                                      viewController: self)
                }
            }
        }
    }
        
        func getContestDetail(isfromtimer:Bool,isStart:Int) {
            
            if isShowLoading {
                Loading().showLoading(viewController: self)
            }
            
            var arrSelectedcontestid = [String]()
            var arrSelectedticketsIds = [String]()
            var arrallselected = [[String:Any]]()
            var selecteddict = [String:Any]()
           var arrgameno =  [String]()
            
            for item in arrSelectedTikets {
                let isSelected = item["isPurchased"] as! Bool
                if isSelected {
                    let strID = "\(item["contestpriceID"]!)"
                    arrSelectedticketsIds.append(strID)
                    
                    let strcontestId = "\(item["contestId"]!)"
                    arrSelectedcontestid.append(strcontestId)
                    
                    let strgame_played = "\(item["game_played"]!)"
                    arrgameno.append(strgame_played)
                    
                    selecteddict["game_no"] = strgame_played
                    selecteddict["contestPriceId"] = strID
    //                let newdict = NSMutableDictionary()
    //                newdict.setObject(strgame_played, forKey: "game_no" as NSCopying)
    //                newdict.setObject(strID, forKey: "contestPriceId" as NSCopying)
                    arrallselected.append(selecteddict)
                }
            }
            
            let strSelectedID = arrSelectedcontestid.joined(separator: ",")
            let strSelectedID1 = arrSelectedticketsIds.joined(separator: ",")
            let strSelectedID2 = arrgameno.joined(separator: ",")
            
            
            let parameter:[String: Any] = [ "contest_id": strSelectedID, "GameNo":strSelectedID2,"contest_price_id":strSelectedID1,"contest_price_game_list":MyModel().getJSONString(object: arrallselected)!]
            
            print("Parameter: \(parameter)")
            
            let jsonString = MyModel().getJSONString(object: parameter)
            let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
            let strBase64 = encriptString.toBase64()
            let sendRequestTime = Date()
            

               
                let strURL = Define.APP_URL + Define.API_CONTEST_DETAILANYTIME

                SwiftAPI().postMethodSecure(stringURL: strURL,
                                            parameters: ["data": strBase64!],
                                            header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                            auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
            { [self] (result, error) in
                    if error != nil {
                        Loading().hideLoading(viewController: self)
                        print("Error: \(error!.localizedDescription)")
                      //  self.retry()
                    } else {
                        Loading().hideLoading(viewController: self)
                        print("ContestResult: \(result!)")
                        let status = result!["statusCode"] as? Int ?? 0
                        if status == 200 {
                            
                            print("Game Data: \(String(describing: result))")

                                       self.dictGameData = result!["content"] as! [String: Any]
                                       print(self.dictGameData)
                            gamelevel = dictGameData["rows"] as? Int ?? 3
                            let width = (view.frame.width-20)/5
                               if gamelevel == 3 {
                                   // constraintCollectionViewHeight.constant = (view.frame.width-20) /* 5*5 */
                                //   constraintCollectionViewHeight.constant = (view.frame.width-20) - width  /* 5*4 */
                                   constrainCollectionViewHeight.constant = (view.frame.width) - (width*2) - 30 /* 5*3 */
                               } else if gamelevel == 4 {
                                   // constraintCollectionViewHeight.constant = (view.frame.width-20) /* 5*5 */
                                   constrainCollectionViewHeight.constant = (view.frame.width) - width - 40  /* 5*4 */
                                  //  constraintCollectionViewHeight.constant = (view.frame.width) - (width*2) /* 5*3 */
                               } else if gamelevel == 5 {
                                   constrainCollectionViewHeight.constant = (view.frame.width) - 50 /* 5*5 */
                                //   constraintCollectionViewHeight.constant = (view.frame.width-20) - width  /* 5*4 */
                                  //  constraintCollectionViewHeight.constant = (view.frame.width) - (width*2) /* 5*3 */
                               }

                          //  self.arrTickets = self.dictGameData["tickets"] as? [[String: Any]] ?? []
                         //   self.tableAnswer.reloadData()
                                       self.gametype  = self.dictGameData["game_type"] as! String
                                       if self.gametype == "spinning-machine" {
                                           self.viewrdb.isHidden = false
                                          // self.buttonAnsMinus.backgroundColor = UIColor.red

                                       }
                                       else
                                       {
                                          // self.view0to9.isHidden = false
                                       }
                                       let serverDate = self.dictGameData["currentTime"] as? String ?? "\(MyModel().convertDateToString(date: Date(), returnFormate: "yyyy-MM-dd HH:mm:ss"))"
                                       self.currentDate = MyModel().converStringToDate(strDate: serverDate, getFormate: "yyyy-MM-dd HH:mm:ss")

                                       print("➤ \(self.dictGameData)")
                            
                            let getResponceTime = Date()

                            let calender = Calendar.current
                            let unitFlags = Set<Calendar.Component>([ .second])
                            let dateComponent = calender.dateComponents(unitFlags, from: sendRequestTime, to: getResponceTime)

                            self.differenceSecond = dateComponent.second!
                            print("=> The Difference Of Second is: ", self.differenceSecond)
                            
                       
                            if isfromtimer {
                            self.setData(isfromtime: isfromtimer)
                            }
                            else
                            {
                                self.btnlock.isHidden = true
                                self.btnlockall.isEnabled = false
                                self.btnlockall.alpha = 0.5
    //                            self.buttonAnsMinus.isEnabled = false
    //                            self.buttonAnsPlus.isEnabled = false
    //                            self.buttonAnsZero.isEnabled = false
                                self.collection_lockall.isUserInteractionEnabled = false
                            }
                            
                            let tickets = self.dictGameData["tickets"] as! [[String: Any]]
                            self.arrSloat = tickets[0]["slotes"] as! [[String: Any]]
                            self.collection_lockall.reloadData()
                           
                            Loading().hideLoading(viewController: self)
                            
                        } else if status == 401 {
                            Define.APPDELEGATE.handleLogout()
                        } else {
                           
                            Alert().showAlert(title: "Alert",
                                              message: result!["message"] as! String,
                                              viewController: self)
                        }
                    }
                }
            

        }
        
        func   setData(isfromtime:Bool) {
            setnewData()
            arrTickets = dictGameData["tickets"] as! [[String: Any]]
            arrBrackets = dictGameData["boxJson"] as! [[String: Any]]
            gameMode = dictGameData["gameMode"] as? String ?? "public"
           
            if isFromNotification {
                dictContest["id"] = dictGameData["id"]!
                dictContest["level"] = dictGameData["level"]!
                dictContest["name"] = dictGameData["name"]!
                dictContest["rows"] = dictGameData["rows"]!
                dictContest["startDate"] = dictGameData["startDate"]!
                dictContest["type"] = dictGameData["type"]!
                
                viewWillAppear(true)
                gamelevel = dictContest["level"] as? Int ?? 1
                
            }
            
            
            if arrBarcketColor.count <= 0 {
               // SetRandomNumber()
            }
            
            arrSelectedTicket.removeAll()
            for item in arrTickets {
                let isPurchased = item["isPurchased"] as? Bool ?? false
                let gameMode = dictGameData["type"] as? Int ?? 0
                var dictData = item
                if gameMode == 0 {
                    dictData["selectedValue"] = dictGameData["ansRangeMin"] as? Float ?? 0.0
                }
                
                if isPurchased {
                    arrSelectedTicket.append(dictData)
                }
            }
            
         //   self.arrSelectedTicket = self.arrSelectedTicket.filter{($0["status"] as! Int) == 0}
            

            
            print("Set Data",dictGameData)
            let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"
    //        second = (dictGameData["duration"] as? Int)!
    //        print("secondsspre",second)
            
            //
          
           // second = (dictGameData["duration"] as? Int)!
            
           // let arrSloats = self.arrSelectedTicket[0]["slotes"] as! [[String: Any]]
          
       
            if (gameStatus == "notStart") && Int(self.gameTime) ?? 0 > 40{
               // self.configFadeTimer()
            }
            else
            {
                self.slotarr = self.randomarr
                self.deconfigFadeTimer()
                if self.timerautoscroll == nil {
                    self.configAutoscrollTimer()
                }
               
                self.fadevw.isHidden = true
            }
            
            self.arrBrackets = self.dictGameData["boxJson"] as! [[String: Any]]
            let winning_options = self.dictGameData["winning_options"] as! [[String: Any]]
            self.originalarr = [UIImage]()
            for box in self.arrBrackets {
                for option in winning_options {
                    let number = box["number"]!
                    let objectNo = option["objectNo"]!
                    if number as? NSObject == objectNo as? NSObject{
                        self.originalarr.append(self.loadImageFromDocumentDirectory(nameOfImage: option["Item"] as! String))
                    }
                }
            }
    //                        if self.originalarr.count > 0 {
    //                            self.slotarr = self.originalarr
    //                        }
            self.collection_original.reloadData()

      //      self.slotarr = self.itemarr
            
            //
       
            
            if (gameStatus == "start") {
               
                
                self.labelTimer.text = "\(self.second)"
                //second = second - 1
                setTimer()


                
    //            if self.gametype == "spinning-machine" {
    //                btnlockall.isEnabled = true
    //                                                btnlockall.alpha = 1.0
    ////                                                buttonAnsMinus.isEnabled = true
    ////                                                buttonAnsPlus.isEnabled = true
    ////                                                buttonAnsZero.isEnabled = true
    //                collection_lockall.isUserInteractionEnabled = true
    //
    //                                   let  LockAllData = dictGameData["LockAllData"] as? [[String: Any]] ?? []
    //                                    if LockAllData.count > 0 {
    //                                        let isLockAll = LockAllData[0]["isLockAll"] as? Bool ?? false
    //
    //                                        if isLockAll {
    //                                            let displayValue = LockAllData[0]["displayValue"] as? String ?? "0"
    //                                             lbllockedat.text = "locked at: \(LockAllData[0]["lockAllTime"] as? String ?? "0")"
    //                                               btnlockall.isHidden = true
    //                                                btnlock.isHidden = false
    ////                                              buttonAnsMinus.isEnabled = false
    ////                                            buttonAnsPlus.isEnabled = false
    ////                                            buttonAnsZero.isEnabled = false
    //                                            collection_lockall.isUserInteractionEnabled = false
    //                                            lbllockedat.isHidden = false
    //
    //
    //                                        }
    //                                        else
    //                                        {
    //                                          btnlockall.alpha = 1.0
    //                                          btnlockall.isEnabled = true
    //                                          btnlockall.isHidden = false
    //                                          btnlock.isHidden = true
    //                                          lbllockedat.isHidden = true
    ////                                          buttonAnsMinus.isEnabled = true
    ////                                          buttonAnsPlus.isEnabled = true
    ////                                          buttonAnsZero.isEnabled = true
    //                                            collection_lockall.isUserInteractionEnabled = true
    //                                        }
    //                                    }
    //                          else
    //                                    {
    //                                      btnlockall.alpha = 1.0
    //                                      btnlockall.isEnabled = true
    //                                      btnlockall.isHidden = false
    //                                      btnlock.isHidden = true
    //                                      lbllockedat.isHidden = true
    ////                                      buttonAnsMinus.isEnabled = true
    ////                                      buttonAnsPlus.isEnabled = true
    ////                                      buttonAnsZero.isEnabled = true
    //                                        collection_lockall.isUserInteractionEnabled = true
    //                          }
    //            }

                                  

                
                
            } else if gameStatus == "gameEnd" {
//                NotificationCenter.default.removeObserver(self)
//                SocketIOManager.sharedInstance.lastViewController = nil
//                let NewAGSMResultVC = self.storyboard?.instantiateViewController(withIdentifier: "NewAGSMResultVC") as! NewAGSMResultVC
//                NewAGSMResultVC.arrSelectedTikets = arrSelectedTikets
//                NewAGSMResultVC.dictContest = dictGameData
//                self.navigationController?.pushViewController(NewAGSMResultVC, animated: true)
                
                
            } else {
              
                isGameStart = false
                
                btnlock.isHidden = true
                btnlockall.isEnabled = false
                btnlockall.alpha = 0.5
    //            buttonAnsMinus.isEnabled = false
    //            buttonAnsPlus.isEnabled = false
    //            buttonAnsZero.isEnabled = false
                
                collection_lockall.isUserInteractionEnabled = false
                
                if isfromtime {
                     if startTimer == nil {
                             
                                 //  setStartTimer()
                        
                               }
                    else
                     {
                
                    }
                }
               
            }

            tableAnswer.reloadData()
           
        }
        
        func setlockalldata(dictdata:[String:Any])  {
             let gameStatus = dictdata["gameStatus"] as? String ?? "notStart"
                  //  second = (dictdata["duration"] as? Int)!
                 //   print("secondsspre",second)
                    
               
                    
                //    if (gameStatus == "start") {
                       
                        

                        
                        if self.gametype == "spinning-machine" {
                            btnlockall.isEnabled = true
                                                            btnlockall.alpha = 1.0
    //                                                        buttonAnsMinus.isEnabled = true
    //                                                        buttonAnsPlus.isEnabled = true
    //                                                        buttonAnsZero.isEnabled = true
                            collection_lockall.isUserInteractionEnabled = true
                                      
                                      
    //                                           let  LockAllData = dictGameData["LockAllData"] as? [[String: Any]] ?? []
    //                                            if LockAllData.count > 0 {
                                                    let isLockAll = dictdata["isLockAll"] as? Bool ?? false
                                                    
                                                    if isLockAll {
                                                       // let displayValue = dictdata["displayValue"] as? String ?? "0"
                                                         lbllockedat.text = "locked at: \(dictdata["isLockTime"] as? String ?? "0")"
                                                           btnlockall.isHidden = true
                                                            btnlock.isHidden = false
    //                                                      buttonAnsMinus.isEnabled = false
    //                                                    buttonAnsPlus.isEnabled = false
    //                                                    buttonAnsZero.isEnabled = false
                                                        collection_lockall.isUserInteractionEnabled = false
                                                        lbllockedat.isHidden = false
                                                    }
                                                    else
                                                    {
                                                      btnlockall.alpha = 1.0
                                                      btnlockall.isEnabled = true
                                                      btnlockall.isHidden = false
                                                      btnlock.isHidden = true
                                                      lbllockedat.isHidden = true
    //                                                  buttonAnsMinus.isEnabled = true
    //                                                  buttonAnsPlus.isEnabled = true
    //                                                  buttonAnsZero.isEnabled = true
                                                        collection_lockall.isUserInteractionEnabled = true
                                                    }
 
        }
        }
        

        
        var gameTime = String()
        var time = String()
        

        
        func setColors() {
            
        }
        

        
        func timeString(time: TimeInterval) -> String {
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let secounds = Int(time) % 60
            
            let strTime = String(format: "%02i:%02i:%02i", hours, minutes, secounds)
            return strTime
        }
        
        private func setTimer() {
            if startTimer != nil {
                startTimer!.invalidate()
                startTimer = nil
            }
            if timer == nil {
                
                timer = Timer.scheduledTimer(timeInterval:1,
                                             target: self,
                                             selector: #selector(handleTimer),
                                             userInfo: nil,
                                             repeats: true)
                
                 RunLoop.current.add(timer!, forMode: .common)
              //  RunLoop.current.add(self.startTimer!, forMode: RunLoop.Mode.common)
                
            }
            
         
        }
        
        @objc func handleTimer(){
            if second > 0 {

               // setnewData()
                self.labelTimer.text = String(format: "%02i", self.second)
                second = second - 1
                msecond = 999
                
                
            } else {
                //print("Timer Not Start")
                if timer != nil {
                    self.labelTimer.text = "00"
                    timer!.invalidate()
                    timer = nil
                    NotificationCenter.default.removeObserver(self)
                    let NewAGSMResultVC = self.storyboard?.instantiateViewController(withIdentifier: "NewAGSMResultVC") as! NewAGSMResultVC
                    NewAGSMResultVC.dictContest = dictGameData
                    NewAGSMResultVC.arrSelectedTikets = arrSelectedTikets
                    self.navigationController?.pushViewController(NewAGSMResultVC, animated: true)
                }
            }
        }
        
//        private func setEndTimer() {
//
//            if endGameTimer == nil {
//
//                if viewAnimation == nil {
//                    viewAnimation = ViewAnimation.instanceFromNib() as? ViewAnimation
//                    viewAnimation!.frame = view.bounds
//                    view.addSubview(viewAnimation!)
//                }
//
//                endGameTimer = Timer.scheduledTimer(timeInterval: 1,
//                                                    target: self,
//                                                    selector: #selector(handleEndTimer),
//                                                    userInfo: nil,
//                                                    repeats: true)
//            }
//        }
//
//        @objc func handleEndTimer () {
//            if endGameSecond > 0 {
//                endGameSecond = endGameSecond - 1
//                if setSoundEffect == nil {
//                    setSound()
//                }
//            } else {
//
//                if endGameTimer != nil {
//                    endGameTimer!.invalidate()
//                    endGameTimer = nil
//
//                    if setSoundEffect != nil {
//                        setSoundEffect!.stop()
//                    }
//
//                    NotificationCenter.default.removeObserver(self)
//                    let NewAGSMResultVC = self.storyboard?.instantiateViewController(withIdentifier: "NewAGSMResultVC") as! NewAGSMResultVC
//                    NewAGSMResultVC.dictContest = dictGameData
//                    NewAGSMResultVC.arrSelectedTikets = arrSelectedTikets
//                    self.navigationController?.pushViewController(NewAGSMResultVC, animated: true)
//                }
//            }
//        }
        
        func setSound() {
            do{
                setSoundEffect = try AVAudioPlayer(contentsOf: soundURL!)
                setSoundEffect!.numberOfLoops = 4
                setSoundEffect!.play()
            } catch {
                print("Error In Sound PLay")
            }
        }
        //MARK: - Button Method
        @IBAction func buttonBack(_ sender: Any) {
            NotificationCenter.default.removeObserver(self)
           // self.navigationController?.popViewController(animated: true)
            self.navigationController?.popToRootViewController(animated: true)
    //        let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
    //        self.navigationController?.pushViewController(DashboardVC, animated: true)
        }
        @IBAction func buttonInfo(_ sender: Any) {
            let gameInfo = GamePlayInfo.instanceFromNib() as! GamePlayInfo
            gameInfo.frame = view.bounds
            view.addSubview(gameInfo)
        }
        var isclick = false
        @IBAction func playpause_click(_ sender: UIButton) {
            if isclick {
                isclick = false
                imgplaypause.image = UIImage(named: "pause")
                lblplaypause.text = "pause"
                configStartTimer()
                configAutoscrollTimer()
            }
            else
            {
                isclick = true
                imgplaypause.image = UIImage(named: "play-button")
                lblplaypause.text = "play"
                deconfigStartTimer()
                deconfigAutoscrollTimer()
            }
        }
    }

//MARK: - Collection View Delegate Method
extension NewAGSMPlayVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collection_slot {
            return slotarr.count
        }
        if collectionView == collection_original {
            return originalarr.count
        }
        if collectionView == collection_lockall
        {
            return arrSloat.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == collection_slot {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotcell", for: indexPath) as! slotcell
            cell.imgImage.image = slotarr[indexPath.row]//.imageByMakingWhiteBackgroundTransparent()
            return cell
        }
        if collectionView == collection_original {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotcell", for: indexPath) as! slotcell
            cell.imgImage.image = originalarr[indexPath.row]//.imageByMakingWhiteBackgroundTransparent()
            return cell
        }
        if collectionView == collection_lockall {
            let lockcell = collectionView.dequeueReusableCell(withReuseIdentifier: "lockallcell", for: indexPath) as! lockallcell
            
            if strDisplayValuelockall == arrSloat[indexPath.row]["displayValue"] as? String ?? "" {
                lockcell.contentView.layer.borderColor = UIColor.black.cgColor
                lockcell.contentView.layer.borderWidth = 2
            }
            else
            {
                lockcell.contentView.layer.borderColor = UIColor.black.cgColor
                lockcell.contentView.layer.borderWidth = 0
            }
            
        //    let strDisplayValue = arrSloat[indexPath.row]["displayValue"] as! String
          
//                 if strDisplayValue == "Draw" {
//                     let strMainString = strDisplayValue.replacingOccurrences(of: " ", with: "\n")
//                    lockcell.labelDisplayValue.text = strMainString
//                    lockcell.labelDisplayValue.isHidden = false
//                    lockcell.img.isHidden = true
//                 }
//                 else
//                 {
                    lockcell.labelDisplayValue.isHidden = true
                    lockcell.img.isHidden = false
                     let localimg = loadImageFromDocumentDirectory(nameOfImage: arrSloat[indexPath.row]["displayValue"] as! String)
                    lockcell.img.image =  localimg//.imageByMakingWhiteBackgroundTransparent()
          //       }
          
            return lockcell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collection_lockall
        {
            strDisplayValuelockall = arrSloat[indexPath.row]["displayValue"] as? String ?? ""
                    
//            if strDisplayValuelockall == "Draw" {
//                labelanswerselected.isHidden = false
//                imgselected.isHidden = true
//                labelanswerselected.text = strDisplayValuelockall
//            }
//            else
//            {
                labelanswerselected.isHidden = true
                imgselected.isHidden = false
                imgselected.image = loadImageFromDocumentDirectory(nameOfImage: strDisplayValuelockall ?? "")//.imageByMakingWhiteBackgroundTransparent()
         //   }
            collection_lockall.reloadData()
    }
    }
}

//MARK: - TableView Delegate
extension NewAGSMPlayVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedTicket.count
      //  return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrSloats = arrSelectedTicket[indexPath.row]["slotes"] as! [[String: Any]]
        let isLock = arrSelectedTicket[indexPath.row]["isLock"] as? Bool ?? false
                if isLock && isGameStart {

                    let fixCell = tableView.dequeueReusableCell(withIdentifier: "SMGameAnswerThreeLockTVC") as! SMGameAnswerThreeLockTVC
                    
                    let strAmount = "\(arrSelectedTicket[indexPath.row]["amount"]!)"
                    //fixCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
                    let test = Double(strAmount) ?? 0.00
                    fixCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                    
                    
//                    let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
//                    fixCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                    fixCell.labelTotalTickets.text = "\(arrSelectedTicket[indexPath.row]["no_of_players"]!)"
                    let strWinnings = "\(arrSelectedTicket[indexPath.row]["totalWinnings"]!)"
                    fixCell.labelTotalWinnig.text = "\(MyModel().getCurrncy(value: Double(strWinnings)!))"
                    let strWinners = "\(arrSelectedTicket[indexPath.row]["maxWinners"]!)"
                    fixCell.labelMaxWinners.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
                    
                    fixCell.widthView = view.frame.width - 105.0
                    
                    fixCell.arrData = arrSloats
                    
                    fixCell.labelLockTime.text = "Locked at:\(arrSelectedTicket[indexPath.row]["lockTime"] as? String ?? "--")"
                    
                    for item in arrSloats {
                        let isSelected = item["isSelected"] as? Bool ?? false
                        if isSelected {
                          //  fixCell.labelAnsSelected.text = item["displayValue"] as? String ?? "0"
                            let localimg = loadImageFromDocumentDirectory(nameOfImage: item["displayValue"] as? String ?? "0")
                            if imageIsNullOrNot(imageName: localimg) {
                                fixCell.imgselected.image =  localimg//.imageByMakingWhiteBackgroundTransparent()
                                fixCell.imgselected.isHidden = false
                                fixCell.labelAnsSelected.isHidden = true
                            }
                            else
                            {
                                fixCell.labelAnsSelected.text = item["displayValue"] as? String ?? "0"
                                fixCell.imgselected.isHidden = true
                                fixCell.labelAnsSelected.isHidden = false
                            }
                            
                        }
                    }
                    
                    let strSelected = arrSelectedTicket[indexPath.row]["displayValue"] as? String ?? ""
                    if strSelected != "" {
                     // fixCell.labelAnsSelected.text = strSelected
                        let localimg = loadImageFromDocumentDirectory(nameOfImage: strSelected)
//                        if imageIsNullOrNot(imageName: localimg) {
//                            fixCell.imgselected.image =  localimg.imageByMakingWhiteBackgroundTransparent()
//                        }
                        if imageIsNullOrNot(imageName: localimg) {
                            fixCell.imgselected.image =  localimg//.imageByMakingWhiteBackgroundTransparent()
                            fixCell.imgselected.isHidden = false
                            fixCell.labelAnsSelected.isHidden = true
                        }
                        else
                        {
                            fixCell.labelAnsSelected.text = strSelected
                            fixCell.imgselected.isHidden = true
                            fixCell.labelAnsSelected.isHidden = false
                        }
                       
                    }
                    
                    
                    return fixCell
                } else {
                   
                    let fixCell = tableView.dequeueReusableCell(withIdentifier: "SMGameAnswerThreeTVC",  for: indexPath) as! SMGameAnswerThreeTVC
                    
                    fixCell.delegate = self
                    let strAmount = "\(arrSelectedTicket[indexPath.row]["amount"]!)"
                    //fixCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
                    let test = Double(strAmount) ?? 0.00
                    fixCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                    
                    
                    
//                    let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
//                    fixCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                    fixCell.labelTotalTickets.text = "\(arrSelectedTicket[indexPath.row]["no_of_players"]!)"
                    let strWinnings = "\(arrSelectedTicket[indexPath.row]["totalWinnings"]!)"
                    fixCell.labelTotalWinnig.text = "\(MyModel().getCurrncy(value: Double(strWinnings)!))"
                    let strWinners = "\(arrSelectedTicket[indexPath.row]["maxWinners"]!)"
                    fixCell.labelMaxWinners.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
                    
                    fixCell.arrData = arrSloats
                    fixCell.isStart = isGameStart
                    
                    
                    
                    if isGameStart && second <= 30 {
                        fixCell.buttonLockNow.isEnabled = true
                        fixCell.buttonLockNow.alpha = 1
                        fixCell.buttonLockNow.addTarget(self,
                                                        action: #selector(buttonLockNow(_:)),
                                                        for: .touchUpInside)
                        fixCell.buttonLockNow.tag = indexPath.row
                        
                    } else {
                        fixCell.buttonLockNow.isEnabled = false
                        fixCell.buttonLockNow.alpha = 0.5
                        
                    }
                    return fixCell
                }
            
        }
    
    func imageIsNullOrNot(imageName : UIImage)-> Bool
    {

       let size = CGSize(width: 0, height: 0)
       if (imageName.size.width == size.width)
        {
            return false
        }
        else
        {
            return true
        }
    }

 //   }
    
    //MARK: - TableView Button Method
    
    
    @objc func buttonLockNow(_ sender: UIButton) {
        let index = sender.tag
        setAnswerLock(index: index)
    }
    
    func  setAnswerLock(index: Int) {
        var startValue: Int?
        var endValue: Int?
        var gameno: Int?
        var strDisplayValue: String?
        if Lockall1 == nil {
               Lockall1 = LockAll.instanceFromNib() as? LockAll
               Lockall1!.frame = view.bounds
               view.addSubview(Lockall1!)

           }
        let arrSloatsSelect = arrSelectedTicket[index]["slotes"] as! [[String: Any]]
        
        for item in arrSloatsSelect {
            let isSelected = item["isSelected"] as? Bool ?? false
            if isSelected {
                
                startValue = item["startValue"] as? Int
                endValue = item["endValue"] as? Int
                gameno = item["game_no"] as? Int
                strDisplayValue = item["displayValue"] as? String
                break
            }
        }
        
        if startValue == nil && endValue == nil {
            //Alert().showTost(message: "Select Answer", viewController: self)
        } else {
//            let parameter:[String: Any] = ["userId": Define.USERDEFAULT.value(forKey: "UserID")!,
//                                           "contestId": dictContest["id"]!,
//                                           "contestPriceId": arrSelectedTicket[index]["contestpriceID"]!,
//                                           "startValue": startValue!,
//                                           "endValue": endValue!,
//                                           "isLock": 1,
//                                         //  "position": index,
//                                           "displayValue": strDisplayValue!,]
            
            let parameter:[String: Any] = ["userId":"\(Define.USERDEFAULT.value(forKey: "UserID") ?? "0")",
                                           "contestId": "\(arrSelectedTicket[index]["contestId"] ?? "0")",
                                           "contestPriceId":"\(arrSelectedTicket[index]["contestPriceId"] ?? "0")",
                                           "gameNo":String(gameno!),
                                           "startValue":String(startValue!),
                                           "endValue":String(endValue!),
                                           "IsLockAll":0,
                                           "DisplayValue":strDisplayValue ?? ""
            ]
                                           
            print("Parameter: \(parameter)")
            
            let jsonString = MyModel().getJSONString(object: parameter)
            let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
            let strBase64 = encriptString.toBase64()
            
            SocketIOManager.sharedInstance.socket.emitWithAck("AnytimeUpdateGameAll", strBase64!).timingOut(after: 0) { (data) in
                print("Data: \(data)")
                
                guard let strValue = data[0] as? String else {
                    Alert().showAlert(title: "Alert",
                                      message: Define.ERROR_SERVER,
                                      viewController: self)
                    return
                }
                
                let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
                let dictData = MyModel().convertToDictionary(text: strJSON)
                print("Get Data: \(dictData!)")
                
                let status = dictData!["statusCode"] as? Int ?? 0
                if status == 200 {
                    self.Lockall1?.removeFromSuperview()
                    self.Lockall1 == nil
                    let dictItemData = dictData!["content"] as! [[String: Any]]
                    var dictTicket = self.arrSelectedTicket[index]
                    dictTicket["isLock"] = dictItemData[0]["isLock"]
                    dictTicket["lockTime"] = dictItemData[0]["isLockTime"]
                    dictTicket["displayValue"] = dictItemData[0]["displayValue"]
                    dictTicket["isSelected"] = true
                    self.arrSelectedTicket[index] = dictTicket
                    let indexPath = IndexPath(row: index, section: 0)
                  // self.tableAnswer.reloadRows(at: [indexPath], with: .none)
                    self.tableAnswer.reloadData()
                    self.getContestDetail(isfromtimer: true, isStart: 0)
                }
            }
        }
        
    }
    
}

//MARK: - AnswerCell Delegate Method
extension NewAGSMPlayVC: SMGameAnswerThreeDelegate, GameAnsRangeDelegate {
    func getRanges(_ sender: GameAnsRangeTVC, minRange: Int, maxRange: Int, selectedRange: Int) {
        
    }
    
    
    func getSloatData(_ sender: SMGameAnswerThreeTVC, arrData: [[String : Any]]) {
        guard let index = tableAnswer.indexPath(for: sender) else {
            return
        }
        print("Index: \(index.row)")
        
        
        var dictTicket = arrSelectedTicket[index.row]
        
        dictTicket["slotes"] = arrData
        
        arrSelectedTicket[index.row] = dictTicket
        
        let indexPath = IndexPath(row: index.row, section: 0)
        let cell = tableAnswer.cellForRow(at: indexPath) as! SMGameAnswerThreeTVC
        
        for item in arrData {
            let isSelected = item["isSelected"] as? Bool ?? false
            if isSelected {
                
               // cell.labelAnsSelected.text = item["displayValue"] as? String ?? "0"
                let localimg = loadImageFromDocumentDirectory(nameOfImage: item["displayValue"] as? String ?? "0")
//                if imageIsNullOrNot(imageName: localimg) {
//                    cell.imgselected.image =  localimg.imageByMakingWhiteBackgroundTransparent()
//                }
                if imageIsNullOrNot(imageName: localimg) {
                    cell.imgselected.image =  localimg//.imageByMakingWhiteBackgroundTransparent()
                    cell.imgselected.isHidden = false
                    cell.labelAnsSelected.isHidden = true
                }
                else
                {
                    cell.labelAnsSelected.text =  item["displayValue"] as? String ?? "0"
                    cell.imgselected.isHidden = true
                    cell.labelAnsSelected.isHidden = false
                }
                
                
            }
        }
    }
}
