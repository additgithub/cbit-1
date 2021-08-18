import Foundation
import Alamofire
import UIKit

extension UIView {
   func createDottedLine(width: CGFloat, color: CGColor) {
      let caShapeLayer = CAShapeLayer()
      caShapeLayer.strokeColor = color
      caShapeLayer.lineWidth = width
      caShapeLayer.lineDashPattern = [5,7]
      let cgPath = CGMutablePath()
      let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
      cgPath.addLines(between: cgPoint)
      caShapeLayer.path = cgPath
      layer.addSublayer(caShapeLayer)
   }
}

class MyModel {
    
    // MARK: -Encrypt & Decrypt  😊
    func encrypting(strData: String, strKey: String) -> String {
        let cryptLib = CryptLib()
        let encryptText = cryptLib.encryptPlainTextRandomIV(withPlainText: strData, key: strKey)
        return encryptText!
    }
    
    func decrypting(strData: String, strKey: String) -> String {
        let cryptLib = CryptLib()
        let decryptText = cryptLib.decryptCipherTextRandomIV(withCipherText: strData, key: strKey)
        return decryptText!
    }
    
    //MARK: - View Radius
    func roundCorners(corners: UIRectCorner, radius: CGFloat, view: UIView) {
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    func setShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
    }
    
    func setGradient(view: UIView, startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [startColor,endColor]
        gradientLayer.type = .radial
        gradientLayer.locations = [90]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Validation Method.
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidMobileNumber(value: String) -> Bool {
        let PHONE_REGEX = "^[0-9]{10,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    // MARK: - Check Internet.
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    // MARK: - Date Formatter
    func converStringToDate(strDate: String, getFormate: String) -> Date {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = getFormate
        
        return dateFormatter.date(from: strDate)!
    }
    
    func convertDateToString(date: Date, returnFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = returnFormate
        
        return dateFormatter.string(from: date)
    }
    
    func convertStringDateToString(strDate: String, getFormate: String, returnFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = getFormate
        
        let recivedDate = dateFormatter.date(from: strDate)
        
        dateFormatter.dateFormat = returnFormat
        
        return dateFormatter.string(from: recivedDate!)
        
    }
    
    func timeString(time: TimeInterval) -> String {
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let secounds = Int(time) % 60
        
        let strTime = String(format: "%02i:%02i:%02i", hours, minutes, secounds)
        return strTime
        
    }
    
    func getDateForRemider(contestDate: String) -> Date {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDate = dateFormater.date(from: contestDate)
        
        let calendar = NSCalendar.current
        let minusDate = calendar.date(byAdding: .second, value: -90, to: startDate!)
        
        return minusDate!
        
    }
    
    func getDateForRemiderbeforetensecond(contestDate: String) -> Date {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDate = dateFormater.date(from: contestDate)
        
        let calendar = NSCalendar.current
        let minusDate = calendar.date(byAdding: .second, value: -10, to: startDate!)
        
        return minusDate!
        
    }
    
    func getDateForRemiderbeforethirtysecond(contestDate: String) -> Date {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDate = dateFormater.date(from: contestDate)
        
        let calendar = NSCalendar.current
        let minusDate = calendar.date(byAdding: .second, value: -60, to: startDate!)
        
        return minusDate!
        
    }
    
    // MARK: - Random Number Genrator
    func makeList(number: Int, gameMode: String) -> [Int] {
        //(0..<number).map{_ in Int.random(in: 50 ... 950)}
        var i = 5
        if gameMode.caseInsensitiveCompare("private") == .orderedSame {
            i = 5
        } else {
            i = 10
        }
        var arrRandomNumber = [Int]()
        
        for n in 1...9 {
            arrRandomNumber.append(n * i)
            
        }
        
        if number == 16 {
            for n in 1...8 {
                arrRandomNumber.append(n * i)
            }
        } else if number == 32 {
            for n in 1...24 {
                arrRandomNumber.append(n * i)
            }
        }
        arrRandomNumber.shuffle()
        if number == 8 {
            arrRandomNumber.remove(at: 5)
        }
        return arrRandomNumber
    }
    
    func createRandomNumbers(number: Int, minRange: Int, maxRange: Int) -> [Int] {
        
        var arrRandomNumbers = [Int]()
        
        let arrRndNbrs = (0..<number).map{_ in Int.random(in: minRange ... maxRange)}
        
        for item in arrRndNbrs {
            if item < 0 {
                arrRandomNumbers.append(abs(item))
            } else {
                arrRandomNumbers.append(item)
            }
        }
        
        return arrRandomNumbers
    }
    
    
    
    //MARK: - CURRUNCY
    func getCurrncy(value: Double) -> String{
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_IN")
        formatter.numberStyle = .currency
        
        let strValue = formatter.string(from: NSNumber(value: value))
        //print("👉👉\(strValue!)")
        return strValue!
    }
    

    func getNumbers(value: Double) -> String{
        let strValue = String(format: "%.02f", value)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_IN")
        formatter.numberStyle = .decimal
        
        let strFormateValue = formatter.string(from: NSNumber(value: Double(strValue)!))
        //print("👉👉\(strValue!)")
        return strFormateValue!
    }
    
    
    //MARK: - JSON
    func getJSONString(object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToArrayOfDictionary(text: String) -> [[String: Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // MARK: - Set User Data
    func setUserData(userData: [String: Any]) {
        Define.USERDEFAULT.set(true, forKey: "isLogin")
        
        let token = "Bearer \(userData["token"] as! String)"
        
        Define.USERDEFAULT.set(token, forKey: "AccessToken")
        Define.USERDEFAULT.set("\(userData["id"]!)", forKey: "UserID")
        Define.USERDEFAULT.set(userData["firstName"]!, forKey: "FirstName")
        Define.USERDEFAULT.set(userData["middelName"]!, forKey: "MiddelName")
        Define.USERDEFAULT.set(userData["lastName"]!, forKey: "LastName")
        Define.USERDEFAULT.set(userData["userName"]!, forKey: "UserName")
        Define.USERDEFAULT.set(userData["email"]!, forKey: "Email")
        Define.USERDEFAULT.set(userData["myCode"]!, forKey: "UserCode")
        Define.USERDEFAULT.set(userData["mobile_no"]!, forKey: "UserMobile")
        Define.USERDEFAULT.set(userData["profile_image"], forKey: "ProfileImage")
        
         Define.USERDEFAULT.set(userData["AutoPilot"], forKey: "AutoPilot")
         Define.USERDEFAULT.set(userData["isRedeem"], forKey: "isRedeem")
        
        
        let setNotification = userData["setNotification"] as? Bool ?? false
        Define.USERDEFAULT.set(setNotification, forKey: "SetNotification")
        
        let dictAmount = userData["wallateDetails"] as! [String: Any]
        
        Define.USERDEFAULT.set(dictAmount["pbAmount"] as? Double ?? 0.0, forKey: "PBAmount")
        Define.USERDEFAULT.set(dictAmount["sbAmount"] as? Double ?? 0.0, forKey: "SBAmount")
        Define.USERDEFAULT.set(dictAmount["tbAmount"] as? Double ?? 0.0, forKey: "TBAmount")
        Define.USERDEFAULT.set(dictAmount["ccAmount"] as? Double ?? 0.0, forKey: "ccAmount")
        
        let walletAuth = dictAmount["WalletAuth"] as! Int
                            UserDefaults.standard.set(walletAuth, forKey: "WalletAuth")
        
        let isBankVerify = userData["verify_bank"] as? Bool ?? false
        
        Define.USERDEFAULT.set(userData["verify_pan"] as? Int ?? 0, forKey: "IsPanVerify")
        Define.USERDEFAULT.set(isBankVerify, forKey: "IsBankVerify")
        
        let isEmailVerify = userData["verify_email"] as? Bool ?? false
        Define.USERDEFAULT.set(isEmailVerify, forKey: "IsEmailVerify")
    }
    
    func removeUserData() {
        Define.USERDEFAULT.set(false, forKey: "isLogin")
        Define.USERDEFAULT.set(false, forKey: "isSocialLogin")
        Define.USERDEFAULT.set(false, forKey: "isMobileOtpLogin")
        Define.USERDEFAULT.removeObject(forKey: "AccessToken")
        Define.USERDEFAULT.removeObject(forKey: "Password")
        Define.USERDEFAULT.removeObject(forKey: "UserID")
        Define.USERDEFAULT.removeObject(forKey: "UserName")
        Define.USERDEFAULT.removeObject(forKey: "Email")
        Define.USERDEFAULT.removeObject(forKey: "UserCode")
        Define.USERDEFAULT.removeObject(forKey: "UserMobile")
        Define.USERDEFAULT.removeObject(forKey: "ProfileImage")
        Define.USERDEFAULT.removeObject(forKey: "PBAmount")
        Define.USERDEFAULT.removeObject(forKey: "SBAmount")
        Define.USERDEFAULT.removeObject(forKey: "TBAmount")
        Define.USERDEFAULT.removeObject(forKey: "ccAmount")
        Define.USERDEFAULT.removeObject(forKey: "SetNotification")
        Define.USERDEFAULT.removeObject(forKey: "IsPanVerify")
        Define.USERDEFAULT.removeObject(forKey: "IsBankVerify")
       
    }
    
    func isLogedIn() -> Bool {
        if Define.USERDEFAULT.bool(forKey: "isLogin") {
            return true
        } else {
            return false
        }
    }
    
    func checkAmount(amount: Double) -> Bool {
        let pbAmount = Define.USERDEFAULT.value(forKey: "PBAmount") as? Double ?? 0.0
        let tbAmount = Define.USERDEFAULT.value(forKey: "SBAmount") as? Double ?? 0.0
        
        let totalAmount = pbAmount + tbAmount
        if  totalAmount < amount {
            return false
        } else {
            return true
        }
    }
    
    
    func getImageForSlider(range: Int) -> UIImage  {
        print(range)
        if range <= 40 {
            return UIImage(named: "ic_bar20")!
        } else if range > 40 && range <= 75 {
            return UIImage(named: "ic_bar30")!
        } else if range > 75 && range <= 125 {
            return UIImage(named: "ic_bar40")!
        } else if range > 125 && range <= 150 {
            return UIImage(named: "ic_bar50")!
        } else if range > 150 && range <= 175 {
            return UIImage(named: "ic_bar60")!
        } else if range > 175 && range <= 200 {
            return UIImage(named: "ic_bar70")!
        } else if range > 200 && range <= 225 {
            return UIImage(named: "ic_bar80")!
        } else if range > 225 && range <= 275 {
            return UIImage(named: "ic_bar90")!
        } else if range > 275 && range <= 325 {
            return UIImage(named: "ic_bar100")!
        } else if range > 325 && range <= 375 {
            return UIImage(named: "ic_bar110")!
        } else if range > 375 && range <= 425 {
            return UIImage(named: "ic_bar120")!
        } else if range > 425 && range <= 475 {
            return UIImage(named: "ic_bar130")!
        } else if range > 475 && range <= 525 {
            return UIImage(named: "ic_bar140")!
        } else if range > 525 && range <= 600 {
            return UIImage(named: "ic_bar150")!
        } else if range > 600 && range <= 800 {
            return UIImage(named: "ic_bar175")!
        } else {
            return UIImage(named: "ic_bar200")!
        }
    }
    
    func getImageForRange(range: Int, rangeMaxValue: Int) -> UIImage {
        var rangeGap = Int()
        if range == 0 {
            rangeGap = 2
        } else {
            rangeGap = Int(100 / (rangeMaxValue / range))
        }
        
        if rangeGap <= 2 {
            return UIImage(named: "ic_bar70")!
        } else if  rangeGap > 2 && rangeGap <= 4 {
            return UIImage(named: "ic_bar40")!
        } else if  rangeGap > 4 && rangeGap <= 6 {
            return UIImage(named: "ic_bar45")!
        } else if  rangeGap > 6 && rangeGap <= 8 {
            return UIImage(named: "ic_bar50")!
        } else if  rangeGap > 8 && rangeGap <= 10 {
            return UIImage(named: "ic_bar55")!
        } else if  rangeGap > 10 && rangeGap <= 12 {
            return UIImage(named: "ic_bar60")!
        } else if  rangeGap > 12 && rangeGap <= 14 {
            return UIImage(named: "ic_bar65")!
        } else if  rangeGap > 14 && rangeGap <= 16 {
            return UIImage(named: "ic_bar70")!
        } else if  rangeGap > 16 && rangeGap <= 18 {
            return UIImage(named: "ic_bar80")!
        } else if  rangeGap > 18 && rangeGap <= 20 {
            return UIImage(named: "ic_bar90")!
        } else if  rangeGap > 20 && rangeGap <= 24 {
            return UIImage(named: "ic_bar100")!
        } else if  rangeGap > 24 && rangeGap <= 28 {
            return UIImage(named: "ic_bar110")!
        } else if  rangeGap > 28 && rangeGap <= 32 {
            return UIImage(named: "ic_bar120")!
        } else if  rangeGap > 32 && rangeGap <= 36 {
            return UIImage(named: "ic_bar130")!
        } else if  rangeGap > 36 && rangeGap <= 40 {
            return UIImage(named: "ic_bar140")!
        } else if  rangeGap > 40 && rangeGap <= 44 {
            return UIImage(named: "ic_bar150")!
        } else if  rangeGap > 44 && rangeGap <= 48 {
            return UIImage(named: "ic_bar175")!
        } else if  rangeGap > 48 && rangeGap <= 52 {
            return UIImage(named: "ic_bar200")!
        } else if  rangeGap > 52 && rangeGap <= 56 {
            return UIImage(named: "ic_bar250")!
        } else if  rangeGap > 56 && rangeGap <= 60 {
            return UIImage(named: "ic_bar275")!
        } else {
            return UIImage(named: "ic_bar300")!
        }
    }
    
    func getAnserRange(strMode: String) -> [String] {
        var arrAnswerData = [String]()
        
//        if strMode == "1" {
//            arrAnswerData.append(PrivateContest.arrRangeData[0].displayValue)
//        } else if strMode == "2"{
//            arrAnswerData.append(PrivateContest.arrRangeData[0].displayValue)
//            arrAnswerData.append(PrivateContest.arrRangeData[1].displayValue)
//            arrAnswerData.append(PrivateContest.arrRangeData[2].displayValue)
//        } else if strMode == "3" {
//            arrAnswerData.append(PrivateContest.arrRangeData[0].displayValue)
//            arrAnswerData.append(PrivateContest.arrRangeData[1].displayValue)
//            arrAnswerData.append(PrivateContest.arrRangeData[2].displayValue)
//        }
        arrAnswerData.append(PrivateContest.arrRangeData[0].displayValue)
        arrAnswerData.append(PrivateContest.arrRangeData[1].displayValue)
        arrAnswerData.append(PrivateContest.arrRangeData[2].displayValue)
        
        return arrAnswerData
    }
    
    func getSecound(currentTime: Date, startDate: Date) -> Int {
        let currentMiliSecond = currentTime.timeIntervalSince1970
        let startMiliSecound = startDate.timeIntervalSince1970
        
        return Int(startMiliSecound - currentMiliSecond)
    }
    
    func isSetNA(totalTickets: Int,minJoin:Int) -> Bool {
//        if totalTickets == 0 || totalTickets == 1 {
//            return true
//        }
        if totalTickets < minJoin {
            return true
        }
        return false
    }
    
//    func isSetNA(totalTickets: Int,minJoin:Int) -> Bool {
//        if totalTickets == 0 || totalTickets == 1 {
//            return true
//        }
//        return false
//    }
    
}

//MARK: - Attributed String
extension NSMutableAttributedString{
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 20),NSAttributedString.Key.foregroundColor: UIColor.black]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18),
                                                    NSAttributedString.Key.foregroundColor: UIColor.black]
        let normalString = NSAttributedString(string: text, attributes: attrs)
        append(normalString)
        
        return self
    }
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}


extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

extension String
{
    func trim() -> String
   {
    return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
   }
}
