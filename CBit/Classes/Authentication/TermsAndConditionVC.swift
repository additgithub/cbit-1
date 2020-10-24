import UIKit
import WebKit

class TermsAndConditionVC: UIViewController {

    @IBOutlet weak var webViewTermsAndCondition: WKWebView!
    @IBOutlet weak var progressTermsAndCondition: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewTermsAndCondition.uiDelegate = self
        webViewTermsAndCondition.load(URLRequest(url: URL(string: Define.AAPINFO_URL)!))
        
    }
    
    //MARK: - Button Method
    @IBAction func buttonMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - WebView Delegate Method
extension TermsAndConditionVC: WKUIDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
 
        progressTermsAndCondition.setProgress(0.1, animated: false)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
progressTermsAndCondition.setProgress(1.0, animated: true)
    }
}
