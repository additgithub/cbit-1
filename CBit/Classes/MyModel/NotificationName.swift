import Foundation
import UIKit

extension Notification.Name {
    
    static let upComingContest = Notification.Name("UpComingContest")
    static let myContest = Notification.Name("MyContest")
    static let startGame = Notification.Name("StartContest")
    static let endGame = Notification.Name("EndContest")
    static let errorConnectSocket = Notification.Name("ErrorConnectSocket")
    static let paymentUpdated = Notification.Name("PaymentUpdated")
    static let userUnauthorized = Notification.Name("UserUnauthorized")
    static let updateHistory = Notification.Name("UpdateHistory")
    static let updatePrivateContest = Notification.Name("UpdatePrivateContest")
    static let hostContest = Notification.Name("HostedContest")
    static let onContestLiveUpdate = Notification.Name("OnContestLiveUpdate")
    static let BankAccountAdded = Notification.Name("BankAccountAdded")
    static let getAllspecialContest = Notification.Name("getAllspecialContest")
     static let EnterGamePage = Notification.Name("EnterGamePage")
}
