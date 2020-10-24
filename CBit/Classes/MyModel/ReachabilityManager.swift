import UIKit
import Reachability

class ReachabilityManager: NSObject {
    static let shared = ReachabilityManager()
    
    let reachability = Reachability()!
    
    func startMonitoring() {
        networkRechable()
        networkNotReachable()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable To Start Notifire.")
        }
    }
    
    private func networkRechable() {
        reachability.whenReachable = { reachability in
            print("Newtwork Is Available.")
        }
    }
    
    private func networkNotReachable() {
        reachability.whenUnreachable = { reachability in
            print("Newtwork Is Not Available.")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }
}
