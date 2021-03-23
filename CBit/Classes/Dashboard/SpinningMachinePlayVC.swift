//
//  SpinningMachinePlayVC.swift
//  CBit
//
//  Created by Nirmal Bodar on 12/02/21.
//  Copyright © 2021 Bhavik Kothari. All rights reserved.
//

import UIKit
import AVFoundation
import SocketIO

class SpinningMachinePlayVC: UIViewController,URLSessionDelegate, URLSessionDataDelegate {
    
    @IBOutlet weak var imgminus: UIImageView!
    @IBOutlet weak var imgzero: UIImageView!
    @IBOutlet weak var imgplus: UIImageView!
    
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
   // var StartSecond = 30
    var storeimage = [[String:Any]]()
    
    @IBOutlet weak var btnlock: UIImageView!
    
//    @IBOutlet weak var imglock09: UIImageView!
//    @IBOutlet weak var btnzero: UIButton!
//
//    @IBOutlet weak var btnonee: UIButton!
//
//    @IBOutlet weak var btntwo: UIButton!
//
//    @IBOutlet weak var btnthree: UIButton!
//
//    @IBOutlet weak var btnfour: UIButton!
//
//    @IBOutlet weak var btnfive: UIButton!
//
//    @IBOutlet weak var btnsix: UIButton!
//
//
//    @IBOutlet weak var btnseven: UIButton!
//
//    @IBOutlet weak var btneeight: UIButton!
//
//
//    @IBOutlet weak var btnnine: UIButton!
    
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
    @IBOutlet weak var imgselected: UIImageView!
    
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
    var second = Int()
    var msecond:Int = 999
    
    var endGameTimer: Timer?
    var endGameSecond = 20
    
    var startTimer: Timer?
    var startSecond = Int()
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
            // collheight.constant = (view.frame.width-20) /* 5*5 */
           // constrainCollectionViewHeight.constant = (view.frame.width) - width  /* 5*4 */
           // constrainCollectionViewHeight.constant = (view.frame.width) - (width*2) /* 5*3 */
        }
        
         gamelevel = dictContest["rows"] as? Int ?? 0
      
            if gamelevel == 3 {
                // constraintCollectionViewHeight.constant = (view.frame.width-20) /* 5*5 */
             //   constraintCollectionViewHeight.constant = (view.frame.width-20) - width  /* 5*4 */
                constrainCollectionViewHeight.constant = (view.frame.width) - (width*2) - 30 /* 5*3 */
            } else if gamelevel == 4 {
                // constraintCollectionViewHeight.constant = (view.frame.width-20) /* 5*5 */
                constrainCollectionViewHeight.constant = (view.frame.width) - width - 40 /* 5*4 */
               //  constraintCollectionViewHeight.constant = (view.frame.width) - (width*2) /* 5*3 */
            } else if gamelevel == 5 {
                constrainCollectionViewHeight.constant = (view.frame.width) - 50 /* 5*5 */
             //   constraintCollectionViewHeight.constant = (view.frame.width-20) - width  /* 5*4 */
               //  constraintCollectionViewHeight.constant = (view.frame.width) - (width*2) /* 5*3 */
            }

        
        //collection_slot.semanticContentAttribute = .forceRightToLeft
        storeimage = Define.Globalimagearr
        for _ in 1..<80
        {
            for dict in storeimage {
                itemarr.append(loadImageFromDocumentDirectory(nameOfImage: dict["name"] as! String))
            }

        }
        
        
        

        
//        for _ in 1..<10 {
//            originalarr.append(UIImage(named: "bananas")!)
//            originalarr.append(UIImage(named: "cherry")!)
//            originalarr.append(UIImage(named: "mango")!)
//            originalarr.append(UIImage(named: "strawberry")!)
//            originalarr.append(UIImage(named: "apple")!)
//            originalarr.append(UIImage(named: "bananas")!)
//            originalarr.append(UIImage(named: "cherry")!)
//        }
        
       slotarr = itemarr
        
        
        
        
        
        
        tableAnswer.rowHeight = UITableView.automaticDimension
        tableAnswer.tableFooterView = UIView()
        

        
        if !isFromNotification {
            
            gamelevel = dictContest["level"] as? Int ?? 1
            let date = dictContest["startDate"] as! String
            let startDate = MyModel().converStringToDate(strDate: date, getFormate: "yyyy-MM-dd HH:mm:ss")
            let calender = Calendar.current
            let unitFlags = Set<Calendar.Component>([ .second])
            let dateComponent = calender.dateComponents(unitFlags, from: Date(), to: startDate)
            
            if dateComponent.second! < 0
            {
                
                startSecond = 0
                
            } else {
                
                startSecond = dateComponent.second!
                
            }
            
            
        }
        

        
        NotificationCenter.default.addObserver(self,
                                                      selector: #selector(handleNotificationEnterPage(_:)),
                                                      name: .EnterGamePage,
                                                      object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: .startGame,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleEndGameNotication(_:)),
                                               name: .endGame,
                                               object: nil)
        let path = Bundle.main.path(forResource: "Tick Tock.mp3", ofType: nil)!
        soundURL = URL(fileURLWithPath: path)
        
        
        isShowLoading = true
        getContestDetail(isfromtimer: true, isStart: 0)
        
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
      //  configAutoscrollTimer()
      //  configFadeTimer()
     //   configStartTimer()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deconfigAutoscrollTimer()
        deconfigFadeTimer()
      //  startTimer?.invalidate()
    }
    
    func configAutoscrollTimer()
    {
        
        timerautoscroll=Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(SpinningMachinePlayVC.autoScrollView), userInfo: nil, repeats: true)
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
        print("LOADSPPED",LoadSpeed)
        print("LessSpeed",LessSpeed)
        print("SPPED",speed)
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
            labelTimer.text = "Game starts in \(timeString(time: TimeInterval(startSecond)))"
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
    
    
//    @IBAction func btn_nopressed(_ sender: UIButton) {
//       
//        if sender.tag == 0
//        {
//            strDisplayValuelockall = "0"
//             btnzero.backgroundColor = UIColor.white
//             btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//             btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//             btnthree.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//             btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//             btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//             btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//             btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//             btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//             btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            
//        }
//       
//        else if sender.tag == 1
//        {
//            
//            strDisplayValuelockall = "1"
//          
//            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnonee.backgroundColor = UIColor.white
//            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//        
//        }
//        
//        else if sender.tag == 2
//        {
//            strDisplayValuelockall = "2"
//        
//            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btntwo.backgroundColor = UIColor.white
//            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//        }
//       
//        else if sender.tag == 3
//        {
//            strDisplayValuelockall = "3"
//            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnthree.backgroundColor = UIColor.white
//            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            
//        }
//        else if sender.tag == 4
//        {
//            strDisplayValuelockall = "4"
//            
//            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfour.backgroundColor = UIColor.white
//            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//
//        }
//       
//        else if sender.tag == 5
//        {
//            strDisplayValuelockall = "5"
//            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfive.backgroundColor = UIColor.white
//            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//        
//        }
//       
//        else if sender.tag == 6
//        {
//            strDisplayValuelockall = "6"
//            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnsix.backgroundColor = UIColor.white
//            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//        }
//        
//        else if sender.tag == 7
//        {
//            strDisplayValuelockall = "7"
//            
//            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnseven.backgroundColor = UIColor.white
//            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//        }
//        else if sender.tag == 8
//        {
//            strDisplayValuelockall = "8"
//            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btneeight.backgroundColor = UIColor.white
//            btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//        }
//        else if sender.tag == 9
//        {
//           
//            strDisplayValuelockall = "9"
//            btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//            btnnine.backgroundColor = UIColor.white
//            
//        }
//        lblnumberanswerselected.text! = strDisplayValuelockall ?? ""
//    }
    
    @IBAction func btn_lockall(_ sender: Any) {
        

        print("selection",strDisplayValuelockall)
        if strDisplayValuelockall == nil
        {
           
        }
        else{
            locakall()
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
         //  imglock09.isHidden = false
        
//           btnlockallnumber.isEnabled = false
//           btnlockallnumber.alpha = 0.5
        
           buttonAnsMinus.isEnabled = false
           buttonAnsPlus.isEnabled = false
           buttonAnsZero.isEnabled = false
        
//           btnonee.isEnabled = false
//           btntwo.isEnabled = false
//           btnthree.isEnabled = false
//           btnfour.isEnabled = false
//           btnfive.isEnabled = false
//           btnsix.isEnabled = false
//           btnseven.isEnabled = false
//           btneeight.isEnabled = false
//           btnnine.isEnabled = false
//           btnzero.isEnabled = false

           
        
               let parameter:[String: Any] = ["userId": Define.USERDEFAULT.value(forKey: "UserID")!,
                                              "contestId": dictContest["id"]!,
                                              "DisplayValue":strDisplayValuelockall ?? ""
                                              
               ]
        
        
               print("Parameter: \(parameter)")
               
               let jsonString = MyModel().getJSONString(object: parameter)
               let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
               let strBase64 = encriptString.toBase64()
             //  cell.buttonLockNow.isEnabled = false
               SocketIOManager.sharedInstance.socket.emitWithAck("updateGameAll", strBase64!).timingOut(after: 0) { (data) in
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
                       
                       var dictItemData1 = dictData!["content"] as! [[String: Any]]
                       print(dictItemData1)
                       
                       var i = 0
                       
                       for i in i..<self.arrSelectedTicket.count {
                           
                       var dictItemData = dictItemData1[i]
                       var dictTicket = self.arrSelectedTicket[i]
                       dictTicket["isLock"] = dictItemData["isLockAll"]
                       dictTicket["displayValue"] = dictItemData["DisplayValue"]
                    //   dictTicket["lockTime"] = dictItemData["isLockTime"]
                        dictTicket["lockTime"] = dictItemData["lockTime"]
                       self.arrSelectedTicket[i] = dictTicket
                       
//                       let indexPath = IndexPath(row:i, section: 0)
//                       self.tableAnswer.reloadRows(at: [indexPath], with: .none)
                        self.tableAnswer.reloadData()
                        self.getContestDetail(isfromtimer: true, isStart: 0)
                       }
                   }
               }
        
        
    }
    
    @IBAction func btnAnsMinus(_ sender: Any) {
        
        buttonAnsMinus.layer.borderColor = UIColor.black.cgColor
        buttonAnsMinus.layer.borderWidth = 2
        
        buttonAnsPlus.layer.borderWidth = 0
        buttonAnsZero.layer.borderWidth = 0
        
        
        let arrSloats = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
        
      // labelanswerselected.text! = arrSloats[0]["displayValue"] as? String ?? "-"
        //labelanswerselected.text! = labelAnsMinus.text ?? ""

        
        strDisplayValuelockall = arrSloats[0]["displayValue"] as? String ?? ""
        if strDisplayValuelockall == "Draw" {
            labelanswerselected.isHidden = false
            imgselected.isHidden = true
            labelanswerselected.text = strDisplayValuelockall
        }
        else
        {
            labelanswerselected.isHidden = true
            imgselected.isHidden = false
            imgselected.image = loadImageFromDocumentDirectory(nameOfImage: strDisplayValuelockall ?? "").imageByMakingWhiteBackgroundTransparent()
        }
        
        
    }
    
    
    @IBAction func btnAnsZero(_ sender: Any) {
        
        buttonAnsZero.layer.borderColor = UIColor.black.cgColor
        buttonAnsZero.layer.borderWidth = 2
        
        buttonAnsPlus.layer.borderWidth = 0
        buttonAnsMinus.layer.borderWidth = 0
        
        
        let arrSloats = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
      //  labelanswerselected.text! = arrSloats[1]["displayValue"] as? String ?? "0"
        
       // labelanswerselected.text! = labelAnsZero.text ?? ""
        

         strDisplayValuelockall = arrSloats[1]["displayValue"] as? String ?? ""
        if strDisplayValuelockall == "Draw" {
            labelanswerselected.isHidden = false
            imgselected.isHidden = true
            labelanswerselected.text = strDisplayValuelockall
        }
        else
        {
            labelanswerselected.isHidden = true
            imgselected.isHidden = false
            imgselected.image = loadImageFromDocumentDirectory(nameOfImage: strDisplayValuelockall ?? "").imageByMakingWhiteBackgroundTransparent()
        }

    }
    
    @IBAction func btnAnsPlua(_ sender: Any) {
        
        buttonAnsPlus.layer.borderColor = UIColor.black.cgColor
        buttonAnsPlus.layer.borderWidth = 2
        
        buttonAnsZero.layer.borderWidth = 0
        buttonAnsMinus.layer.borderWidth = 0
         
          let arrSloats = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
        // labelanswerselected.text = arrSloats[2]["displayValue"] as? String ?? "+"
        //  labelanswerselected.text! = labelAnsPlus.text ?? ""

         strDisplayValuelockall = arrSloats[2]["displayValue"] as? String ?? ""
        if strDisplayValuelockall == "Draw" {
            labelanswerselected.isHidden = false
            imgselected.isHidden = true
            labelanswerselected.text = strDisplayValuelockall
        }
        else
        {
            labelanswerselected.isHidden = true
            imgselected.isHidden = false
            imgselected.image = loadImageFromDocumentDirectory(nameOfImage: strDisplayValuelockall ?? "").imageByMakingWhiteBackgroundTransparent()
        }

    }
    
    override func viewWillLayoutSubviews() {
        
        viewTimmer.layer.cornerRadius = 15
        viewTimmer.layer.masksToBounds = true
        
        labelContestName.text = dictContest["name"] as? String ?? "No Name"
        
        
    }
    
     var socket: SocketIOClient!
    
    func startlistner() {
        //TODO: Game Start
               socket.on("onContestLive") { (data, ack) in
                   print("➤ On Contest Start")
                   print("Data: \(data)")
                   let strValue = data[0] as! String
                   
                   let strJSON = MyModel().decrypting(strData: strValue, strKey: Define.KEY)
                   let dictData = MyModel().convertToDictionary(text: strJSON)
                   
                  
                                          
                                          print("Game Data: \(String(describing: dictData))")

                                                     self.dictGameData = dictData!["content"] as! [String: Any]
                                                     print(self.dictGameData)

                                                     self.gametype  = self.dictContest["game_type"] as! String
                                                     if self.gametype == "spinning-machine" {
                                                         self.viewrdb.isHidden = false
                                                      //   self.buttonAnsMinus.backgroundColor = UIColor.red

                                                     }
                                                     else
                                                     {
                                                        // self.view0to9.isHidden = false
                                                     }
                                                     let serverDate = self.dictGameData["currentTime"] as? String ?? "\(MyModel().convertDateToString(date: Date(), returnFormate: "yyyy-MM-dd HH:mm:ss"))"
                                                     self.currentDate = MyModel().converStringToDate(strDate: serverDate, getFormate: "yyyy-MM-dd HH:mm:ss")

                                                     print("➤ \(self.dictGameData)")
                                          

                                          
                                          self.setnewData()
                                       
                                          
                                                     Loading().hideLoading(viewController: self)
                                        
               }
    }
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

                self.labelTimer.text = "\(gameTime)"
        
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

                                    
//                                  btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                  btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                  btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                  btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                  btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                  btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                  btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                  btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                  btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                  btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                    
//                            btnlockallnumber.isEnabled = true
//                            btnlockallnumber.alpha = 1.0
                           
//                              btnonee.isEnabled = true
//                              btntwo.isEnabled = true
//                              btnthree.isEnabled = true
//                              btnfour.isEnabled = true
//                              btnfive.isEnabled = true
//                              btnsix.isEnabled = true
//                              btnseven.isEnabled = true
//                              btneeight.isEnabled = true
//                              btnnine.isEnabled = true
//                              btnzero.isEnabled = true
                    
                                        btnlockall.alpha = 1.0
                                           btnlockall.isEnabled = true
                                           btnlockall.isHidden = false
                                           btnlock.isHidden = true
                                           lbllockedat.isHidden = true
                                           buttonAnsMinus.isEnabled = true
                                           buttonAnsPlus.isEnabled = true
                                           buttonAnsZero.isEnabled = true
                    self.getContestDetail(isfromtimer: true, isStart: 0)
                }
                
            
                
            } else if gameStatus == "gameEnd" {
                
                NotificationCenter.default.removeObserver(self)
                SocketIOManager.sharedInstance.lastViewController = nil
                let SMResultVC = self.storyboard?.instantiateViewController(withIdentifier: "SMResultVC") as! SMResultVC
                SMResultVC.dictContest = dictContest
                self.navigationController?.pushViewController(SMResultVC, animated: true)
                
                
            } else {
                isGameStart = false
                
                let date = dictGameData["startDate"] as! String
                let startDate = MyModel().converStringToDate(strDate: date, getFormate: "yyyy-MM-dd HH:mm:ss")
                
                let calender = Calendar.current
                let unitFlags = Set<Calendar.Component>([ .second])
                let dateComponent = calender.dateComponents(unitFlags, from: self.currentDate, to: startDate)
                startSecond = dateComponent.second! - differenceSecond
                //startSecond = MyModel().getSecound(currentTime: self.currentDate, startDate: startDate)
                print("Seconds: \(startSecond)")
                labelTimer.text = "Game starts in 00:\(time)"

               
            }

        }
    
    
    func getContestDetail(isfromtimer:Bool,isStart:Int) {
        
        if isShowLoading {
            Loading().showLoading(viewController: self)
        }
        
        
        let parameter:[String: Any] = [ "contest_id": dictContest["id"]!, "userId":Define.USERDEFAULT.value(forKey: "UserID")!,"isStart":isStart]
        print("Parameter: \(parameter)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strBase64 = encriptString.toBase64()
        let sendRequestTime = Date()
        

           
            let strURL = Define.APP_URL + Define.API_CONTEST_DETAIL

            SwiftAPI().postMethodSecure(stringURL: strURL,
                                        parameters: ["data": strBase64!],
                                        header: Define.USERDEFAULT.value(forKey: "AccessToken") as? String,
                                        auther: Define.USERDEFAULT.value(forKey: "UserID") as? String)
            { (result, error) in
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
                   

                      //  self.arrTickets = self.dictGameData["tickets"] as? [[String: Any]] ?? []
                     //   self.tableAnswer.reloadData()
                                   self.gametype  = self.dictContest["game_type"] as! String
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
            let gameMode = dictContest["type"] as? Int ?? 0
            var dictData = item
            if gameMode == 0 {
                dictData["selectedValue"] = dictGameData["ansRangeMin"] as? Float ?? 0.0
            }
            
            if isPurchased {
                arrSelectedTicket.append(dictData)
            }
        }
        

        
        print("Set Data",dictGameData)
        let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"
        second = (dictGameData["duration"] as? Int)!
        print("secondsspre",second)
        
        //
      
       // second = (dictGameData["duration"] as? Int)!
        
        let arrSloats = self.arrSelectedTicket[0]["slotes"] as! [[String: Any]]
        for _ in 1..<300
        {
            for dict in arrSloats {
                let img = loadImageFromDocumentDirectory(nameOfImage: dict["displayValue"] as! String)
                if imageIsNullOrNot(imageName: img) {
                    randomarr.append(img)
                }
                
            }
        }
        //  labelTimer.text = ""
        if (gameStatus == "notStart") && Int(self.gameTime) ?? 0 > 40{
            self.configFadeTimer()
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
   
        
        //  labelTimer.text = ""
        if (gameStatus == "start") {
           
            

            
            if self.gametype == "spinning-machine" {
                btnlockall.isEnabled = true
                                                btnlockall.alpha = 1.0
                                                buttonAnsMinus.isEnabled = true
                                                buttonAnsPlus.isEnabled = true
                                                buttonAnsZero.isEnabled = true
                          
                          
                                   let  LockAllData = dictGameData["LockAllData"] as? [[String: Any]] ?? []
                                    if LockAllData.count > 0 {
                                        let isLockAll = LockAllData[0]["isLockAll"] as? Bool ?? false
                                        
                                        if isLockAll {
                                            let displayValue = LockAllData[0]["displayValue"] as? String ?? "0"
                                             lbllockedat.text = "locked at: \(LockAllData[0]["lockAllTime"] as? String ?? "0")"
                                               btnlockall.isHidden = true
                                                btnlock.isHidden = false
                                              buttonAnsMinus.isEnabled = false
                                            buttonAnsPlus.isEnabled = false
                                            buttonAnsZero.isEnabled = false
                                            lbllockedat.isHidden = false
                                            
//                                            if displayValue == "Red win" {
//                                             //   labelanswerselected.text! = displayValue
//                                                imgselected.image = loadImageFromDocumentDirectory(nameOfImage: displayValue)
//                                                buttonAnsMinus.layer.borderColor = UIColor.black.cgColor
//                                                buttonAnsMinus.layer.borderWidth = 2
//
//                                                buttonAnsPlus.layer.borderWidth = 0
//                                                buttonAnsZero.layer.borderWidth = 0
//
//                                            }
//                                            else if displayValue == "Draw" {
//
//                                                //labelanswerselected.text! = displayValue
//                                                imgselected.image = loadImageFromDocumentDirectory(nameOfImage: displayValue)
//                                                buttonAnsZero.layer.borderColor = UIColor.black.cgColor
//                                                buttonAnsZero.layer.borderWidth = 2
//
//                                                buttonAnsPlus.layer.borderWidth = 0
//                                                buttonAnsMinus.layer.borderWidth = 0
//
//                                            }
//                                            else if displayValue == "Blue win" {
//                                               // labelanswerselected.text! = displayValue
//                                                imgselected.image = loadImageFromDocumentDirectory(nameOfImage: displayValue)
//                                                buttonAnsPlus.layer.borderColor = UIColor.black.cgColor
//                                                buttonAnsPlus.layer.borderWidth = 2
//
//                                                buttonAnsZero.layer.borderWidth = 0
//                                                buttonAnsMinus.layer.borderWidth = 0
//                                            }
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
            }

                              

            
            
        } else if gameStatus == "gameEnd" {
            NotificationCenter.default.removeObserver(self)
            SocketIOManager.sharedInstance.lastViewController = nil
            let SMResultVC = self.storyboard?.instantiateViewController(withIdentifier: "SMResultVC") as! SMResultVC
            SMResultVC.dictContest = dictContest
            self.navigationController?.pushViewController(SMResultVC, animated: true)
            
            
        } else {
          
            isGameStart = false
            
            btnlock.isHidden = true
            btnlockall.isEnabled = false
            btnlockall.alpha = 0.5
            buttonAnsMinus.isEnabled = false
            buttonAnsPlus.isEnabled = false
            buttonAnsZero.isEnabled = false
            
//                                        btnlockallnumber.isEnabled = false
//                                        btnlockallnumber.alpha = 0.5
                                     
//                                        btnonee.isEnabled = false
//                                        btntwo.isEnabled = false
//                                        btnthree.isEnabled = false
//                                        btnfour.isEnabled = false
//                                        btnfive.isEnabled = false
//                                        btnsix.isEnabled = false
//                                        btnseven.isEnabled = false
//                                        btneeight.isEnabled = false
//                                        btnnine.isEnabled = false
//                                        btnzero.isEnabled = false

            
            let date = dictGameData["startDate"] as! String
            let startDate = MyModel().converStringToDate(strDate: date, getFormate: "yyyy-MM-dd HH:mm:ss")
            
            let calender = Calendar.current
            let unitFlags = Set<Calendar.Component>([ .second])
            let dateComponent = calender.dateComponents(unitFlags, from: self.currentDate, to: startDate)
            startSecond = dateComponent.second! - differenceSecond
            //startSecond = MyModel().getSecound(currentTime: self.currentDate, startDate: startDate)
            print("Seconds: \(startSecond)")
            
            if isfromtime {
                 if startTimer == nil {
                               startSecond = startSecond - 1
                               labelTimer.text = "Game starts in \(timeString(time: TimeInterval(startSecond)))"
                               setStartTimer()
                    
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
                second = (dictdata["duration"] as? Int)!
                print("secondsspre",second)
                
           
                
                //  labelTimer.text = ""
                if (gameStatus == "start") {
                   
                    

                    
                    if self.gametype == "spinning-machine" {
                        btnlockall.isEnabled = true
                                                        btnlockall.alpha = 1.0
                                                        buttonAnsMinus.isEnabled = true
                                                        buttonAnsPlus.isEnabled = true
                                                        buttonAnsZero.isEnabled = true
                                  
                                  
                                           let  LockAllData = dictGameData["LockAllData"] as? [[String: Any]] ?? []
                                            if LockAllData.count > 0 {
                                                let isLockAll = LockAllData[0]["isLockAll"] as? Bool ?? false
                                                
                                                if isLockAll {
                                                    let displayValue = LockAllData[0]["displayValue"] as? String ?? "0"
                                                     lbllockedat.text = "locked at: \(LockAllData[0]["lockAllTime"] as? String ?? "0")"
                                                       btnlockall.isHidden = true
                                                        btnlock.isHidden = false
                                                      buttonAnsMinus.isEnabled = false
                                                    buttonAnsPlus.isEnabled = false
                                                    buttonAnsZero.isEnabled = false
                                                    lbllockedat.isHidden = false
//                                                    if displayValue == "Red win" {
//                                                       // labelanswerselected.text! = displayValue
//                                                        imgselected.image = loadImageFromDocumentDirectory(nameOfImage: displayValue)
//                                                        buttonAnsMinus.layer.borderColor = UIColor.black.cgColor
//                                                        buttonAnsMinus.layer.borderWidth = 2
//
//                                                        buttonAnsPlus.layer.borderWidth = 0
//                                                        buttonAnsZero.layer.borderWidth = 0
//                                                    }
//                                                    else if displayValue == "Draw" {
//
//                                                      //  labelanswerselected.text! = displayValue
//                                                        imgselected.image = loadImageFromDocumentDirectory(nameOfImage: displayValue)
//                                                        buttonAnsZero.layer.borderColor = UIColor.black.cgColor
//                                                        buttonAnsZero.layer.borderWidth = 2
//
//                                                        buttonAnsPlus.layer.borderWidth = 0
//                                                        buttonAnsMinus.layer.borderWidth = 0
//
//
//                                                    }
//                                                    else if displayValue == "Blue win" {
//                                                       // labelanswerselected.text! = displayValue
//                                                        imgselected.image = loadImageFromDocumentDirectory(nameOfImage: displayValue)
//                                                        buttonAnsPlus.layer.borderColor = UIColor.black.cgColor
//                                                        buttonAnsPlus.layer.borderWidth = 2
//
//                                                        buttonAnsZero.layer.borderWidth = 0
//                                                        buttonAnsMinus.layer.borderWidth = 0
//                                                    }
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
                    }
    }
    }
    

    
    var gameTime = String()
    var time = String()
    
    @objc func handleNotificationEnterPage(_ notification: Notification) {
           print("Game Start.")
           
         //  isStartEventCall = true
           if (notification.userInfo as Dictionary?) != nil {
               print("--> User Info Data: \(notification.userInfo!)")
            
            let dictData = notification.userInfo!
            gameTime = String(dictData["gameTime"] as! Int)
             time = dictData["time"] as! String
            self.dictGameData = dictData["contest"] as! [String: Any]
                                                     print(self.dictGameData)
            
            if  (Int(gameTime)! == 40 )  //&& Int(gameTime)! >= 30 &&  Int(gameTime)! >= 0{
            {
                slotarr = randomarr
                deconfigFadeTimer()
                configAutoscrollTimer()
            }
//            else if Int(gameTime)! <= 30
//                {
//
//            }
           
            let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"

            

                                                     self.gametype  = self.dictContest["game_type"] as! String
                                                     if self.gametype == "spinning-machine" {
                                                         self.viewrdb.isHidden = false

                                                     }
                                                     else
                                                     {
                                                         //self.view0to9.isHidden = false
                                                     }

            if dictContest["id"] as! Int == dictGameData["id"] as! Int {
                 self.setnewData()
            }
            
                                         
                                    
                                          
                                                     Loading().hideLoading(viewController: self)
           } else {
               
               print("--> No Data")
               isShowLoading = false

            
               


           }
       }
    
    @objc func handleNotification(_ notification: Notification) {
        print("Game Start.")
        
        isStartEventCall = true
        if (notification.userInfo as Dictionary?) != nil {
            print("--> User Info Data: \(notification.userInfo!)")
            let contestId = "\(notification.userInfo!["contestId"]!)"
            let selectedContestID = "\(dictContest["id"]!)"
            if contestId == selectedContestID {
                isShowLoading = false

          
                

            }
        } else {
            
            print("--> No Data")
            isShowLoading = false

        
            


        }
    }
    
    @objc func handleEndGameNotication(_ notification: Notification) {
        print("Gaem End")
        
        if (notification.userInfo as Dictionary?) != nil {
            
            print("--> User Info Data: \(notification.userInfo!)")
            let contestId = "\(notification.userInfo!["contestId"]!)"
            let selectedContestID = "\(dictContest["id"]!)"
            if contestId == selectedContestID {
                setEndTimer()
                
            }
        } else {
            
            print("--> No Data")
            setEndTimer()
            
        }
        
    }
    
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
        
         let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"
        
        if gameStatus == "notStart" {
             if miliSecondValue == 0 {
                        miliSecondValue = miliSecondValue + 1
                       // updateColors()
                     //   collectionGame.reloadData()
                    } else if miliSecondValue == 1 {
                        miliSecondValue = 0
                        print("STARTSECOND:",startSecond)
                        
                        if startSecond == 1 {

                            }
                    //        }
                        
                        if startSecond > 1 {
                            startSecond = startSecond - 1

                            
                            if startSecond ==  5 {
                             //   print("ENDSECOND:",endGameSecond)
                              //   DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                 
                               //                     }
                                if !self.isStartEventCall {

                                            print("If Start Event call.")
                               

                                }
                            }
                        }
                        else {
                            if startTimer != nil {
                                startTimer!.invalidate()
                                startTimer = nil
                                 labelTimer.text = ""
    
                               
                            }

                        }
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
        if second > 0 {

            
            self.labelTimer.text = String(format: "%02i", self.second)
            //print(labelTimer.text!)
            second = second - 1
            msecond = 999
            
            
        } else {
            //print("Timer Not Start")
            if timer != nil {
                self.labelTimer.text = "00"
                timer!.invalidate()
                timer = nil
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
                let SMResultVC = self.storyboard?.instantiateViewController(withIdentifier: "SMResultVC") as! SMResultVC
                SMResultVC.dictContest = dictContest
                self.navigationController?.pushViewController(SMResultVC, animated: true)
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
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonInfo(_ sender: Any) {
        let gameInfo = GamePlayInfo.instanceFromNib() as! GamePlayInfo
        gameInfo.frame = view.bounds
        view.addSubview(gameInfo)
    }
}


//MARK: - Collection View Delegate Method
extension SpinningMachinePlayVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collection_slot {
            return slotarr.count
        }
        if collectionView == collection_original {
            return originalarr.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotcell", for: indexPath) as! slotcell
        
        if collectionView == collection_slot {
            cell.imgImage.image = slotarr[indexPath.row].imageByMakingWhiteBackgroundTransparent()
            return cell
        }
        if collectionView == collection_original {
            cell.imgImage.image = originalarr[indexPath.row].imageByMakingWhiteBackgroundTransparent()
            return cell
        } else {
            return cell
        }
    }
    
}

//MARK: - TableView Delegate
extension SpinningMachinePlayVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedTicket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gameMode = dictContest["type"] as? Int ?? 0
        if gameMode == 0 {
            //TODO: FLEXI
            let isLock = arrSelectedTicket[indexPath.row]["isLock"] as? Bool ?? false
            if isLock {
          

                let flexiCell = tableView.dequeueReusableCell(withIdentifier: "SMGameAnsRangeLockTVC") as! GameAnsRangeLockTVC
                
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
                print("Selected Data: \(dictUserSelectData)")
                
                let strSelectedValueMin = "\(dictUserSelectData["startValue"]!)"
                let selectedRangeMin = Int(strSelectedValueMin)
                let strSelectedValueMax = "\(dictUserSelectData["endValue"]!)"
                let selectedRangeMax = Int(strSelectedValueMax)
                
                print("Start Value: \(selectedRangeMin!), End Value: \(selectedRangeMax!)")
                
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
               // lbllockedat.text = "locked at: \(arrSelectedTicket[indexPath.row]["lockTime"] as? String ?? "--")"
                
                return flexiCell
            } else {
                let flexiCell = tableView.dequeueReusableCell(withIdentifier: "SMGameAnsRangeTVC") as! GameAnsRangeTVC
                
                let dictUserSelectData = arrSelectedTicket[indexPath.row]["user_select"] as! [String: Any]
                print("Selected Data: \(dictUserSelectData)")
                
                if isLock {
                    flexiCell.viewUnLocked.isHidden = true
                    flexiCell.viewLocked.isHidden = false
                    flexiCell.labelLockedAnswer.text = "\(dictUserSelectData["startValue"]!) to \(dictUserSelectData["endValue"]!)"
                    flexiCell.labelLockedAt.text = "locked at: \(arrSelectedTicket[indexPath.row]["lockTime"] as? String ?? "--")"
                  //   lbllockedat.text = "locked at: \(arrSelectedTicket[indexPath.row]["lockTime"] as? String ?? "--")"
                    
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
          let displayValue =  arrSloats[0]["displayValue"] as! String
            var isdraw = false
            
            for (i,dict) in arrSloats.enumerated() {
                let displayValue = "\(dict["displayValue"] as? String ?? "0")"
                if displayValue == "Draw" {
                    isdraw = true
                    let strMainString = displayValue.replacingOccurrences(of: " ", with: "\n")
                    if i == 0 {
                        labelAnsMinus.text = strMainString
                         imgminus.isHidden = true
                    }
                    else
                    {
                        imgminus.isHidden = false
                    }
                     if i==1
                    {
                        labelAnsZero.text = strMainString
                         imgzero.isHidden = true
                    }
                     else
                     {
                        imgzero.isHidden = false
                     }
                     if i==2
                    {
                        labelAnsPlus.text = strMainString
                         imgplus.isHidden = true
                    }
                    else
                     {
                        imgplus.isHidden = false
                     }
                 
                }
                else
                {
                  // imgzero.isHidden = false
//                    if  arrSloats[1]["displayValue"] as! String != "Draw" {
//                        let localimg1 = loadImageFromDocumentDirectory(nameOfImage: arrSloats[1]["displayValue"] as! String)
//                        imgzero.image =  localimg1.imageByMakingWhiteBackgroundTransparent()
//                    }
                    let localimg1 = loadImageFromDocumentDirectory(nameOfImage: arrSloats[1]["displayValue"] as! String)
                    if imageIsNullOrNot(imageName: localimg1) {
                        imgzero.image =  localimg1.imageByMakingWhiteBackgroundTransparent()
                    }
                  
                    let localimg0 = loadImageFromDocumentDirectory(nameOfImage: arrSloats[0]["displayValue"] as! String)
                    let localimg2 = loadImageFromDocumentDirectory(nameOfImage: arrSloats[2]["displayValue"] as! String)
                     imgminus.image =  localimg0.imageByMakingWhiteBackgroundTransparent()
                     imgplus.image =  localimg2.imageByMakingWhiteBackgroundTransparent()
                }
      
            }
           
        
            
//            if displayValue == "Draw" {
//                labelAnsZero.text = displayValue
//            }
//            else
//            {
//                let localimg0 = loadImageFromDocumentDirectory(nameOfImage: arrSloats[0]["displayValue"] as! String)
//               // let localimg1 = loadImageFromDocumentDirectory(nameOfImage: arrSloats[1]["displayValue"] as! String)
//                let localimg2 = loadImageFromDocumentDirectory(nameOfImage: arrSloats[2]["displayValue"] as! String)
//
//                imgminus.image = localimg0.imageByMakingWhiteBackgroundTransparent()
//              //  imgzero.image = localimg1.imageByMakingWhiteBackgroundTransparent()
//                imgplus.image = localimg2.imageByMakingWhiteBackgroundTransparent()
//
//            }
           
                
                let isLock = arrSelectedTicket[indexPath.row]["isLock"] as? Bool ?? false
                if isLock {

                    let fixCell = tableView.dequeueReusableCell(withIdentifier: "SMGameAnswerThreeLockTVC") as! SMGameAnswerThreeLockTVC
                    
                    let strAmount = "\(arrSelectedTicket[indexPath.row]["amount"]!)"
                    //fixCell.labelEntryFees.text = "₹\(MyModel().getNumbers(value: Double(strAmount)!))"
                    let test = Double(strAmount) ?? 0.00
                    fixCell.labelEntryFees.text = String(format: "₹ %.02f", test)
                    
                    
                    let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
                    fixCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
                    let strWinnings = "\(arrSelectedTicket[indexPath.row]["totalWinnings"]!)"
                    fixCell.labelTotalWinnig.text = "\(MyModel().getCurrncy(value: Double(strWinnings)!))"
                    let strWinners = "\(arrSelectedTicket[indexPath.row]["maxWinners"]!)"
                    fixCell.labelMaxWinners.text = "\(MyModel().getNumbers(value: Double(strWinners)!))"
                    
                    fixCell.widthView = view.frame.width - 105.0
                    
                    fixCell.arrData = arrSloats
                    
                    fixCell.labelLockTime.text = "Locked at:\(arrSelectedTicket[indexPath.row]["lockTime"] as? String ?? "--")"
                 //   lbllockedat.text = "Locked at:\(arrSelectedTicket[indexPath.row]["lockTime"] as? String ?? "--")"
                    
                    for item in arrSloats {
                        let isSelected = item["isSelected"] as? Bool ?? false
                        if isSelected {
                          //  fixCell.labelAnsSelected.text = item["displayValue"] as? String ?? "0"
                            let localimg = loadImageFromDocumentDirectory(nameOfImage: item["displayValue"] as? String ?? "0")
                            if imageIsNullOrNot(imageName: localimg) {
                                fixCell.imgselected.image =  localimg.imageByMakingWhiteBackgroundTransparent()
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
                            fixCell.imgselected.image =  localimg.imageByMakingWhiteBackgroundTransparent()
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
                    
                    
                    
                    let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
                    fixCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
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
        print("Data: \(arrSloats)")
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
        print("Data: \(arrSloats)")
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
        print("Data: \(arrSloats)")
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
        var strDisplayValue: String?
        
        let arrSloatsSelect = arrSelectedTicket[index]["slotes"] as! [[String: Any]]
        
        for item in arrSloatsSelect {
            let isSelected = item["isSelected"] as? Bool ?? false
            if isSelected {
                
                startValue = item["startValue"] as? Int
                endValue = item["endValue"] as? Int
                strDisplayValue = item["displayValue"] as? String
                break
            }
        }
        
        if startValue == nil && endValue == nil {
            //Alert().showTost(message: "Select Answer", viewController: self)
        } else {
            let parameter:[String: Any] = ["userId": Define.USERDEFAULT.value(forKey: "UserID")!,
                                           "contestId": dictContest["id"]!,
                                           "contestPriceId": arrSelectedTicket[index]["contestPriceId"]!,
                                           "startValue": startValue!,
                                           "endValue": endValue!,
                                           "isLock": 1,
                                           "position": index,
                                           "displayValue": strDisplayValue!,
                                           ]
            print("Parameter: \(parameter)")
            
            let jsonString = MyModel().getJSONString(object: parameter)
            let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
            let strBase64 = encriptString.toBase64()
            
            SocketIOManager.sharedInstance.socket.emitWithAck("updateGame", strBase64!).timingOut(after: 0) { (data) in
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
                    var dictItemData = dictData!["content"] as! [String: Any]
                    print(dictItemData)
                    var dictTicket = self.arrSelectedTicket[index]
                    dictTicket["isLock"] = dictItemData["isLock"]
                    dictTicket["lockTime"] = dictItemData["isLockTime"]
                    self.arrSelectedTicket[index] = dictTicket
                    let indexPath = IndexPath(row: index, section: 0)
                   self.tableAnswer.reloadRows(at: [indexPath], with: .none)
                   
                
                  
                    
                    
                }
            }
        }
        
    }
    
    @objc func buttonRangeAnsLock(_ sender: UIButton) {
        let index = sender.tag
        
        let indexPath = IndexPath(row: index, section: 0)
        let cell = tableAnswer.cellForRow(at: indexPath) as! GameAnsRangeTVC
        
        print(cell.rangeMin, cell.rangeMax)
        
        var startValue: Int?
        var endValue: Int?
        var strDisplayValue: String?
        
        startValue = Int(round(cell.rangeMin))
        endValue = Int(round(cell.rangeMax))
        strDisplayValue = "(\(startValue!) To \(endValue!))"
        
        if startValue == 0 && endValue == 0 {
            //Alert().showTost(message: "Select Answer range", viewController: self)
        } else {
            let parameter:[String: Any] = ["userId": Define.USERDEFAULT.value(forKey: "UserID")!, "contestId": dictContest["id"]!,"contestPriceId": arrSelectedTicket[index]["contestPriceId"]!,
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
                    var dictItemData = dictData!["content"] as! [String: Any]
                    print(dictItemData)
                    var dictTicket = self.arrSelectedTicket[index]
                    print(dictTicket)
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
extension SpinningMachinePlayVC: SMGameAnswerThreeDelegate, GameAnsRangeDelegate {
    
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
                    cell.imgselected.image =  localimg.imageByMakingWhiteBackgroundTransparent()
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
