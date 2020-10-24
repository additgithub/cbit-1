import UIKit
import Alamofire

class SwiftAPI: NSObject {

    // MARK: - GET Function.
    func getMethod(stringURL: String, callBack: @escaping (_ result: Dictionary<String, Any>?, _ error: Error?) -> ()) {
        Alamofire.request(stringURL).responseJSON { response in
            switch response.result {
            case .success:
                let dictResult: Dictionary = response.value as! [String : AnyObject]
                callBack(dictResult,nil)
            case .failure(let encodingError):
                callBack(nil, encodingError)
            }
        }
    }
    
    // MARK: - POST Function.
    func postMethod(stringURL: String, parameters: Parameters?, header: String?, auther: String?, callBack: @escaping (_ result: Dictionary<String, Any>?, _ error: Error?) -> ()){
        var headers: HTTPHeaders?
        if header == nil {
            headers = nil
        }else{
            headers = ["Content-Type": "application/x-www-form-urlencoded",
                       "Authorization": header!,
                       "Author": auther!]
        }
        Alamofire.request(stringURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{
            response in
            switch response.result {
            case .success:
                let dictresult: Dictionary = response.value as! [String : Any]
                callBack(dictresult, nil)
            case .failure(let encodingError):
                callBack(nil, encodingError)
            }
        }
    }
    
    func postMethodSecure(stringURL: String, parameters: Parameters?, header: String?, auther: String?, callBack: @escaping (_ result: Dictionary<String, Any>?, _ error: Error?) -> ()){
        var headers: HTTPHeaders?
        if header == nil {
            headers = nil
        }else{
            headers = ["Content-Type": "application/x-www-form-urlencoded",
                       "Authorization": header!,
                       "Author": auther!]
        }
        Alamofire.request(stringURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseString { response in
            switch response.result {
            case .success:
                let strResult = response.value
                print("-----------------\nResult\(strResult!)")
                let strJSON = MyModel().decrypting(strData: strResult!, strKey: Define.KEY)
                let dictData = MyModel().convertToDictionary(text: strJSON)
                
                callBack(dictData, nil)
            case .failure(let encodingError):
                callBack(nil, encodingError)
            }
        }
    }
    func getMethodSecure(stringURL: String, parameters: Parameters?, header: String?, auther: String?, callBack: @escaping (_ result: Dictionary<String, Any>?, _ error: Error?) -> ()){
           var headers: HTTPHeaders?
           if header == nil {
               headers = nil
           }else{
               headers = ["Content-Type": "application/x-www-form-urlencoded",
                          "Authorization": header!,
                          "Author": auther!]
           }
           Alamofire.request(stringURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseString { response in
               switch response.result {
               case .success:
                   let strResult = response.value
                   print("-----------------\nResult\(strResult!)")
                   let strJSON = MyModel().decrypting(strData: strResult!, strKey: Define.KEY)
                   let dictData = MyModel().convertToDictionary(text: strJSON)
                   
                   callBack(dictData, nil)
               case .failure(let encodingError):
                   callBack(nil, encodingError)
               }
           }
       }
    // MARK: - POST With Image Fuction.
    func postImageUplod(stringURL: String, parameters: Parameters?, header: String?, auther: String?, imageName: String?, imageData: Data?, callBack: @escaping (_ result: Dictionary<String, Any>?, _ error: Error?) -> ()){
        var headers: HTTPHeaders?
        if header == nil {
            headers = nil
        }else{
            headers = ["Content-Type": "application/x-www-form-urlencoded",
                       "Authorization": header!,
                       "Author": auther!]
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if parameters != nil {
                for (key, value) in parameters! {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            
            if let imgData = imageData {
                multipartFormData.append(imgData, withName: imageName!, fileName: "Tiger.jpg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: stringURL, method: .post, headers: headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let dictresult: Dictionary = response.value as! [String : Any]
                    callBack(dictresult, nil)
                }
            case .failure(let encodingError):
                print(encodingError)
                callBack(nil, encodingError)
            }
        })
    }
    
    func postImageUplodSecure(stringURL: String, parameters: Parameters?, header: String?, auther: String?, imageName: String?, imageData: Data?, callBack: @escaping (_ result: Dictionary<String, Any>?, _ error: Error?) -> ()){
        var headers: HTTPHeaders?
        if header == nil {
            headers = nil
        }else{
            headers = ["Content-Type": "application/x-www-form-urlencoded",
                       "Authorization": header!,
                       "Author": auther!]
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if parameters != nil {
                for (key, value) in parameters! {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            
            if let imgData = imageData {
                multipartFormData.append(imgData, withName: imageName!, fileName: "Tiger.jpg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: stringURL, method: .post, headers: headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseString { response in
                     let strResult = response.value
                    print("Result: ",response.value!)
                    let strJSON = MyModel().decrypting(strData: strResult!, strKey: Define.KEY)
                    let dictData = MyModel().convertToDictionary(text: strJSON)
                    
                    callBack(dictData, nil)
                }
            case .failure(let encodingError):
                print(encodingError)
                callBack(nil, encodingError)
            }
        })
    }
    
    func setPingAPI() {
        let url = URL(string: "\(Define.APP_URL)checkNetwork")!
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringCacheData,
                                 timeoutInterval: 2)
        let task = URLSession.shared.dataTask(with: request) { (data, urlSession, error) in
            if error == nil {
                print("Success")
            } else {
                print("Failure")
            }
        }
        task.resume()
    }
}
