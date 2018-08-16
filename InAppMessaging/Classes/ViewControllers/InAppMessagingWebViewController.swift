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
    var toolbar: UIToolbar!
    
    var uri: String = ""
    
    // To handle iPhone X un-safe areas.
    var topSafeArea: CGFloat = 0
    var bottomSafeArea: CGFloat = 0
    
    var currentHeight: CGFloat = 0
    var toolBarOffset: CGFloat = 0
    
    convenience init(uri: String) {
        self.init()
        self.uri = uri
    }
    
    override func loadView() {
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        // To handle iPhone X un-safe areas.
        setUpSafeArea()
        
        // Navigation bar.
        setUpNavigationBar()
        
        // Progress view.
        setUpProgressView()
        
        // Tool bar.
        setUpToolBar()

        // Web view.
        setUpWebView()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func didTapOnWebViewDoneButton() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            
            if webView.estimatedProgress == 1.0 {
                progressView.removeFromSuperview()
            }
        }
    }
    
    fileprivate func setUpSafeArea() {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow?.safeAreaInsets
            if let topPadding = window?.top,
                let bottomPadding = window?.bottom {
                self.topSafeArea = topPadding
                self.bottomSafeArea = bottomPadding
                self.currentHeight += topSafeArea
                self.toolBarOffset += bottomSafeArea
            }
        }
        
        self.currentHeight = (self.currentHeight == 0) ? 20 : self.currentHeight
        self.toolBarOffset = (self.toolBarOffset == 0) ? 44 : self.toolBarOffset + 44
    }
    
    fileprivate func setUpNavigationBar() {
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: self.currentHeight, width: UIScreen.main.bounds.width, height: 44))
        navigationBar.isTranslucent = false
        let navItem = UINavigationItem(title: uri);
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(didTapOnWebViewDoneButton));
        navItem.rightBarButtonItem = doneItem;
        navigationBar.setItems([navItem], animated: true);
        self.view.addSubview(navigationBar);
        
        self.currentHeight += navigationBar.frame.size.height
    }
    
    fileprivate func setUpProgressView() {
        self.progressView = UIProgressView(progressViewStyle: .default)
        self.progressView.frame.size.width = UIScreen.main.bounds.width
        self.progressView.frame.origin.y = self.currentHeight - 2
        self.view.addSubview(self.progressView)
    }
    
    fileprivate func setUpToolBar() {
        self.toolbar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - self.toolBarOffset, width: UIScreen.main.bounds.width, height: toolBarOffset))
        self.toolbar.isTranslucent = false
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let backButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(didTapOnWebViewDoneButton))
        let forwardButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(didTapOnWebViewDoneButton))
        let refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        let actionButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
        self.toolbar.setItems([backButton, space, forwardButton, space, refreshButton, space, actionButton], animated: true)
        
        self.view.addSubview(self.toolbar)
    }
    
    fileprivate func setUpWebView() {
        self.webView = WKWebView(
            frame: CGRect(x: 0,
                          y: self.currentHeight,
                          width: UIScreen.main.bounds.width,
                          height: UIScreen.main.bounds.height - self.currentHeight - self.toolbar.frame.size.height),
            configuration: WKWebViewConfiguration())
        
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.uiDelegate = self
        
        guard let url = URL(string: self.uri) else {
            #if DEBUG
            print("InAppMessaging: Invalid URI.")
            #endif
            
            return
        }
        
        webView.load(URLRequest(url: url))
        self.view.addSubview(self.webView)
    }
    
    
    deinit {
        //remove all observers
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        //remove progress bar from navigation bar
        progressView.removeFromSuperview()
    }
}
