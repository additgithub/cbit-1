//
//  NewCGGamePlayVC.swift
//  CBit
//
//  Created by Mobcast on 14/05/22.
//  Copyright © 2022 Bhavik Kothari. All rights reserved.
//

import UIKit
import AVFoundation
import SocketIO

class NewCGGamePlayVC: UIViewController {
    
    @IBOutlet weak var btnlock: UIImageView!
    
    @IBOutlet weak var imglock09: UIImageView!
    @IBOutlet weak var btnzero: UIButton!
    
    @IBOutlet weak var btnonee: UIButton!
    
    @IBOutlet weak var btntwo: UIButton!
    
    @IBOutlet weak var btnthree: UIButton!
    
    @IBOutlet weak var btnfour: UIButton!
    
    @IBOutlet weak var btnfive: UIButton!
    
    @IBOutlet weak var btnsix: UIButton!
    
    
    @IBOutlet weak var btnseven: UIButton!
    
    @IBOutlet weak var btneeight: UIButton!
    
    
    @IBOutlet weak var btnnine: UIButton!
    
    @IBOutlet weak var buttonAnsMinus: ButtonWithRadius!
    
    @IBOutlet weak var labelanswerselected: UILabel!
    
    @IBOutlet weak var buttonAnsZero: ButtonWithRadius!
    
    
    @IBOutlet weak var buttonAnsPlus: ButtonWithRadius!
    
    @IBOutlet weak var viewrdb: UIView!
    
    @IBOutlet weak var view0to9: UIView!
    
    @IBOutlet weak var btnlockall: ButtonWithRadius!
    
    
    var lockall :String = ""
    var gametype : String = ""
    var strDisplayValuelockall: String?
    
    @IBOutlet weak var labelAnsMinus: UILabel!
    @IBOutlet weak var labelAnsZero: UILabel!
    
    @IBOutlet weak var labelAnsPlus: UILabel!
    
    //MARK: - Properites
    @IBOutlet weak var viewTimmer: UIView!
    @IBOutlet weak var collectionGame: UICollectionView!
    @IBOutlet weak var tableAnswer: UITableView!
    @IBOutlet weak var labelContestName: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet var btnlockallnumber: ButtonWithRadius!
    @IBOutlet var lbllockedat: UILabel!
    
    @IBOutlet weak var constrainCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var lblnumberanswerselected: UILabel!
    @IBOutlet weak var imgplaypause: UIImageView!
    @IBOutlet weak var lblplaypause: UILabel!
    @IBOutlet weak var btnplaypause: UIButton!
    
     var arrSelectedTikets = [[String: Any]]()
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
    var StartSecond = 14
    var miliSecondValue = 0
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
    
    var AnyTimedictContest = [[String: Any]]()
    
    @IBOutlet weak var imgTower: UIImageView!
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        tableAnswer.rowHeight = UITableView.automaticDimension
        tableAnswer.tableFooterView = UIView()
        
        
        
        
        
//        speedtimer = Timer.scheduledTimer(timeInterval:4,
//                                                target: self,
//                                                selector: #selector(handleTimerSpeed),
//                                                userInfo: nil,
//                                                repeats: true)
      //  checkForSpeedTest()
        
        if !isFromNotification {
            
            gamelevel = dictContest["level"] as? Int ?? 1
          //  let date = dictContest["startDate"] as! String
           
        }
        
//        NotificationCenter.default.addObserver(self,
//                                                      selector: #selector(handleNotificationEnterPage(_:)),
//                                                      name: .EnterGamePage,
//                                                      object: nil)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(handleNotification(_:)),
//                                               name: .startGame,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(handleEndGameNotication(_:)),
//                                               name: .endGame,
//                                               object: nil)
        let path = Bundle.main.path(forResource: "Tick Tock.mp3", ofType: nil)!
        soundURL = URL(fileURLWithPath: path)
        
        
     //   isShowLoading = true
      //  getContestDetail(isfromtimer: false, isStart: 0)
      //  arrSelectedTicket = arrSelectedTikets
        
     
        if startTimer == nil {
           setStartTimer()
           
           if arrBarcketColor.count <= 0 {
               SetRandomNumber()
           }
                  }
       else
        {
           
       }
      
        isGameStart = false
        
        btnlock.isHidden = true
        btnlockall.isEnabled = false
        btnlockall.alpha = 0.5
        buttonAnsMinus.isEnabled = false
        buttonAnsPlus.isEnabled = false
        buttonAnsZero.isEnabled = false
        
        btnlockallnumber.isEnabled = false
        btnlockallnumber.alpha = 0.5
        
        btnonee.isEnabled = false
        btntwo.isEnabled = false
        btnthree.isEnabled = false
        btnfour.isEnabled = false
        btnfive.isEnabled = false
        btnsix.isEnabled = false
        btnseven.isEnabled = false
        btneeight.isEnabled = false
        btnnine.isEnabled = false
        btnzero.isEnabled = false
        
        configStartTimer()
        joinContest()
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFromNotification {
          //  labelTimer.text = "Game starts in \(timeString(time: TimeInterval(startSecond)))"
        }
        SocketIOManager.sharedInstance.lastViewController = self
       // SwiftPingPong.shared.startPingPong()
     //   self.startlistner()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SocketIOManager.sharedInstance.lastViewController = nil
        SwiftPingPong.shared.stopPingPong()
        deconfigStartTimer()
    }
    
    func configStartTimer()
    {
        startTimer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(NewCGGamePlayVC.HandleStartTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(self.startTimer!, forMode: .common)
    }
    
    func deconfigStartTimer()
    {
        startTimer?.invalidate()
    }
    
    @objc func HandleStartTimer()
    {
        StartSecond = StartSecond-1

        labelTimer.text = "Game starts in: \(StartSecond)"
                if StartSecond == 1 {
//                    dictGameData["gameStatus"] = "start"
//                    self.setData(isfromtime: true)
                    self.getContestDetail(isfromtimer: true, isStart: 0)
                    if startTimer != nil {
                    startTimer!.invalidate()
                    startTimer = nil
                    }
                   deconfigStartTimer()
                    btnplaypause.isHidden = true
                    imgplaypause.isHidden = true
                    lblplaypause.isHidden = true
                   // joinContest()
                }
    }
    
    
    @IBAction func btn_nopressed(_ sender: UIButton) {
       
        if sender.tag == 0
        {
            strDisplayValuelockall = "0"
             btnzero.backgroundColor = UIColor.white
             btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
             btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
             btnthree.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
             btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
             btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
             btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
             btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
             btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
             btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            
        }
       
        else if sender.tag == 1
        {
            
            strDisplayValuelockall = "1"
          
            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnonee.backgroundColor = UIColor.white
            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        
        }
        
        else if sender.tag == 2
        {
            strDisplayValuelockall = "2"
        
            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btntwo.backgroundColor = UIColor.white
            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        }
       
        else if sender.tag == 3
        {
            strDisplayValuelockall = "3"
            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnthree.backgroundColor = UIColor.white
            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            
        }
        else if sender.tag == 4
        {
            strDisplayValuelockall = "4"
            
            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfour.backgroundColor = UIColor.white
            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)

        }
       
        else if sender.tag == 5
        {
            strDisplayValuelockall = "5"
            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfive.backgroundColor = UIColor.white
            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        
        }
       
        else if sender.tag == 6
        {
            strDisplayValuelockall = "6"
            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnsix.backgroundColor = UIColor.white
            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        }
        
        else if sender.tag == 7
        {
            strDisplayValuelockall = "7"
            
            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnseven.backgroundColor = UIColor.white
            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        }
        else if sender.tag == 8
        {
            strDisplayValuelockall = "8"
            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btneeight.backgroundColor = UIColor.white
            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        }
        else if sender.tag == 9
        {
           
            strDisplayValuelockall = "9"
            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
            btnnine.backgroundColor = UIColor.white
            
        }
        lblnumberanswerselected.text! = strDisplayValuelockall ?? ""
    }
    
    @IBAction func btn_lockall(_ sender: Any) {
        
//         let fixCell = tableAnswer.dequeueReusableCell(withIdentifier: "GameAnswerTwoTVC") as! GameAnswerTwoTVC
//        fixCell.buttonLockNow.isEnabled = false
//        fixCell.buttonLockNow.alpha = 0.5
//        if LockAll == nil {
//            LockAll = LockAll.LockAll.instanceFromNib() as? LockAll
//            LockAll!.frame = view.bounds
//            view.addSubview(LockAll!)
//        }
        
     //   print("selection",strDisplayValuelockall!)
        if strDisplayValuelockall == nil
        {
           
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.locakall()

            }
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
           imglock09.isHidden = false
        
           btnlockallnumber.isEnabled = false
           btnlockallnumber.alpha = 0.5
        
           buttonAnsMinus.isEnabled = false
           buttonAnsPlus.isEnabled = false
           buttonAnsZero.isEnabled = false
        
           btnonee.isEnabled = false
           btntwo.isEnabled = false
           btnthree.isEnabled = false
           btnfour.isEnabled = false
           btnfive.isEnabled = false
           btnsix.isEnabled = false
           btnseven.isEnabled = false
           btneeight.isEnabled = false
           btnnine.isEnabled = false
           btnzero.isEnabled = false
        
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
            if self.gametype == "rdb" {
                if strDisplayValuelockall == displayValue {
                    startValue = item["startValue"] as? Int
                    endValue = item["endValue"] as? Int
                //    strDisplayValue = item["displayValue"] as? String
                    break
                }
            }
            else
            {
                let start = item["startValue"] as? Int ?? 0
                let end = item["endValue"] as? Int ?? 0
                if  Int(strDisplayValuelockall ?? "0") ?? 0 >= start && Int(strDisplayValuelockall ?? "0") ?? 0 <= end {
                    startValue = item["startValue"] as? Int
                    endValue = item["endValue"] as? Int
                //    strDisplayValue = item["displayValue"] as? String
                    break
                }
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
                  // print("Data: \(data)")
                   
                   guard let strValue = data[0] as? String else {
                       Alert().showAlert(title: "Alert",
                                         message: Define.ERROR_SERVER,
                                         viewController: self)
                       return
                   }
                   
                   
                   let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
                   let dictData = MyModel().convertToDictionary(text: strJSON)
                   print("AnytimeUpdateGameAll:",dictData!)
                   let status = dictData!["statusCode"] as? Int ?? 0
                   if status == 200 {
                       self.Lockall1?.removeFromSuperview()
                       
                    let dictItemData1 = dictData!["content"] as! [[String: Any]]
                       
                    let i = 0
                       
                       for i in i..<self.arrSelectedTicket.count {
                           
                        let dictItemData = dictItemData1[0]
                       var dictTicket = self.arrSelectedTicket[i]
                       dictTicket["isLock"] = dictItemData["isLockAll"]
                       dictTicket["displayValue"] = dictItemData["displayValue"]
                       dictTicket["isSelected"] = dictItemData["isLock"]
                        dictTicket["lockTime"] = dictItemData["isLockTime"]
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
    
    @IBAction func btnAnsMinus(_ sender: Any) {
        
        let arrSloats = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
        
      // labelanswerselected.text! = arrSloats[0]["displayValue"] as? String ?? "-"
        labelanswerselected.text! = labelAnsMinus.text ?? ""
       // buttonAnsMinus.backgroundColor = UIColor.red
        buttonAnsMinus.backgroundColor = UIColor.white
         // buttonAnsPlus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        //  buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        labelAnsMinus.textColor = UIColor.black
        labelAnsPlus.textColor = UIColor.white
        
        buttonAnsPlus.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.2, blue: 1, alpha: 1)
        buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        
        strDisplayValuelockall = arrSloats[0]["displayValue"] as? String ?? ""
        
        
    }
    
    
    @IBAction func btnAnsZero(_ sender: Any) {
        
        
        let arrSloats = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
      //  labelanswerselected.text! = arrSloats[1]["displayValue"] as? String ?? "0"
        
        labelanswerselected.text! = labelAnsZero.text ?? ""
        
        buttonAnsPlus.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.2, blue: 1, alpha: 1)
        buttonAnsMinus.backgroundColor = UIColor.red
        buttonAnsZero.backgroundColor = UIColor.white
        
        labelAnsPlus.textColor = UIColor.white
        labelAnsMinus.textColor = UIColor.white
        
        
       //  buttonAnsPlus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
        //buttonAnsMinus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
         strDisplayValuelockall = arrSloats[1]["displayValue"] as? String ?? ""
        
    }
    
    @IBAction func btnAnsPlua(_ sender: Any) {
         
          let arrSloats = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
        // labelanswerselected.text = arrSloats[2]["displayValue"] as? String ?? "+"
          labelanswerselected.text! = labelAnsPlus.text ?? ""
          buttonAnsPlus.backgroundColor = UIColor.white
          labelAnsPlus.textColor = UIColor.black
          labelAnsMinus.textColor = UIColor.white
          buttonAnsMinus.backgroundColor = UIColor.red
          buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
          
        
       //  buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
       //  buttonAnsMinus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
         strDisplayValuelockall = arrSloats[2]["displayValue"] as? String ?? ""
        
    }
    
    override func viewWillLayoutSubviews() {
        
        viewTimmer.layer.cornerRadius = 15
        viewTimmer.layer.masksToBounds = true
        
      
        
        
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
                SetRandomNumber()
            }
            
          //  arrSelectedTicket.removeAll()
//            for item in arrTickets {
//                let isPurchased = item["isPurchased"] as? Bool ?? false
//                let gameMode = dictContest["type"] as? Int ?? 0
//                var dictData = item
//                if gameMode == 0 {
//                    dictData["selectedValue"] = dictGameData["ansRangeMin"] as? Float ?? 0.0
//                }
//
//                if isPurchased {
//                    arrSelectedTicket.append(dictData)
//                }
//            }
            
            //notStart
            //start
        //gameEnd
            
         //   let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"
           // second = (dictGameData["duration"] as? Int)!
            
        if second > 1 {
            
            isGameStart = true
           
//                second = ((dictGameData["duration"] as? Int ?? 30))
//                second = 30
        //    self.labelTimer.text = "\(gameTime)"
           // second = second - 1
           // setTimer()
            if gamestart {
                tableAnswer.reloadData()
                gamestart = false
                buttonAnsPlus.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.2, blue: 1, alpha: 1)
                              buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                              buttonAnsMinus.backgroundColor = UIColor.red
                                
                              btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                              btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                              btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                              btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                              btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                              btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                              btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                              btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                              btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                              btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                
                        btnlockallnumber.isEnabled = true
                        btnlockallnumber.alpha = 1.0
                       
                          btnonee.isEnabled = true
                          btntwo.isEnabled = true
                          btnthree.isEnabled = true
                          btnfour.isEnabled = true
                          btnfive.isEnabled = true
                          btnsix.isEnabled = true
                          btnseven.isEnabled = true
                          btneeight.isEnabled = true
                          btnnine.isEnabled = true
                          btnzero.isEnabled = true
                
                                    btnlockall.alpha = 1.0
                                       btnlockall.isEnabled = true
                                       btnlockall.isHidden = false
                                       btnlock.isHidden = true
                                       lbllockedat.isHidden = true
                                       buttonAnsMinus.isEnabled = true
                                       buttonAnsPlus.isEnabled = true
                                       buttonAnsZero.isEnabled = true
              //  self.getContestDetail(isfromtimer: true, isStart: 0)
             
            }
            
        
            
        }
        else
        {
                isGameStart = false
                
            }
           
            self.collectionGame.reloadData()
//            tableAnswer.reloadData()
        }
    
    private var isGetContest = Bool()
    private var isJoinContest = Bool()
    
    func joinContest() {
        Loading().showLoading(viewController: self)
        var arrSelectedcontestid = [String]()
        var arrSelectedticketsIds = [String]()
       
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
                                       "tickets": strSelectedID1,"list":"[]","Randomlist":"[]"]
        let strURL = Define.APP_URL + Define.API_ANYTIMEJOIN_CONTEST
        
        print("Parameter: \(parameter)\nURL: \(strURL)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strbase64 = encriptString.toBase64()
        
        SwiftAPI().postMethodSecure(stringURL: strURL,
                                    parameters: ["data":strbase64!],
                                    header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                    auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
        { [self] (result, error) in
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
                    self.getContestDetail(isfromtimer: true, isStart: 0)
                    let dictData = result!["content"] as! [String: Any]
                    
                    Define.USERDEFAULT.set(dictData["pbAmount"] as? Double ?? 0.0, forKey: "PBAmount")
                    Define.USERDEFAULT.set(dictData["sbAmount"] as? Double ?? 0.0, forKey: "SBAmount")
                    Define.USERDEFAULT.set(dictData["tbAmount"] as? Double ?? 0.0, forKey: "TBAmount")
                    
                    let GameNumberarr = result!["GameNumber"] as! [[String: Any]]
                    let arrSelectedTiketscopy = arrSelectedTikets
                    
                    for (indexouter,dictouter) in GameNumberarr.enumerated() {
                        for (indexinner,dictinner) in arrSelectedTiketscopy.enumerated() {
                            if dictouter["contestPriceId"] as! Int == dictinner["contestpriceID"] as! Int {
                                arrSelectedTikets[indexinner]["game_played"] = dictouter["game_no"] as! Int
                            }
                        }
                    }
                  //  NotificationCenter.default.post(name: .paymentUpdated, object: nil)
                 
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
            
//            let jsonString = MyModel().getJSONString(object: parameter)
//            let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
//            let strBase64 = encriptString.toBase64()
            
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
                        
                     //   var data = [Any]()
                      //  data.insert(result?["content"] ?? [], at: 0)
//                        guard let strValue = data[0] as? String else {
//                                       Alert().showAlert(title: "Alert",
//                                                         message: Define.ERROR_SERVER,
//                                                         viewController: self)
//                                       return
//                                   }
                                

                                   
//                                   let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
//                                   let dictData = MyModel().convertToDictionary(text: strJSON)
                                   self.dictGameData = result!["content"] as! [String: Any]
                      //  self.arrTickets = self.dictGameData["tickets"] as? [[String: Any]] ?? []
                     //   self.tableAnswer.reloadData()
                                labelContestName.text = dictGameData["name"] as? String ?? "No Name"
                                   self.gametype  = self.dictGameData["game_type"] as! String
                                   if self.gametype == "rdb" {
                                       self.viewrdb.isHidden = false
                                      // self.buttonAnsMinus.backgroundColor = UIColor.red

                                   }
                                   else
                                   {
                                       self.view0to9.isHidden = false
                                   }
                                   let serverDate = self.dictGameData["currentTime"] as? String ?? "\(MyModel().convertDateToString(date: Date(), returnFormate: "yyyy-MM-dd HH:mm:ss"))"
                                   self.currentDate = MyModel().converStringToDate(strDate: serverDate, getFormate: "yyyy-MM-dd HH:mm:ss")

                        
                        let getResponceTime = Date()

                        let calender = Calendar.current
                        let unitFlags = Set<Calendar.Component>([ .second])
                        let dateComponent = calender.dateComponents(unitFlags, from: sendRequestTime, to: getResponceTime)

                                                        self.differenceSecond = dateComponent.second!
                        
                        if isfromtimer {
                        self.setData(isfromtime: isfromtimer)
                        }
             
                       else
                        {
                           
                       }
                                  
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
        
        //
           
       // }
    }
    
    func   setData(isfromtime:Bool) {
        
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
            SetRandomNumber()
        }
        
   
        
        //notStart
        //start
    //gameEnd
        
      //  let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"
       // second = (dictGameData["duration"] as? Int)!
      //  print("secondsspre",second)
        
        if StartSecond == 1 {
            
            //            isGameStart = true
            //            print("secondss",second)
            //           // print(dictGameData["duration"] as? Int)
            //            second = ((dictGameData["duration"] as? Int ?? 30) - differenceSecond - 4)
                       // second = 30
                        self.labelTimer.text = "\(self.second)"
                       // second = second - 1
                        setTimer()
        }
        else
        {
          
            isGameStart = false
            
            btnlock.isHidden = true
            btnlockall.isEnabled = false
            btnlockall.alpha = 0.5
            buttonAnsMinus.isEnabled = false
            buttonAnsPlus.isEnabled = false
            buttonAnsZero.isEnabled = false
            
                                        btnlockallnumber.isEnabled = false
                                        btnlockallnumber.alpha = 0.5
                                     
                                        btnonee.isEnabled = false
                                        btntwo.isEnabled = false
                                        btnthree.isEnabled = false
                                        btnfour.isEnabled = false
                                        btnfive.isEnabled = false
                                        btnsix.isEnabled = false
                                        btnseven.isEnabled = false
                                        btneeight.isEnabled = false
                                        btnnine.isEnabled = false
                                        btnzero.isEnabled = false
        }
        
//        else if gameStatus == "gameEnd" {
//            NotificationCenter.default.removeObserver(self)
//            SocketIOManager.sharedInstance.lastViewController = nil
//            let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "CGGameResultVC") as! CGGameResultVC
//            resultVC.dictContest = dictContest
//            self.navigationController?.pushViewController(resultVC, animated: true)
//
//
//        }
        
        arrSelectedTicket.removeAll()
        for item in arrTickets {
            let isPurchased = item["isPurchased"] as? Bool ?? false
            let gameMode = dictContest["type"] as? Int ?? 0
            var dictData = item
            if gameMode == 0 {
                dictData["selectedValue"] = dictGameData["ansRangeMin"] as? Float ?? 0.0
            }
            
            if isPurchased {
                arrSelectedTicket.append(dictData)
            }
        }

        self.collectionGame.reloadData()
        tableAnswer.reloadData()
    }
    
    func setlockalldata(dictdata:[String:Any])  {
//         let gameStatus = dictdata["gameStatus"] as? String ?? "notStart"
//                second = (dictdata["duration"] as? Int)!
                
           
                
              
         //       if (gameStatus == "start") {
                   
                    if self.gametype == "rdb" {
                        btnlockall.isEnabled = true
                                                        btnlockall.alpha = 1.0
                                                        buttonAnsMinus.isEnabled = true
                                                        buttonAnsPlus.isEnabled = true
                                                        buttonAnsZero.isEnabled = true
                                  
                                  
//                                           let  LockAllData = dictGameData["LockAllData"] as? [[String: Any]] ?? []
//                                            if LockAllData.count > 0 {
                        let isLockAll = dictdata["isLockAll"] as? Bool ?? false
                                                
                                                if isLockAll {
                                                     let displayValue = dictdata["displayValue"] as? String ?? "0"
                                                     lbllockedat.text = "locked at: \(dictdata["isLockTime"] as? String ?? "0")"
                                                       btnlockall.isHidden = true
                                                        btnlock.isHidden = false
                                                      buttonAnsMinus.isEnabled = false
                                                    buttonAnsPlus.isEnabled = false
                                                    buttonAnsZero.isEnabled = false
                                                    lbllockedat.isHidden = false
                                                    if displayValue == "Red win" {
                                                        labelanswerselected.text! = displayValue
                                                            // buttonAnsMinus.backgroundColor = UIColor.red
                                                             buttonAnsMinus.backgroundColor = UIColor.white
                                                              
                                                             labelAnsMinus.textColor = UIColor.black
                                                             labelAnsPlus.textColor = UIColor.white
                                                             
                                                             buttonAnsPlus.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.2, blue: 1, alpha: 1)
                                                             buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                                                    }
                                                    else if displayValue == "Draw" {
                                                        
                                                        labelanswerselected.text! = displayValue
                                                             
                                                             buttonAnsPlus.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.2, blue: 1, alpha: 1)
                                                             buttonAnsMinus.backgroundColor = UIColor.red
                                                             buttonAnsZero.backgroundColor = UIColor.white
                                                             
                                                             labelAnsPlus.textColor = UIColor.white
                                                             labelAnsMinus.textColor = UIColor.white
                                                        
                                                    }
                                                    else if displayValue == "Blue win" {
                                                        labelanswerselected.text! = displayValue
                                                               buttonAnsPlus.backgroundColor = UIColor.white
                                                               labelAnsPlus.textColor = UIColor.black
                                                               labelAnsMinus.textColor = UIColor.white
                                                               buttonAnsMinus.backgroundColor = UIColor.red
                                                               buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                                                    }
                                                }
                                                else
                                                {
                                                  btnlockall.alpha = 1.0
                                                  btnlockall.isEnabled = true
                                                  btnlockall.isHidden = false
                                                  btnlock.isHidden = true
                                                  lbllockedat.isHidden = true
                                                  buttonAnsMinus.isEnabled = true
                                                  buttonAnsPlus.isEnabled = true
                                                  buttonAnsZero.isEnabled = true
                                                }
                                            }
                                  else
                                            {
                                              btnlockall.alpha = 1.0
                                              btnlockall.isEnabled = true
                                              btnlockall.isHidden = false
                                              btnlock.isHidden = true
                                              lbllockedat.isHidden = true
                                              buttonAnsMinus.isEnabled = true
                                              buttonAnsPlus.isEnabled = true
                                              buttonAnsZero.isEnabled = true
                                  }
             //       }
  //  }
    }
    
    func SetRandomNumber() {
        self.view.layoutIfNeeded()
        let rangeMinNumber = dictGameData["ansRangeMin"] as? Int ?? 0
        let rangeMaxNumber = dictGameData["ansRangeMax"] as? Int ?? 99
        if gamelevel == 1 {
            arrRandomNumbers = MyModel().createRandomNumbers(number: 8, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
            arrBarcketColor = MyDataType().getArrayBrackets(index: 8)
            constrainCollectionViewHeight.constant = 50
        } else if gamelevel == 2 {
            arrRandomNumbers = MyModel().createRandomNumbers(number: 16, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
            arrBarcketColor = MyDataType().getArrayBrackets(index: 16)
            constrainCollectionViewHeight.constant = 100
        } else if gamelevel == 3 {
            arrRandomNumbers = MyModel().createRandomNumbers(number: 32, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
            arrBarcketColor = MyDataType().getArrayBrackets(index: 32)
            constrainCollectionViewHeight.constant = 200
        }
        self.view.layoutIfNeeded()
    }
    
    func updateColors() {
        for _ in 1...4 {
            let index = arrBarcketColor.count
            let lastColor = arrBarcketColor[index - 1]
            arrBarcketColor.remove(at: arrBarcketColor.count - 1)
            arrBarcketColor.insert(lastColor, at: 0)
        }
        
        let rangeMinNumber = dictGameData["ansRangeMin"] as? Int ?? 0
        let rangeMaxNumber = dictGameData["ansRangeMax"] as? Int ?? 99
        
        if gamelevel == 1 {
            arrRandomNumbers = MyModel().createRandomNumbers(number: 8, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
            
        } else if gamelevel == 2 {
            
            arrRandomNumbers = MyModel().createRandomNumbers(number: 16, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
            
        } else if gamelevel == 3 {
            
            arrRandomNumbers = MyModel().createRandomNumbers(number: 32, minRange: rangeMinNumber, maxRange: rangeMaxNumber)
            
        }
    }
    
    var gameTime = String()
    var time = String()
    
//    @objc func handleNotificationEnterPage(_ notification: Notification) {
//           print("Game Start.")
//
//           if (notification.userInfo as Dictionary?) != nil {
//             //  print("--> User Info Data: \(notification.userInfo!)")
//
//            let dictData = notification.userInfo!
//            gameTime = String(dictData["gameTime"] as! Int)
//             time = dictData["time"] as! String
//            self.dictGameData = dictData["contest"] as! [String: Any]
//
//
//            self.gametype  = self.dictContest["game_type"] as! String
//            if self.gametype == "rdb" {
//                self.viewrdb.isHidden = false
//            }
//            else
//            {
//                self.view0to9.isHidden = false
//            }
//
//            if dictContest["id"] as! Int == dictGameData["id"] as! Int {
//                print(self.dictGameData)
//                 self.setnewData()
//            }
//
//            Loading().hideLoading(viewController: self)
//
//           } else {
//
//               print("--> No Data")
//               isShowLoading = false
//           }
//       }
    
//    @objc func handleNotification(_ notification: Notification) {
//        print("Game Start.")
//
//        isStartEventCall = true
//        if (notification.userInfo as Dictionary?) != nil {
//            print("--> User Info Data: \(notification.userInfo!)")
//            let contestId = "\(notification.userInfo!["contestId"]!)"
//            let selectedContestID = "\(dictContest["id"]!)"
//            if contestId == selectedContestID {
//                isShowLoading = false
//
//            //    getContestDetail(isfromtimer: true)
//
//
//            }
//        } else {
//
//            print("--> No Data")
//            isShowLoading = false
//
//         //   getContestDetail(isfromtimer: true)
//
//
//
//        }
//    }
    
//    @objc func handleEndGameNotication(_ notification: Notification) {
//        print("Gaem End")
//
//        if (notification.userInfo as Dictionary?) != nil {
//
//            print("--> User Info Data: \(notification.userInfo!)")
//            let contestId = "\(notification.userInfo!["contestId"]!)"
//            let selectedContestID = "\(dictContest["id"]!)"
//            if contestId == selectedContestID {
//             //   setEndTimer()
//
//            }
//        } else {
//
//            print("--> No Data")
//          //  setEndTimer()
//
//        }
//
//    }
    
    func setColors() {
        
    }
    
    //TODO: Timer
    private func setStartTimer() {
        
        startTimer = nil
        startTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(handleStartTimer),
                                     userInfo: nil,
                                     repeats: true)
        

        RunLoop.current.add(self.startTimer!, forMode: RunLoop.Mode.common)

    }
    
    @objc func handleStartTimer() {
        
        // let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"
        
        if StartSecond > 1{
             if miliSecondValue == 0 {
                        miliSecondValue = miliSecondValue + 1
                        updateColors()
                        collectionGame.reloadData()
                    } else if miliSecondValue == 1 {
                        miliSecondValue = 0
                      
                        updateColors()
                        collectionGame.reloadData()
                    }
        }
        else
        {
            if startTimer != nil {
            startTimer!.invalidate()
            startTimer = nil
            }
        }
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
        if second >= 1 {
            

            setnewData()
            self.labelTimer.text = String(format: "%02i", self.second)
            second = second - 1
            msecond = 999
            
            
        } else {
            if timer != nil {
                self.labelTimer.text = "00"
                timer!.invalidate()
                timer = nil
                NotificationCenter.default.removeObserver(self)
                let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "NewCGGameResultVC") as! NewCGGameResultVC
                resultVC.arrSelectedTikets = arrSelectedTikets
                self.navigationController?.pushViewController(resultVC, animated: true)

            }
        }
    }
    
    private func setEndTimer() {
        
        if endGameTimer == nil {
            
            if viewAnimation == nil {
                viewAnimation = ViewAnimation.instanceFromNib() as? ViewAnimation
                viewAnimation!.frame = view.bounds
                view.addSubview(viewAnimation!)
            }
            
            endGameTimer = Timer.scheduledTimer(timeInterval: 1,
                                                target: self,
                                                selector: #selector(handleEndTimer),
                                                userInfo: nil,
                                                repeats: true)
        }
    }
    
    @objc func handleEndTimer () {
        if endGameSecond > 0 {
            endGameSecond = endGameSecond - 1
            if setSoundEffect == nil {
                setSound()
            }
        } else {
            
            if endGameTimer != nil {
                endGameTimer!.invalidate()
                endGameTimer = nil
                
                if setSoundEffect != nil {
                    setSoundEffect!.stop()
                }
                
                NotificationCenter.default.removeObserver(self)
//                let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "CGGameResultVC") as! CGGameResultVC
//                resultVC.dictContest = dictContest
//                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        }
    }
    
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
      //  self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
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
        }
        else
        {
            isclick = true
            imgplaypause.image = UIImage(named: "play-button")
            lblplaypause.text = "play"
            deconfigStartTimer()
        }
    }
}

//MARK: - Collection View Delegate Method
extension NewCGGamePlayVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isGameStart {
            return arrBrackets.count
        } else {
            return arrRandomNumbers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 4, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BracketCVC", for: indexPath) as! BracketCVC
        
        if isGameStart {
            let index = arrBarcketColor[indexPath.row].index
            
            cell.labelNumber.text = "\(arrBrackets[index]["number"]!)"
            cell.viewColor.backgroundColor = arrBarcketColor[indexPath.row].color

            //            let strColor = arrBrackets[indexPath.row]["color"] as? String ?? "red"
//            if strColor == "red" {
//                cell.viewColor.backgroundColor = UIColor.red
//            } else if strColor == "green" {
//                cell.viewColor.backgroundColor = UIColor.green
//            } else if strColor == "blue" {
//                cell.viewColor.backgroundColor = UIColor.blue
//            }
            
        } else {
            cell.labelNumber.text = "\(arrRandomNumbers[indexPath.row])"
            
            cell.viewColor.backgroundColor = arrBarcketColor[indexPath.row].color
        }
        return cell
    }
}

//MARK: - TableView Delegate
extension NewCGGamePlayVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedTicket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gameMode = dictContest["type"] as? Int ?? 1
        if gameMode == 0 {
            //TODO: FLEXI
            let isLock = arrSelectedTicket[indexPath.row]["isLock"] as? Bool ?? false
            if isLock {
          

                let flexiCell = tableView.dequeueReusableCell(withIdentifier: "GameAnsRangeLockTVC") as! GameAnsRangeLockTVC
                
                let strAmount = "\(arrSelectedTicket[indexPath.row]["amount"]!)"
                //flexiCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
                let test = Double(strAmount) ?? 0.00
                flexiCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                
                let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
                
                flexiCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                let strWinnings = "\(arrSelectedTicket[indexPath.row]["totalWinnings"]!)"
                
                flexiCell.labelTotalWinnig.text = "\(MyModel().getCurrncy(value: Double(strWinnings)!))"
                
                let strWinners = "\(arrSelectedTicket[indexPath.row]["maxWinners"]!)"
                
                flexiCell.labelMaxWinners.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
                
                flexiCell.labelMinValue.text = "\(dictGameData["ansRangeMin"]!)"
                
                flexiCell.labelMaxValue.text = "\(dictGameData["ansRangeMax"]!)"
                
                flexiCell.sliderAnswer.minimumValue = dictGameData["ansRangeMin"] as? Float ?? 0.0
                flexiCell.sliderAnswer.maximumValue = dictGameData["ansRangeMax"] as? Float ?? 0.0
                
                let rangeMin = dictGameData["ansRangeMin"] as? Float ?? 0.0
                let rangeMax = dictGameData["ansRangeMax"] as? Float ?? 0.0
                
                let range = arrSelectedTicket[indexPath.row]["bracketSize"] as? Float ?? 0.0
                flexiCell.sliderAnswer.setThumbImage(MyModel().getImageForRange(range: Int(range),rangeMaxValue: Int(abs(rangeMin - rangeMax))),
                                                     for: .normal)
                
                flexiCell.sliderAnswer.isUserInteractionEnabled = false
                
                //let strSelected = arrSelectedTicket[indexPath.row]["displayValue"] as? String ?? "0 to 0"
                
                let dictUserSelectData = arrSelectedTicket[indexPath.row]["user_select"] as! [String: Any]
                
                let strSelectedValueMin = "\(dictUserSelectData["startValue"]!)"
                let selectedRangeMin = Int(strSelectedValueMin)
                let strSelectedValueMax = "\(dictUserSelectData["endValue"]!)"
                let selectedRangeMax = Int(strSelectedValueMax)
                
                
                flexiCell.labelAnsSelected.text = "\(dictUserSelectData["startValue"]!) to \(dictUserSelectData["endValue"]!)"
                if selectedRangeMax == Int(rangeMax) {
                    flexiCell.sliderAnswer.value = rangeMax
                } else if (selectedRangeMin! + Int(range)) > Int(rangeMax) {
                    flexiCell.sliderAnswer.value = Float(selectedRangeMin!)
                } else if (selectedRangeMax! - Int(range)) < Int(rangeMin) {
                    flexiCell.sliderAnswer.value = Float(selectedRangeMax!)
                } else {
                    flexiCell.sliderAnswer.value = Float(selectedRangeMin!)
                }
                
                flexiCell.labelLockTime.text = "locked at: \(arrSelectedTicket[indexPath.row]["lockTime"] as? String ?? "--")"
                
                return flexiCell
            } else {
                let flexiCell = tableView.dequeueReusableCell(withIdentifier: "GameAnsRangeTVC") as! GameAnsRangeTVC
                
                let dictUserSelectData = arrSelectedTicket[indexPath.row]["user_select"] as! [String: Any]
                
                if isLock {
                    flexiCell.viewUnLocked.isHidden = true
                    flexiCell.viewLocked.isHidden = false
                    flexiCell.labelLockedAnswer.text = "\(dictUserSelectData["startValue"]!) to \(dictUserSelectData["endValue"]!)"
                    flexiCell.labelLockedAt.text = "locked at: \(arrSelectedTicket[indexPath.row]["lockTime"] as? String ?? "--")"
                    
                } else {
                    flexiCell.viewUnLocked.isHidden = false
                    flexiCell.viewLocked.isHidden = true
                    flexiCell.labelLockedAt.text = ""
                }
                
                flexiCell.delegate = self
                
                let strAmount = "\(arrSelectedTicket[indexPath.row]["amount"]!)"
                //flexiCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
                let test = Double(strAmount) ?? 0.00
                flexiCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                
                
                
                let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
                flexiCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                let strWinnings = "\(arrSelectedTicket[indexPath.row]["totalWinnings"]!)"
                flexiCell.labelTotalWinnig.text = "\(MyModel().getCurrncy(value: Double(strWinnings)!))"
                let strWinners = "\(arrSelectedTicket[indexPath.row]["maxWinners"]!)"
                flexiCell.labelMaxWinners.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
                
                flexiCell.labelMinRange.text = "\(dictGameData["ansRangeMin"]!)"
                flexiCell.labelMaxRange.text = "\(dictGameData["ansRangeMax"]!)"
                
                flexiCell.sliderAnswer.minimumValue = dictGameData["ansRangeMin"] as? Float ?? 0.0
                flexiCell.sliderAnswer.maximumValue = dictGameData["ansRangeMax"] as? Float ?? 0.0
                //flexiCell.sliderAnswer.value = arrSelectedTicket[indexPath.row]["selectedValue"] as? Float ?? 0.0
                flexiCell.selectedIndex = arrSelectedTicket[indexPath.row]["selectedValue"] as? Double ?? 0.0
                
                let rangeMin = dictGameData["ansRangeMin"] as? Float ?? 0.0
                let rangeMax = dictGameData["ansRangeMax"] as? Float ?? 0.0
                
                let range = arrSelectedTicket[indexPath.row]["bracketSize"] as? Float ?? 0.0
                flexiCell.sliderAnswer.setThumbImage(MyModel().getImageForRange(range: Int(range),
                                                                                rangeMaxValue: Int(abs(rangeMin - rangeMax))),
                                                     for: .normal)

                
                flexiCell.dictData = nil
                flexiCell.dictData = arrSelectedTicket[indexPath.row]
                
                flexiCell.buttonLockNow.addTarget(self,
                                                  action: #selector(buttonRangeAnsLock(_:)),
                                                  for: .touchUpInside)
                flexiCell.buttonLockNow.tag = indexPath.row
                
                if isGameStart && second <= 30 {
                    flexiCell.sliderAnswer.value = rangeMin
                    flexiCell.buttonLockNow.isEnabled = true
                    flexiCell.buttonLockNow.alpha = 1
                    flexiCell.sliderAnswer.isUserInteractionEnabled = true
                    flexiCell.imageDummyBar.isHidden = true
                    flexiCell.labelDummyBarVal.isHidden = true
                    flexiCell.isGameStart = true
                    flexiCell.labelAnsSelected.text = "\(Int(flexiCell.rangeMin)) to \(Int(flexiCell.rangeMax))"
                } else {
                    flexiCell.sliderAnswer.setThumbImage(UIImage(), for: .normal)
                    flexiCell.sliderAnswer.isUserInteractionEnabled = false
                    flexiCell.buttonLockNow.isEnabled = false
                    flexiCell.buttonLockNow.alpha = 0.5
                    flexiCell.imageDummyBar.isHidden = false
                    flexiCell.labelDummyBarVal.isHidden = false
                    flexiCell.imageDummyBar.image = MyModel().getImageForRange(range: Int(range),
                                                                               rangeMaxValue: Int(abs(rangeMin - rangeMax)))
                    flexiCell.labelDummyBarVal.text = "\(Int(range))"
                    flexiCell.isGameStart = false
                }
                return flexiCell
            }
        } else {
            //TODO: FIX
            let arrSloats = arrSelectedTicket[indexPath.row]["slotes"] as! [[String: Any]]
            
            if arrSloats.count == 3 {
                
                let isLock = arrSelectedTicket[indexPath.row]["isLock"] as? Bool ?? false
                
                if isLock && isGameStart {
     
                                    
                    

                    let fixCell = tableView.dequeueReusableCell(withIdentifier: "GameAnswerOneTVC") as! GameAnswerOneTVC
                    
                    let strAmount = "\(arrSelectedTicket[indexPath.row]["amount"]!)"
                    //fixCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
                    let test = Double(strAmount) ?? 0.00
                    fixCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                    
//                    let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
//                    fixCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                    fixCell.labelTotalTickets.text = "\(AnyTimedictContest[indexPath.row]["no_of_players"]!)"
                    let strWinnings = "\(arrSelectedTicket[indexPath.row]["totalWinnings"]!)"
                    fixCell.labelTotalWinnig.text = "\(MyModel().getCurrncy(value: Double(strWinnings)!))"
                    let strWinners = "\(arrSelectedTicket[indexPath.row]["maxWinners"]!)"
                    fixCell.labelMaxWinners.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
                    
                    fixCell.labelAnsMinus.text = arrSloats[0]["displayValue"] as? String ?? "-"
                    fixCell.labelAnsZero.text = arrSloats[1]["displayValue"] as? String ?? "0"
                    fixCell.labelAnsPlus.text = arrSloats[2]["displayValue"] as? String ?? "+"
                    
                    let string1 = arrSloats[0]["displayValue"] as? String ?? "-"
                                   let string2 = arrSloats[2]["displayValue"] as? String ?? "-"
                                   
                                   if string1.localizedCaseInsensitiveContains("red win")
                                   {
                                     fixCell.vwWithradius.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
                                      // fixCell.viewRange.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
                                       fixCell.buttonAnsMinus.backgroundColor = UIColor.red
                                       fixCell.labelAnsMinus.textColor = UIColor.white
                                       
                                   }
                                   if string2.localizedCaseInsensitiveContains("blue win")
                                   {
                                       fixCell.buttonAnsPlus.backgroundColor = #colorLiteral(red: 0.01085097995, green: 0.3226040006, blue: 1, alpha: 1)
                                       fixCell.labelAnsPlus.textColor = UIColor.white
                                   }
                    
//                  labelAnsMinus.text = arrSloats[0]["displayValue"] as? String ?? "-"
//                  labelAnsZero.text = arrSloats[1]["displayValue"] as? String ?? "0"
//                  labelAnsPlus.text = arrSloats[2]["displayValue"] as? String ?? "+"
                    
                    fixCell.labelLoackTime.text = "Locked at:\(arrSelectedTicket[indexPath.row]["lockTime"] as? String ?? "--")"
                    //Selection
                    let arrSloatsCheck = arrSelectedTicket[indexPath.row]["slotes"] as! [[String: Any]]
                    let isSelectedMinus = arrSloatsCheck[0]["isSelected"] as? Bool ?? false
                    
                    if isSelectedMinus {
                        fixCell.buttonAnsMinus.backgroundColor = UIColor.white
                        fixCell.labelAnsMinus.textColor = UIColor.black
                    } else {
                        
                      //  fixCell.buttonAnsMinus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        
                        fixCell.buttonAnsMinus.backgroundColor = UIColor.red
                        fixCell.labelAnsMinus.textColor = UIColor.white
                    }
                    
                    let isSelectedZero = arrSloatsCheck[1]["isSelected"] as? Bool ?? false
                    if isSelectedZero {
                        fixCell.buttonAnsZero.backgroundColor = UIColor.white
                        fixCell.labelAnsZero.textColor = UIColor.black
                    } else {
                        fixCell.buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        fixCell.labelAnsZero.textColor = UIColor.white
                    }
                    
                    let isSelectedPlus = arrSloatsCheck[2]["isSelected"] as? Bool ?? false
                    if isSelectedPlus {
                        fixCell.buttonAnsPlus.backgroundColor = UIColor.white
                        fixCell.labelAnsPlus.textColor = UIColor.black
                    } else {
                       // fixCell.buttonAnsPlus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        fixCell.buttonAnsPlus.backgroundColor = #colorLiteral(red: 0.01085097995, green: 0.3226040006, blue: 1, alpha: 1)
                        fixCell.labelAnsPlus.textColor = UIColor.white
                        
                    }
                    
                    if isSelectedMinus {
                        fixCell.labelAnsLoacked.text = arrSloats[0]["displayValue"] as? String ?? "-"
                        
                    } else if isSelectedZero {
                        
                        fixCell.labelAnsLoacked.text = arrSloats[1]["displayValue"] as? String ?? "0"
                    } else if isSelectedPlus {
                        fixCell.labelAnsPlus.textColor = UIColor.black
                        fixCell.labelAnsLoacked.text = arrSloats[2]["displayValue"] as? String ?? "+"
                    } else {
                        fixCell.labelAnsLoacked.text = "Empty"
                    }
                    
                    let strSelected = arrSelectedTicket[indexPath.row]["displayValue"] as? String ?? ""
                                                         if strSelected != "" {
                                                           fixCell.labelAnsLoacked.text = strSelected
                                                         }
                    
                  
                    
                    
                    return fixCell
                } else {
                    let fixCell = tableView.dequeueReusableCell(withIdentifier: "GameAnswerTwoTVC") as! GameAnswerTwoTVC
                    
                    let strAmount = "\(arrSelectedTicket[indexPath.row]["amount"]!)"
                    //fixCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
                    let test = Double(strAmount) ?? 0.00
                    fixCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                    
                    
//                    let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
//                    fixCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                    fixCell.labelTotalTickets.text = "\(AnyTimedictContest[indexPath.row]["no_of_players"]!)"
                    let strWinnings = "\(arrSelectedTicket[indexPath.row]["totalWinnings"]!)"
                    fixCell.labelTotalWinnig.text = "\(MyModel().getCurrncy(value: Double(strWinnings)!))"
                    let strWinners = "\(arrSelectedTicket[indexPath.row]["maxWinners"]!)"
                    fixCell.labelMaxWinners.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
                    
                    fixCell.labelAnsMinus.text = arrSloats[0]["displayValue"] as? String ?? "-"
                    fixCell.labelAnsZero.text = arrSloats[1]["displayValue"] as? String ?? "0"
                    fixCell.labelAnsPlus.text = arrSloats[2]["displayValue"] as? String ?? "+"
                    
                    
                    let string1 = arrSloats[0]["displayValue"] as? String ?? "-"
                    let string2 = arrSloats[2]["displayValue"] as? String ?? "-"
                                                      
                    if string1.localizedCaseInsensitiveContains("red win")
                                                      {
                                                        
                        fixCell.vwWithradius.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
                                                         // fixCell.viewRange.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
                        fixCell.buttonAnsMinus.backgroundColor = UIColor.red
                        fixCell.labelAnsMinus.textColor = UIColor.black
                                                          
                                                      }
            if string2.localizedCaseInsensitiveContains("blue win")
            
            
            {
                                                    
            fixCell.buttonAnsPlus.backgroundColor = #colorLiteral(red: 0.01085097995, green: 0.3226040006, blue: 1, alpha: 1)
            fixCell.labelAnsPlus.textColor = UIColor.black
            
                
            }
                                       
//                    labelAnsMinus.text = arrSloats[0]["displayValue"] as? String ?? "-"
//                    labelAnsZero.text = arrSloats[1]["displayValue"] as? String ?? "0"
//                    labelAnsPlus.text = arrSloats[2]["displayValue"] as? String ?? "+"
                    
                    //Selection
                    let arrSloatsCheck = arrSelectedTicket[indexPath.row]["slotes"] as! [[String: Any]]
                    let isSelectedMinus = arrSloatsCheck[0]["isSelected"] as? Bool ?? false
                    
                    if isSelectedMinus {
                        fixCell.buttonAnsMinus.backgroundColor = UIColor.white
                        fixCell.labelAnsMinus.textColor = UIColor.black
                    } else {
                       // fixCell.buttonAnsMinus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        
                        fixCell.buttonAnsMinus.backgroundColor = UIColor.red
                        fixCell.labelAnsMinus.textColor = UIColor.white
                        
                    }
                    
                    
                    let isSelectedZero = arrSloatsCheck[1]["isSelected"] as? Bool ?? false
                    if isSelectedZero {
                        fixCell.buttonAnsZero.backgroundColor = UIColor.white
                        fixCell.labelAnsZero.textColor = UIColor.black
                    } else {
                        fixCell.buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        fixCell.labelAnsZero.textColor = UIColor.white
                    }
                    
                    let isSelectedPlus = arrSloatsCheck[2]["isSelected"] as? Bool ?? false
                    if isSelectedPlus {
                        fixCell.buttonAnsPlus.backgroundColor = UIColor.white
                        fixCell.labelAnsPlus.textColor = UIColor.black
                    } else {
                   //     fixCell.buttonAnsPlus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        
                        fixCell.buttonAnsPlus.backgroundColor = #colorLiteral(red: 0.01085097995, green: 0.3226040006, blue: 1, alpha: 1)
                        fixCell.labelAnsPlus.textColor = UIColor.white
                        
                    }
                    
                    if isSelectedMinus {
                        fixCell.labelAnsSelected.text = arrSloats[0]["displayValue"] as? String ?? "-"
                    } else if isSelectedZero {
                        fixCell.labelAnsSelected.text = arrSloats[1]["displayValue"] as? String ?? "0"
                    } else if isSelectedPlus {
                        fixCell.labelAnsSelected.text = arrSloats[2]["displayValue"] as? String ?? "+"
                    } else {
                        fixCell.labelAnsSelected.text = "Empty"
                    }
                    
                    let strSelected = arrSelectedTicket[indexPath.row]["displayValue"] as? String ?? ""
                                      if strSelected != "" {
                                        fixCell.labelAnsSelected.text = strSelected
                                      }
                    
                    if isGameStart && second <= 30 {
                        fixCell.buttonAnsMinus.addTarget(self,
                                                         action: #selector(buttonAnswerOne(_:)),
                                                         for: .touchUpInside)
                        fixCell.buttonAnsMinus.tag = indexPath.row
                        fixCell.buttonAnsZero.addTarget(self,
                                                        action: #selector(buttonAnswerTwo(_:)),
                                                        for: .touchUpInside)
                        fixCell.buttonAnsZero.tag = indexPath.row
                        fixCell.buttonAnsPlus.addTarget(self,
                                                        action: #selector(buttonAnswerThree(_:)),
                                                        for: .touchUpInside)
                        fixCell.buttonAnsPlus.tag = indexPath.row
                        fixCell.buttonLockNow.isEnabled = true
                        fixCell.buttonLockNow.alpha = 1
                    
                      
                        fixCell.buttonLockNow.addTarget(self,
                                                        action: #selector(buttonLockNow(_:)),
                                                        for: .touchUpInside)
                        fixCell.buttonLockNow.tag = indexPath.row
                        
                    } else {
                        
                        fixCell.buttonLockNow.isEnabled = false
                        fixCell.buttonLockNow.alpha = 0.5
                
                        
                      
                        

                        
                        fixCell.buttonAnsPlus.backgroundColor = UIColor.lightGray
                        fixCell.buttonAnsMinus.backgroundColor = UIColor.lightGray
                        fixCell.buttonAnsZero.backgroundColor = UIColor.lightGray
                    }
                    return fixCell
                }
            } else {
                
                let isLock = arrSelectedTicket[indexPath.row]["isLock"] as? Bool ?? false
                if isLock {
                    //
           
                  
                    

                    //
                    let fixCell = tableView.dequeueReusableCell(withIdentifier: "GameAnswerThreeLockTVC") as! GameAnswerThreeLockTVC
                    
                    let strAmount = "\(arrSelectedTicket[indexPath.row]["amount"]!)"
                    //fixCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
                    let test = Double(strAmount) ?? 0.00
                    fixCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                    
                    
//                    let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
//                    fixCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                    fixCell.labelTotalTickets.text = "\(AnyTimedictContest[indexPath.row]["no_of_players"]!)"
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
                            fixCell.labelAnsSelected.text = item["displayValue"] as? String ?? "0"
                            
                        }
                    }
                    
                    let strSelected = arrSelectedTicket[indexPath.row]["displayValue"] as? String ?? ""
                    if strSelected != "" {
                      fixCell.labelAnsSelected.text = strSelected
                    }
                    
                    
                    return fixCell
                } else {
                   
                    let fixCell = tableView.dequeueReusableCell(withIdentifier: "GameAnswerThreeTVC",  for: indexPath) as! GameAnswerThreeTVC
                    
                    fixCell.delegate = self
                    let strAmount = "\(arrSelectedTicket[indexPath.row]["amount"]!)"
                    //fixCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
                    let test = Double(strAmount) ?? 0.00
                    fixCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                    
                    
                    
//                    let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
//                    fixCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                    fixCell.labelTotalTickets.text = "\(AnyTimedictContest[indexPath.row]["no_of_players"]!)"
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
        }
    }
    
    //MARK: - TableView Button Method
    //Three Option Answer
    @objc func buttonAnswerOne(_ sender: UIButton) {
        let index = sender.tag
        var dictTicket = arrSelectedTicket[index]
        var arrSloats = dictTicket["slotes"] as! [[String: Any]]
        for (indexNo,_) in arrSloats.enumerated() {
            if indexNo == 0 {
                arrSloats[indexNo]["isSelected"] = NSNumber(value: true)
            } else {
                arrSloats[indexNo]["isSelected"] = NSNumber(value: false)
            }
        }
      //  print("Data: \(arrSloats)")
        dictTicket["slotes"] = arrSloats
        
        arrSelectedTicket[index] = dictTicket
        let indexPath = IndexPath(row: index, section: 0)
        tableAnswer.reloadRows(at: [indexPath], with: .none)
    }
    @objc func buttonAnswerTwo(_ sender: UIButton) {
        let index = sender.tag
        var dictTicket = arrSelectedTicket[index]
        var arrSloats = dictTicket["slotes"] as! [[String: Any]]
        for (indexNo,_) in arrSloats.enumerated() {
            
            if indexNo == 1 {
                arrSloats[indexNo]["isSelected"] = NSNumber(value: true)
            } else {
                arrSloats[indexNo]["isSelected"] = NSNumber(value: false)
            }
        }
       // print("Data: \(arrSloats)")
        dictTicket["slotes"] = arrSloats
        
        arrSelectedTicket[index] = dictTicket
        let indexPath = IndexPath(row: index, section: 0)
        tableAnswer.reloadRows(at: [indexPath], with: .none)
    }
    @objc func buttonAnswerThree(_ sender: UIButton) {
        let index = sender.tag
        var dictTicket = arrSelectedTicket[index]
        var arrSloats = dictTicket["slotes"] as! [[String: Any]]
        for (indexNo,_) in arrSloats.enumerated() {
            if indexNo == 2 {
                arrSloats[indexNo]["isSelected"] = NSNumber(value: true)
            } else {
                arrSloats[indexNo]["isSelected"] = NSNumber(value: false)
            }
        }
     //   print("Data: \(arrSloats)")
        dictTicket["slotes"] = arrSloats
        
        arrSelectedTicket[index] = dictTicket
        let indexPath = IndexPath(row: index, section: 0)
        tableAnswer.reloadRows(at: [indexPath], with: .none)
    }
    
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
               // print("AnytimeUpdateGame: \(data)")
                
                guard let strValue = data[0] as? String else {
                    Alert().showAlert(title: "Alert",
                                      message: Define.ERROR_SERVER,
                                      viewController: self)
                    return
                }
                
                let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
                let dictData = MyModel().convertToDictionary(text: strJSON)
                print("AnytimeUpdateGame:",dictData!)
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
    
    @objc func buttonRangeAnsLock(_ sender: UIButton) {
        let index = sender.tag
        
        let indexPath = IndexPath(row: index, section: 0)
        let cell = tableAnswer.cellForRow(at: indexPath) as! GameAnsRangeTVC
        
        var startValue: Int?
        var endValue: Int?
        var strDisplayValue: String?
        
        startValue = Int(round(cell.rangeMin))
        endValue = Int(round(cell.rangeMax))
        strDisplayValue = "(\(startValue!) To \(endValue!))"
        
        if startValue == 0 && endValue == 0 {
            //Alert().showTost(message: "Select Answer range", viewController: self)
        } else {
            let parameter:[String: Any] = ["userId": Define.USERDEFAULT.value(forKey: "UserID")!, "contestId": dictContest["id"]!,"contestPriceId": arrSelectedTicket[index]["contestpriceID"]!,
                                           "startValue": startValue!,
                                           "endValue": endValue!,
                                           "isLock": 1,
                                           "position": index,
                                           "displayValue": strDisplayValue!,
                                           "lockAll" : ""
            ]
            print("Parameter: \(parameter)")
            
            let jsonString = MyModel().getJSONString(object: parameter)
            let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
            let strBase64 = encriptString.toBase64()
            cell.buttonLockNow.isEnabled = false
            SocketIOManager.sharedInstance.socket.emitWithAck("updateGame", strBase64!).timingOut(after: 0) { (data) in
              //  print("Data: \(data)")
                
                guard let strValue = data[0] as? String else {
                    Alert().showAlert(title: "Alert",
                                      message: Define.ERROR_SERVER,
                                      viewController: self)
                    return
                }
                
                
                let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
                let dictData = MyModel().convertToDictionary(text: strJSON)
                
                let status = dictData!["statusCode"] as? Int ?? 0
                if status == 200 {
                    var dictItemData = dictData!["content"] as! [String: Any]
                    var dictTicket = self.arrSelectedTicket[index]
                    dictTicket["isLock"] = dictItemData["isLock"]
                    dictTicket["lockTime"] = dictItemData["isLockTime"]
                    dictTicket["startValue"] = dictItemData["startValue"]
                    dictTicket["endValue"] = dictItemData["endValue"]
                    dictTicket["displayValue"] = dictItemData["displayValue"]
                    let userSelectedData = ["startValue": dictItemData["startValue"]!,
                                            "endValue": dictItemData["endValue"]!]
                    dictTicket["user_select"] = userSelectedData
                    self.arrSelectedTicket[index] = dictTicket
                    //let indexPath = IndexPath(row: index, section: 0)
                    //self.tableAnswer.reloadRows(at: [indexPath], with: .none)
                    
                    cell.viewUnLocked.isHidden = true
                    cell.viewLocked.isHidden = false
                    cell.labelLockedAnswer.text = "\(dictItemData["startValue"]!) to \(dictItemData["endValue"]!)"
                    cell.labelLockedAt.text = "locked at: \(dictTicket["lockTime"] as? String ?? "--")"
                    cell.sliderAnswer.isUserInteractionEnabled = false
                }
            }
        }
    }
}

//MARK: - AnswerCell Delegate Method
extension NewCGGamePlayVC: GameAnswerThreeDelegate, GameAnsRangeDelegate {
    
    func getRanges(_ sender: GameAnsRangeTVC, minRange: Int, maxRange: Int, selectedRange: Int) {
        guard let index = tableAnswer.indexPath(for: sender) else {
            return
        }
        print("Index: \(index.row)")
        
        var dictData = arrSelectedTicket[index.row]
        dictData["selectedValue"] = Float(selectedRange)
        arrSelectedTicket[index.row] = dictData
        
        let indexPath = IndexPath(row: index.row, section: 0)
        let cell = tableAnswer.cellForRow(at: indexPath) as! GameAnsRangeTVC
        
        cell.labelAnsSelected.text = "\(minRange) to \(maxRange)"
    }
    
    
    func getSloatData(_ sender: GameAnswerThreeTVC, arrData: [[String : Any]]) {
        guard let index = tableAnswer.indexPath(for: sender) else {
            return
        }
       // print("Index: \(index.row)")
        
        
        var dictTicket = arrSelectedTicket[index.row]
        
        dictTicket["slotes"] = arrData
        
        arrSelectedTicket[index.row] = dictTicket
        
        let indexPath = IndexPath(row: index.row, section: 0)
        let cell = tableAnswer.cellForRow(at: indexPath) as! GameAnswerThreeTVC
        
        for item in arrData {
            let isSelected = item["isSelected"] as? Bool ?? false
            if isSelected {
                
                cell.labelAnsSelected.text = item["displayValue"] as? String ?? "0"
            }
        }
    }
}

//MARK: - Alert Controller
extension NewCGGamePlayVC {
//    func contestError() {
//        let alertController = UIAlertController(title: "Contes", message: , preferredStyle: )
//
//    }
}
