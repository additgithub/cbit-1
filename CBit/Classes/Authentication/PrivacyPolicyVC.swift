import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController {
    
  
    
    
    @IBOutlet weak var webViewPrivacyPolicy: WKWebView!
    
    @IBOutlet weak var progressPrivacyPilicy: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewPrivacyPolicy.uiDelegate = self
        webViewPrivacyPolicy.load(URLRequest(url: URL(string: Define.PRIVACYPOLICY_URL)!))
    }
    
    
    
    //MARK: - Button Method
    @IBAction func buttonMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - WebView Delegate Method
extension PrivacyPolicyVC: WKUIDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
       progressPrivacyPilicy.setProgress(0.1, animated: false)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressPrivacyPilicy.setProgress(1.0, animated: true)
    }
}
