import UIKit
import WebKit
class AboutUsVC: UIViewController {
    
    //MARK: - Properties
  
    
    @IBOutlet weak var webViewAboutUs: WKWebView!
    
    @IBOutlet weak var progressAboutUs: UIProgressView!
    
    //MARK: - Default Method
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewAboutUs.uiDelegate = self
        setAboutUs()
    }
    
    func setAboutUs() {
        webViewAboutUs.load(URLRequest(url: URL(string: "http://cbitoriginal.com")!))
    }
    
    //MARK: - Button Method
    @IBAction func buttonMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - WebView Delegate Method
extension AboutUsVC: WKUIDelegate {
   func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
         progressAboutUs.setProgress(0.1, animated: false)
      }
      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
          progressAboutUs.setProgress(1.0, animated: true)
      }
}
