import UIKit
import AVFoundation
import SocketIO

class GamePlayVC: UIViewController,URLSessionDelegate, URLSessionDataDelegate {
    
    @IBOutlet weak var lbltitle: UILabel!
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
    var setSoundEffectTenSecond: AVAudioPlayer?
    var soundURL: URL?
    var TenSecondsoundURL: URL?
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
            
            //setData()
        }
        
        //print(arrBarcketColor.count)
        
        //Add Notificaton
        
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
        let path = Bundle.main.path(forResource: "heartbeat.mp3", ofType: nil)!
        soundURL = URL(fileURLWithPath: path)
        
        let path1 = Bundle.main.path(forResource: "Countdown_timer.mp3", ofType: nil)!
        TenSecondsoundURL = URL(fileURLWithPath: path1)
        
        
        isShowLoading = true
        getContestDetail(isfromtimer: true, isStart: 0)
        
    }
    
    
    
    
    
//    @objc func handleTimerSpeed() {
//
//             checkForSpeedTest()
//
//         }
    
//    func checkForSpeedTest() {
//
//    testDownloadSpeedWithTimout(timeout:20.0) { (speed, error) in
//               print("Download Speed:", speed ?? "NA")
//               print("Speed Test Error:", error ?? "NA")
//         DispatchQueue.main.async {
//
//            var speed = (speed ?? 0.00) * 1000
//
//            let displayspeed = String(format: "%.2f", speed)
//
//            if speed < 550
//            {
//                self.imgTower.image = UIImage(named: "red")
//            }
//            else
//            {
//                self.imgTower.image = UIImage(named: "Green")
//            }
//
//          // if displayspeed
//
//
//       // self.showToast(message: "\(displayspeed)kb/s", font: .systemFont(ofSize: 12.0))
//        }
//           }
//
//
//       }

//        func testDownloadSpeedWithTimout(timeout: TimeInterval, withCompletionBlock: @escaping speedTestCompletionHandler) {
//
//            guard let url = URL(string: "https://file-examples-com.github.io/uploads/2017/10/file_example_JPG_1MB.jpg") else { return }
//
//            startTime = CFAbsoluteTimeGetCurrent()
//            stopTime = startTime
//            bytesReceived = 0
//
//            speedTestCompletionBlock = withCompletionBlock
//
//            let configuration = URLSessionConfiguration.ephemeral
//            configuration.timeoutIntervalForResource = timeout
//            let session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
//            session.dataTask(with: url).resume()
//
//        }

//        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//
//            bytesReceived! += data.count
//            stopTime = CFAbsoluteTimeGetCurrent()
//
//        }
//
//        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//
//            let elapsed = stopTime - startTime
//
//            if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
//                speedTestCompletionBlock?(nil, error)
//                return
//            }
//
//            let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
//            speedTestCompletionBlock?(speed, nil)
//
//        }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFromNotification {
           // labelTimer.text = "Game starts in \(timeString(time: TimeInterval(startSecond)))"
        }
        SocketIOManager.sharedInstance.lastViewController = self
       // SwiftPingPong.shared.startPingPong()
     //   self.startlistner()
        NotificationCenter.default.addObserver(
             self,
             selector: #selector(applicationWillEnterForeground(_:)),
             name: UIApplication.willEnterForegroundNotification,
             object: nil)
    }
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        print("App moved to foreground!")
        getContestDetail(isfromtimer: true, isStart: 0)
        }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SocketIOManager.sharedInstance.lastViewController = nil
        SwiftPingPong.shared.stopPingPong()
        startTimer?.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
      //  startTimer?.invalidate()
        timermili?.invalidate()
        viewAnimation?.adsTimer?.invalidate()
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
        islockallpressed = true
//         let fixCell = tableAnswer.dequeueReusableCell(withIdentifier: "GameAnswerTwoTVC") as! GameAnswerTwoTVC
//        fixCell.buttonLockNow.isEnabled = false
//        fixCell.buttonLockNow.alpha = 0.5
//        if LockAll == nil {
//            LockAll = LockAll.LockAll.instanceFromNib() as? LockAll
//            LockAll!.frame = view.bounds
//            view.addSubview(LockAll!)
//        }
        
        print("selection",strDisplayValuelockall ?? "")
        if strDisplayValuelockall == nil
        {
           
        }
        else{
            locakall()
        }
        
    }
    
    func locakall()
    {
//        lockallmili = currentTodayTimeInMilliSeconds()
//        let total = lockallmili - 100 //+ startdatemilisec
        if startTimemili == 0 {
            startTimemili = 10
        }
        lockallmili = startTimemili * 10
        print("FETCHTIME:",startTimemili)
        let total = lockallmili + startdatemilisec
        let dt = total.dateFromMilliseconds()
        
       // let d = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"

       let datenew = df.string(from: dt)
        print("newdate",datenew)
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

           
        
               let parameter:[String: Any] = ["userId": Define.USERDEFAULT.value(forKey: "UserID")!,
                                              "contestId": dictContest["id"]!,
                                              "DisplayValue":strDisplayValuelockall ?? "",
                                              "lock_time":datenew
                                              
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
                     
                       }
                    self.tableAnswer.reloadData()
                    self.getContestDetail(isfromtimer: true, isStart: 0)
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
                  //                                   print(dictData)
                  //                                   print(self.dictContest)
                                                     self.dictGameData = dictData!["content"] as! [String: Any]
                                                     print(self.dictGameData)

                                                     self.gametype  = self.dictContest["game_type"] as! String
                                                     if self.gametype == "rdb" {
                                                         self.viewrdb.isHidden = false
                                                      //   self.buttonAnsMinus.backgroundColor = UIColor.red

                                                     }
                                                     else
                                                     {
                                                         self.view0to9.isHidden = false
                                                     }
                                                     let serverDate = self.dictGameData["currentTime"] as? String ?? "\(MyModel().convertDateToString(date: Date(), returnFormate: "yyyy-MM-dd HH:mm:ss"))"
                                                     self.currentDate = MyModel().converStringToDate(strDate: serverDate, getFormate: "yyyy-MM-dd HH:mm:ss")

                                                     print("➤ \(self.dictGameData)")
                                          
//                                          let getResponceTime = Date()
//
//                                                                          let calender = Calendar.current
//                                                                          let unitFlags = Set<Calendar.Component>([ .second])
//                                                                          let dateComponent = calender.dateComponents(unitFlags, from: sendRequestTime, to: getResponceTime)
//
//                                                                          self.differenceSecond = dateComponent.second!
                                    //      print("=> The Difference Of Second is: ", self.differenceSecond)
                                          
                                         // if isfromtimer {
                                          self.setnewData()
                                        //  }
                                          
                                                     Loading().hideLoading(viewController: self)
                                        
               }
    }
    var gamestart = true
    var startdatemilisec = Int()
    var lockmili = 0
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
        
       
            
        if  Int(self.gameTime) ?? 0 == 40 {
          print("TENSECOND")
              setTenSecSound()
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
            
            print("Set Data",dictGameData)
            let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"
           // second = (dictGameData["duration"] as? Int)!
           // print("secondsspre",second)
            
        if Int(gameTime)! <= 30 {
            startTimemili = (30 - Int(gameTime)!) * 100
//            if Int(gameTime)! == 30  {
//                startTimemili = 99
//            }
//            else
//            {
//                startTimemili = (30 - Int(gameTime)!) * 100
//            }
            
            startmilitimer()
        }
            
            //  labelTimer.text = ""
            if (gameStatus == "start") {
                
                isGameStart = true
               
                print("secondss",second)
               // print(dictGameData["duration"] as? Int)
//                second = ((dictGameData["duration"] as? Int ?? 30))
//                second = 30
                self.labelTimer.text = "\(gameTime)"
               // second = second - 1
               // setTimer()
                if gamestart {
                    
                    let date = dictGameData["startDate"] as! String
                    let startDate = MyModel().converStringToDate(strDate: date, getFormate: "yyyy-MM-dd HH:mm:ss")
                    startdatemilisec =  Int(startDate.millisecondsSince1970)
                    
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
                    
//                    let arrSloats = arrSelectedTicket[0]["slotes"] as! [[String: Any]]
//                    strDisplayValuelockall = arrSloats[0]["displayValue"] as? String ?? ""
//                    btn_lockall(btnlockall)

                    
                    self.getContestDetail(isfromtimer: true, isStart: 0)
                  //  self.setData(isfromtime: true)
                }
                
            
                
            } else if gameStatus == "gameEnd" {
                
                NotificationCenter.default.removeObserver(self)
                SocketIOManager.sharedInstance.lastViewController = nil
                let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "GameResultVC") as! GameResultVC
                resultVC.dictContest = dictContest
                self.navigationController?.pushViewController(resultVC, animated: true)
                
                
            } else {
                isGameStart = false
                
//                let date = dictGameData["startDate"] as! String
//                let startDate = MyModel().converStringToDate(strDate: date, getFormate: "yyyy-MM-dd HH:mm:ss")
//
//                let calender = Calendar.current
//                let unitFlags = Set<Calendar.Component>([ .second])
//                let dateComponent = calender.dateComponents(unitFlags, from: self.currentDate, to: startDate)
//                startSecond = dateComponent.second! - differenceSecond
//                //startSecond = MyModel().getSecound(currentTime: self.currentDate, startDate: startDate)
//                print("Seconds: \(startSecond)")
                labelTimer.text = "Game starts in 00:\(time)"
              //  updateColors()
                          // collectionGame.reloadData()
//                if isfromtime {
//                     if startTimer == nil {
//                                   startSecond = startSecond - 1
//                                   labelTimer.text = "Game starts in \(timeString(time: TimeInterval(startSecond)))"
//                                   setStartTimer()
//                        
//                               }
//                    else
//                     {
//                   //     labelTimer.text = ""
//                    }
//                }
               
            }
    //           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    //
    //        }
            self.collectionGame.reloadData()
//            tableAnswer.reloadData()
        }
    
    weak var timermili: Timer?
     var startTimemili = Int()
     var timemili = Int()
    
    func startmilitimer()  {
        
//        if timermili != nil {
//            timermili!.invalidate()
//            timermili = nil
//        }
        if timermili == nil {
            
            timermili = Timer.scheduledTimer(timeInterval: 0.01,
                                             target: self,
                                             selector: #selector(advanceTimer(timer:)),
                                             userInfo: nil,
                                             repeats: true)
            
             RunLoop.current.add(timermili!, forMode: .common)
          //  RunLoop.current.add(self.startTimer!, forMode: RunLoop.Mode.common)
            
        }
    
      //  startTimemili = Date().timeIntervalSinceReferenceDate
  
     }

     //When the view controller is about to disappear, invalidate the timer
//     override func viewWillDisappear(_ animated: Bool) {
//       timermili?.invalidate()
//     }


    @objc func advanceTimer(timer: Timer) {
       
       //Total time since timer started, in seconds
        
      //  lockallmili = startTimemili * 10
     //  timemili = Date().timeIntervalSinceReferenceDate - startTimemili

       //The rest of your code goes here

       //Convert the time to a string with 2 decimal places
    //   let timeString = String(format: "%.3f", startTimemili)
        print("MILITIMER:",startTimemili)
        startTimemili = startTimemili + 1
       //Display the time string to a label in our view controller
     //  timeValueLabel.text = timeString
     }
    
    
    func getContestDetail(isfromtimer:Bool,isStart:Int) {
        
        if isShowLoading {
            Loading().showLoading(viewController: self)
        }
        
        
        let parameter:[String: Any] = [ "contest_id": dictContest["id"]!, "userId":Define.USERDEFAULT.value(forKey: "UserID")!,"isStart":0]
        print("Parameter: \(parameter)")
        
        let jsonString = MyModel().getJSONString(object: parameter)
        let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
        let strBase64 = encriptString.toBase64()
        let sendRequestTime = Date()
        
//        SocketIOManager.sharedInstance.socket.emitWithAck("contestDetails", strBase64!).timingOut(after: 0) {data in
//            print("SOCKETDATA:",data)
//        }
        //
        
          //  Loading().showLoading(viewController: self)
           
            let strURL = Define.APP_URL + Define.API_CONTEST_DETAIL
          //  print("Parameter: \(parameter)\nURL: \(strURL)")
            
//            let jsonString = MyModel().getJSONString(object: parameter)
//            let encriptString = MyModel().encrypting(strData: jsonString!, strKey: Define.KEY)
//            let strBase64 = encriptString.toBase64()
            
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
//                                   print(dictData)
//                                   print(self.dictContest)
                                   self.dictGameData = result!["content"] as! [String: Any]
                                   print(self.dictGameData)
                      //  self.arrTickets = self.dictGameData["tickets"] as? [[String: Any]] ?? []
                     //   self.tableAnswer.reloadData()
                                   self.gametype  = self.dictContest["game_type"] as! String
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
        
        //
           
       // }
    }
    
    func   setData(isfromtime:Bool) {
        lbltitle.text = dictGameData["title"] as? String
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
        
        //notStart
        //start
    //gameEnd
        
        print("Set Data",dictGameData)
        let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"
        second = (dictGameData["duration"] as? Int)!
        print("secondsspre",second)
        
   
        
        //  labelTimer.text = ""
        if (gameStatus == "start") {
           
            
//            isGameStart = true
//           
//            print("secondss",second)
//           // print(dictGameData["duration"] as? Int)
//            second = ((dictGameData["duration"] as? Int ?? 30) - differenceSecond - 4)
//           // second = 30
//            self.labelTimer.text = "\(self.second)"
//            second = second - 1
//            setTimer()
            
            if self.gametype == "rdb" {
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
            }
//            else
//            { // 1 TO 9 NUMBER GAME
//                                        btnlockallnumber.isEnabled = true
//                                         btnlockallnumber.alpha = 1.0
//
//                                           btnonee.isEnabled = true
//                                           btntwo.isEnabled = true
//                                           btnthree.isEnabled = true
//                                           btnfour.isEnabled = true
//                                           btnfive.isEnabled = true
//                                           btnsix.isEnabled = true
//                                           btnseven.isEnabled = true
//                                           btneeight.isEnabled = true
//                                           btnnine.isEnabled = true
//                                           btnzero.isEnabled = true
//
//
//                                   let  LockAllData = dictGameData["LockAllData"] as? [[String: Any]] ?? []
//                                    if LockAllData.count > 0 {
//                                        let isLockAll = LockAllData[0]["isLockAll"] as? Bool ?? false
//
//                                        if isLockAll {
//                                            let displayValue = LockAllData[0]["displayValue"] as? String ?? "0"
//                                            lblnumberanswerselected.text! = displayValue
//
//                                            if displayValue  == "0"
//                                                 {
//                                                     strDisplayValuelockall = "0"
//                                                      btnzero.backgroundColor = UIColor.white
//                                                      btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                      btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                      btnthree.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//                                                      btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                      btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                      btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                      btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                      btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                      btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//
//                                                 }
//
//                                                 else if  displayValue  == "1"
//                                                 {
//
//                                                     strDisplayValuelockall = "1"
//
//                                                     btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnonee.backgroundColor = UIColor.white
//                                                     btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//
//                                                 }
//
//                                                 else if  displayValue  == "2"
//                                                 {
//                                                     strDisplayValuelockall = "2"
//
//                                                     btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btntwo.backgroundColor = UIColor.white
//                                                     btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                 }
//
//                                                 else if  displayValue  == "3"
//                                                 {
//                                                     strDisplayValuelockall = "3"
//                                                     btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnthree.backgroundColor = UIColor.white
//                                                     btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//
//                                                 }
//                                                 else if  displayValue  == "4"
//                                                 {
//                                                     strDisplayValuelockall = "4"
//
//                                                     btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfour.backgroundColor = UIColor.white
//                                                     btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//
//                                                 }
//
//                                                 else if  displayValue  == "5"
//                                                 {
//                                                     strDisplayValuelockall = "5"
//                                                     btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfive.backgroundColor = UIColor.white
//                                                     btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//
//                                                 }
//
//                                                 else if  displayValue  == "6"
//                                                 {
//                                                     strDisplayValuelockall = "6"
//                                                     btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnsix.backgroundColor = UIColor.white
//                                                     btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                 }
//
//                                                 else if  displayValue  == "7"
//                                                 {
//                                                     strDisplayValuelockall = "7"
//
//                                                     btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnseven.backgroundColor = UIColor.white
//                                                     btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                 }
//                                                 else if  displayValue  == "8"
//                                                 {
//                                                     strDisplayValuelockall = "8"
//                                                     btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btneeight.backgroundColor = UIColor.white
//                                                     btnnine.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                 }
//                                                 else if  displayValue  == "9"
//                                                 {
//
//                                                     strDisplayValuelockall = "9"
//                                                     btnzero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnonee.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btntwo.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnthree.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfour.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnfive.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnsix.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnseven.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btneeight.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
//                                                     btnnine.backgroundColor = UIColor.white
//
//                                                 }                                        }
//                                        else
//                                        {
//                                            btnlockallnumber.isEnabled = true
//                                            btnlockallnumber.alpha = 1.0
//
//                                            btnonee.isEnabled = true
//                                            btntwo.isEnabled = true
//                                            btnthree.isEnabled = true
//                                            btnfour.isEnabled = true
//                                            btnfive.isEnabled = true
//                                            btnsix.isEnabled = true
//                                            btnseven.isEnabled = true
//                                            btneeight.isEnabled = true
//                                            btnnine.isEnabled = true
//                                            btnzero.isEnabled = true
//                                        }
//                                    }
//                          else
//                                    {
//                                        btnlockallnumber.isEnabled = true
//                                        btnlockallnumber.alpha = 1.0
//
//                                        btnonee.isEnabled = true
//                                        btntwo.isEnabled = true
//                                        btnthree.isEnabled = true
//                                        btnfour.isEnabled = true
//                                        btnfive.isEnabled = true
//                                        btnsix.isEnabled = true
//                                        btnseven.isEnabled = true
//                                        btneeight.isEnabled = true
//                                        btnnine.isEnabled = true
//                                        btnzero.isEnabled = true
//                          }
//            }
                              

            
            
        } else if gameStatus == "gameEnd" {
            NotificationCenter.default.removeObserver(self)
            SocketIOManager.sharedInstance.lastViewController = nil
            let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "GameResultVC") as! GameResultVC
            resultVC.dictContest = dictContest
            self.navigationController?.pushViewController(resultVC, animated: true)
            
            
        } else {
          
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
                          //     labelTimer.text = "Game starts in \(timeString(time: TimeInterval(startSecond)))"
                               setStartTimer()

                           }
                else
                 {
               //     labelTimer.text = ""
                }
            }
           
        }
//           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//
//        }
        self.collectionGame.reloadData()
        tableAnswer.reloadData()
    }
    
    func setlockalldata(dictdata:[String:Any])  {
         let gameStatus = dictdata["gameStatus"] as? String ?? "notStart"
                second = (dictdata["duration"] as? Int)!
                print("secondsspre",second)
                
                if (gameStatus == "start") {
                    
                    if self.gametype == "rdb" {
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
                    }
    }
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
            
            

                                                     self.gametype  = self.dictContest["game_type"] as! String
                                                     if self.gametype == "rdb" {
                                                         self.viewrdb.isHidden = false
                                                       //  self.buttonAnsMinus.backgroundColor = UIColor.red

                                                     }
                                                     else
                                                     {
                                                         self.view0to9.isHidden = false
                                                     }
//                                                     let serverDate = self.dictGameData["currentTime"] as? String ?? "\(MyModel().convertDateToString(date: Date(), returnFormate: "yyyy-MM-dd HH:mm:ss"))"
//                                                     self.currentDate = MyModel().converStringToDate(strDate: serverDate, getFormate: "yyyy-MM-dd HH:mm:ss")
//
//                                                     print("➤ \(self.dictGameData)")
                                          
//                                          let getResponceTime = Date()
//
//                                                                          let calender = Calendar.current
//                                                                          let unitFlags = Set<Calendar.Component>([ .second])
//                                                                          let dateComponent = calender.dateComponents(unitFlags, from: sendRequestTime, to: getResponceTime)
//
//                                                                          self.differenceSecond = dateComponent.second!
                                    //      print("=> The Difference Of Second is: ", self.differenceSecond)
                                          
                                         // if isfromtimer {
            if dictContest["id"] as! Int == dictGameData["id"] as! Int {
                 self.setnewData()
            }
            
                                         
                                        //  }
                                          
                                                     Loading().hideLoading(viewController: self)
           } else {
               
               print("--> No Data")
               isShowLoading = false

            //   getContestDetail(isfromtimer: true)
               


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

            //    getContestDetail(isfromtimer: true)
                

            }
        } else {
            
            print("--> No Data")
            isShowLoading = false

         //   getContestDetail(isfromtimer: true)
            


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
                        updateColors()
                        collectionGame.reloadData()
                    } else if miliSecondValue == 1 {
                        miliSecondValue = 0
                     //   print("STARTSECOND:",startSecond)
                        
                        if startSecond == 1 {
            //              let getResponceTime = Date()
            //             let sendRequestTime = Date()
            //              let calender = Calendar.current
            //              let unitFlags = Set<Calendar.Component>([ .second])
            //              let dateComponent = calender.dateComponents(unitFlags, from: sendRequestTime, to: getResponceTime)
            //
            //              self.differenceSecond = dateComponent.second!
            //
            //              print("=> The Difference Of Second is: ", self.differenceSecond)
                            
            //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7)
            //                {
                      //     self.setData(isfromtime: false)
                            }
                    //        }
                        
                        if startSecond > 1 {
                            startSecond = startSecond - 1
                        //    labelTimer.text = "Game starts in \(timeString(time: TimeInterval(startSecond)))"
                            updateColors()
                            collectionGame.reloadData()
                            
                            if startSecond ==  5 {
                             //   print("ENDSECOND:",endGameSecond)
                              //   DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                 
                               //                     }
                                if !self.isStartEventCall {

                                            print("If Start Event call.")
                                           // self.isStartEventCall = true
                                            //self.isShowLoading = false
                                //    self.getContestDetail(isfromtimer: false, isStart: 1)

                                }
                            }
                        }
                        else {
                            if startTimer != nil {
                                startTimer!.invalidate()
                                startTimer = nil
                              //   labelTimer.text = ""
            //                    let gameStatus = dictGameData["gameStatus"] as? String ?? "notStart"
            //                          //  labelTimer.text = ""
            //                           if gameStatus == "start" {
            //                            updateColors()
            //                            collectionGame.reloadData()
            //                            self.setData(isfromtime: false)
            //                    }
            //                    else
            //                    {
            //                            let alert = UIAlertController(title: "Alert", message: "Your network connection maybe down or its not connected", preferredStyle: .alert)
            //
            //                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //                                print("Back")
            //                                NotificationCenter.default.removeObserver(self)
            //                                self.navigationController?.popViewController(animated: true)
            //                            }))
            //
            //                            self.present(alert, animated: true)
            //                    }
                               
                            }
                            

                            
                            
                            
                      
                            // changed delay time to
                            // TODO: 05/08/20 Change 2.5 to 0.1
            //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //                    if !self.isStartEventCall {
            //                        print("If Start Event call.")
            //                        self.isStartEventCall = true
            //                        self.isShowLoading = false
            //                        self.getContestDetail()
            //                    }
            //                }
                            
                            
                            
            //                isGameStart = true
            //
            //                         // print(dictGameData["duration"] as? Int)
            //                          second = ((dictGameData["duration"] as? Int ?? 30) - differenceSecond)
            //                          self.labelTimer.text = "\(self.second)"
            //                          second = second - 1
            //                          setTimer()
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
    var islockallpressed = false
    var lockallmili = Int()
    @objc func handleTimer(){
        if second > 0 {
           // print("Second: \(second)")
            
//            if msecond > 0 {
//                print("\(second-1)" + ":"  + "\(msecond)")
//
//                msecond = msecond - 1
//                self.labelTimer.text = "\(second-1)" + ":"  + "\(msecond)"
            
//            }
            
        //    self.labelTimer.text = String(format: "%02i", self.second)
            //print(labelTimer.text!)
          
           // msecond = 999
            
//            for z in 0..<1000 {
//                if islockallpressed {
//                    islockallpressed = false
//                    let minsec = (30-second) * 1000
//                     lockallmili = Double(minsec + (z/1000))
//                     print("lockallmili:",lockallmili,z)
//                     locakall()
//                }
//                print("looptime:",z)
//
//            }
            second = second - 1
            
        } else {
            //print("Timer Not Start")
            if timer != nil {
               // self.labelTimer.text = "00"
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
                let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "GameResultVC") as! GameResultVC
                resultVC.dictContest = dictContest
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        }
    }
    
    func setSound() {
        do{
            setSoundEffect = try AVAudioPlayer(contentsOf: soundURL!)
            setSoundEffect!.numberOfLoops = 4
            if UserDefaults.standard.bool(forKey: "isaudio") {
                viewAnimation?.isclicked = true
                setSoundEffect!.play()
                viewAnimation?.btnaudio.setImage(UIImage(named: "audio-speaker-on"), for: .normal)
            }
            else
            {
                viewAnimation?.isclicked = false
                setSoundEffect!.pause()
                viewAnimation?.btnaudio.setImage(UIImage(named: "mute"), for: .normal)
            }
            viewAnimation?.avaudio = setSoundEffect ?? AVAudioPlayer()
        } catch {
            print("Error In Sound PLay")
        }
    }
    
    func setTenSecSound() {
        do{
            setSoundEffectTenSecond = try AVAudioPlayer(contentsOf: TenSecondsoundURL!)
            //setSoundEffect!.numberOfLoops = 4
            setSoundEffectTenSecond!.play()
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
extension GamePlayVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
extension GamePlayVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSelectedTicket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gameMode = dictContest["type"] as? Int ?? 0
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
                let flexiCell = tableView.dequeueReusableCell(withIdentifier: "GameAnsRangeTVC") as! GameAnsRangeTVC
                
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
            
            if arrSloats.count == 3 {
                
                let isLock = arrSelectedTicket[indexPath.row]["isLock"] as? Bool ?? false
                
                if isLock {
     
                                    
                    

                    let fixCell = tableView.dequeueReusableCell(withIdentifier: "GameAnswerOneTVC") as! GameAnswerOneTVC
                    
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
                  //  lbllockedat.text = "Locked at:\(arrSelectedTicket[indexPath.row]["lockTime"] as? String ?? "--")"
                    //Selection
                    let arrSloatsCheck = arrSelectedTicket[indexPath.row]["slotes"] as! [[String: Any]]
                    let isSelectedMinus = arrSloatsCheck[0]["isSelected"] as? Bool ?? false
                    
                    if isSelectedMinus {
                        fixCell.buttonAnsMinus.backgroundColor = UIColor.white
                        fixCell.labelAnsMinus.textColor = UIColor.black
                    } else {
                        
                      //  fixCell.buttonAnsMinus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        
                        fixCell.buttonAnsMinus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        fixCell.labelAnsMinus.textColor = UIColor.white
                    }
                    
                    let isSelectedZero = arrSloatsCheck[1]["isSelected"] as? Bool ?? false
                    if isSelectedZero {
                        fixCell.buttonAnsZero.backgroundColor = UIColor.white
                        
                    } else {
                        fixCell.buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                    }
                    
                    let isSelectedPlus = arrSloatsCheck[2]["isSelected"] as? Bool ?? false
                    if isSelectedPlus {
                        fixCell.buttonAnsPlus.backgroundColor = UIColor.white
                        fixCell.labelAnsPlus.textColor = UIColor.black
                    } else {
                       // fixCell.buttonAnsPlus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        fixCell.buttonAnsPlus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
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
                    
                    
                    let strTickets = "\(arrSelectedTicket[indexPath.row]["totalTickets"]!)"
                    fixCell.labelTotalTickets.text = "\(MyModel().getNumbers(value: Double(strTickets)!))"
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
                    } else {
                       // fixCell.buttonAnsMinus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        
                        fixCell.buttonAnsMinus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        fixCell.labelAnsMinus.textColor = UIColor.white
                        
                    }
                    
                    
                    let isSelectedZero = arrSloatsCheck[1]["isSelected"] as? Bool ?? false
                    if isSelectedZero {
                        fixCell.buttonAnsZero.backgroundColor = UIColor.white
                    } else {
                        fixCell.buttonAnsZero.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                    }
                    
                    let isSelectedPlus = arrSloatsCheck[2]["isSelected"] as? Bool ?? false
                    if isSelectedPlus {
                        fixCell.buttonAnsPlus.backgroundColor = UIColor.white
                        
                    } else {
                   //     fixCell.buttonAnsPlus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
                        
                        fixCell.buttonAnsPlus.backgroundColor = #colorLiteral(red: 1, green: 0.7411764706, blue: 0.2549019608, alpha: 1)
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
        
//        lockallmili = currentTodayTimeInMilliSeconds()
//        let total = lockallmili - 100//+ startdatemilisec
        if startTimemili == 0 {
            startTimemili = 10
        }
        lockallmili = startTimemili * 10
        print("FETCHTIME:",startTimemili)
        let total = lockallmili + startdatemilisec
        let dt = total.dateFromMilliseconds()
        
     //   let d = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"

       let datenew = df.string(from: dt)
        print("newdate",datenew)
        
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
                                           "lock_time":datenew
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
extension GamePlayVC: GameAnswerThreeDelegate, GameAnsRangeDelegate {
    
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
        print("Index: \(index.row)")
        
        
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

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
//MARK: - Alert Controller
extension GamePlayVC {
//    func contestError() {
//        let alertController = UIAlertController(title: "Contes", message: , preferredStyle: )
//
//    }
}


extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Int {
    func dateFromMilliseconds() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self)/1000)
    }
}

func currentTodayTimeInMilliSeconds()-> Int
    {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
