//
//  WebViewController.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 8/14/18.
//

import WebKit

class InAppMessagingWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var uri: String = ""
    
    convenience init(uri: String) {
        self.init()
        self.uri = uri
    }
    
    override func loadView() {
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar.
        let navBar: UINavigationBar =
            UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        
        navBar.isTranslucent = false
        let navItem = UINavigationItem(title: uri);
        let doneItem = UIBarButtonItem(barButtonSystemItem: .stop , target: nil, action: #selector(didTapOnWebViewStopButton));
        navItem.rightBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: true);
        self.view.addSubview(navBar);
        
        // Web view.
        self.webView = WKWebView(
            frame: CGRect(x: 0,
                          y: navBar.frame.size.height,
                          width: UIScreen.main.bounds.width,
                          height: UIScreen.main.bounds.height),
            configuration: WKWebViewConfiguration())
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.webView.uiDelegate = self
        
        // Progress bar.
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame.size.width = UIScreen.main.bounds.width
        progressView.frame.origin.y = navBar.frame.size.height - 2
        self.view.addSubview(progressView)

        self.view.addSubview(self.webView)
        
        guard let url = URL(string: self.uri) else {
            #if DEBUG
                print("InAppMessaging: Invalid URI.")
            #endif
            
            return
        }
        webView.load(URLRequest(url: url))
        
        webView.allowsBackForwardNavigationGestures = true
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func didTapOnWebViewStopButton() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            if webView.estimatedProgress == 1.0 {
                progressView.removeFromSuperview()
            }
        }
    }
    
    deinit {
        //remove all observers
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        //remove progress bar from navigation bar
        progressView.removeFromSuperview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
