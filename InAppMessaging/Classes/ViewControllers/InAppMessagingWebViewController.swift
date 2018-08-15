//
//  WebViewController.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 8/14/18.
//

import WebKit

class InAppMessagingWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIBarPositioningDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var navigationBar: UINavigationBar!
    
    var uri: String = ""
    
    // To handle iPhone X un-safe areas.
    var topSafeArea: CGFloat = 0
    var bottomSafeArea: CGFloat = 0
    
    var currentHeight: CGFloat = 0
    
    convenience init(uri: String) {
        self.init()
        self.uri = uri
    }
    
    override func loadView() {
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        // To handle iPhone X un-safe areas.
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow?.safeAreaInsets
            if let topPadding = window?.top,
                let bottomPadding = window?.bottom {
                    self.topSafeArea = topPadding
                    self.bottomSafeArea = bottomPadding
                    self.currentHeight += topSafeArea
            }
        }
        
        print("After offset: \(self.currentHeight)")
        
        // Navigation bar.
//        let navBarOffset = self.currentHeight == 0 ? 20 : self.currentHeight
        
        self.currentHeight = (self.currentHeight == 0) ? self.currentHeight + 20 : self.currentHeight

        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: self.currentHeight, width: UIScreen.main.bounds.width, height: 44))
        navigationBar.isTranslucent = false
        
        let navItem = UINavigationItem(title: uri);
        let doneItem = UIBarButtonItem(barButtonSystemItem: .stop , target: nil, action: #selector(didTapOnWebViewStopButton));
        navItem.rightBarButtonItem = doneItem;
        navigationBar.setItems([navItem], animated: true);
        
        self.view.addSubview(navigationBar);


        self.currentHeight += navigationBar.frame.size.height

        print("After nav bar: \(self.currentHeight)")
        
        // Progress bar.
        self.progressView = UIProgressView(progressViewStyle: .default)
        self.progressView.frame.size.width = UIScreen.main.bounds.width
        self.progressView.frame.origin.y = self.currentHeight - 2
        self.view.addSubview(self.progressView)


        // Web view.
        self.webView = WKWebView(
            frame: CGRect(x: 0,
                          y: self.currentHeight,
                          width: UIScreen.main.bounds.width,
                          height: UIScreen.main.bounds.height - self.currentHeight),
            configuration: WKWebViewConfiguration())

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.webView.uiDelegate = self

        self.view.addSubview(self.webView)

        guard let url = URL(string: self.uri) else {
            #if DEBUG
                print("InAppMessaging: Invalid URI.")
            #endif

            return
        }
        webView.load(URLRequest(url: url))

        webView.allowsBackForwardNavigationGestures = true

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
