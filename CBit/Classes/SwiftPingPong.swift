//
//  SwiftPingPong.swift
//  CBit
//
//  Created by The FreeBird on 13/07/19.
//  Copyright © 2019 Bhavik Kothari. All rights reserved.
//


import UIKit
import Reachability

class SwiftPingPong: NSObject {
    
    static let shared = SwiftPingPong()
    var pingPongTimer: Timer?
    
    private var isSuccess = Bool()
    private var isFail = Bool()
    
    func startPingPong() {
        isSuccess = true
        isFail = false
        if pingPongTimer == nil {
            
            pingPongTimer = Timer.scheduledTimer(timeInterval: 1,
                                                 target: self,
                                                 selector: #selector(handlePingPongTimer(_:)),
                                                 userInfo: nil,
                                                 repeats: false)
            
        }
    }
    func stopPingPong() {
        
        if isFail {
            SocketIOManager.sharedInstance.establisConnection()
        }
        if pingPongTimer != nil {
            pingPongTimer!.invalidate()
            pingPongTimer = nil
        }
        
    }
    
    //TODO: HANDLE TIMER
    @objc func handlePingPongTimer(_ timer: Timer) {
       
        pingPongAPI()

//        let socketConnectionStatus = SocketIOManager.sharedInstance.socket.status
//                               switch socketConnectionStatus {
//                               case .connected:
//                                   print("socket connected")
//                               case .connecting:
//                                   print("socket connecting")
//                               case .disconnected:
//                                   print("socket disconnected")
//                                 pingPongAPI()
//                               case .notConnected:
//                                   print("socket not connected")
//                               }
        
       //declare this property where it won't go out of scope relative to your listener
        let reachability = Reachability()

        reachability?.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability?.whenUnreachable = { _ in
            print("Not reachable")
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    //TODO: API
    private func pingPongAPI() {
        let url = URL(string: "\(Define.APP_URL)checkNetwork")!
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringCacheData,
                                 timeoutInterval: 3)
        request.setValue("iOS", forHTTPHeaderField: "User-Agent")
        request.setValue("close", forHTTPHeaderField: "Connection")
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlSession, error) in
            if error == nil {
                print("Success")
                if !self.isSuccess {
                    self.isFail = false
                    self.isSuccess = true
                    print("----- Network Is Available -----")
                    DispatchQueue.main.sync {
                        SocketIOManager.sharedInstance.establisConnection()
                    }
                }
            } else {
                print("Failure")
                if !self.isFail {
                    self.isSuccess = false
                    self.isFail = true
                    print("----- Network Is Not Available -----")
                    
                    DispatchQueue.main.sync {
                        SocketIOManager.sharedInstance.closeConnection()
                        Define.APPDELEGATE.showLoading()
                    }
                }
            }
        }
        task.resume()
    }
}
