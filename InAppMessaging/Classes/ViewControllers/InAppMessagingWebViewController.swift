import WebKit

/**
 * Class to initialize any webview created by InAppMessaging.
 */
class InAppMessagingWebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var navigationBar: UINavigationBar!
    var navItem: UINavigationItem!
    var toolbar: UIToolbar!
    var backButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    
    // Uri of the page to display.
    var uri: String = ""
    
    // Handles iPhone X un-safe areas.
    var topSafeArea: CGFloat = 0
    var bottomSafeArea: CGFloat = 0
    
    // Handles screen size responsiveness.
    var currentHeight: CGFloat = 0
    var toolBarOffset: CGFloat = 0
    
    convenience init(uri: String) {
        self.init()
        self.uri = uri
    }
    
    override func loadView() {
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.backgroundColor = .white
        
        // To handle iPhone X un-safe areas.
        self.setUpSafeArea()
        
        // Navigation bar.
        self.setUpNavigationBar()
        
        // Progress view.
        self.setUpProgressView()
        
        // Tool bar.
        self.setUpToolBar()
        
        // Web view.
        self.setUpWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    // WKNavigationDelegates.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.forwardButton.isEnabled = self.webView.canGoForward
        self.backButton.isEnabled = self.webView.canGoBack
        self.progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        // Update current URL of the site that is displaying.
        if let currentUrl = webView.url {
            self.uri = currentUrl.absoluteString
        }
        
        self.progressView.isHidden = false
    }
    
    // Observers.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(webView.estimatedProgress)
        }
        
        if keyPath == "title" {
            if let title = change?[NSKeyValueChangeKey.newKey] as? String {
                self.navItem.title = title
            }
            
            return
        }
    }
    
    // Web view setup.
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
        self.navigationBar = UINavigationBar(frame: CGRect(x: 0, y: self.currentHeight, width: UIScreen.main.bounds.width, height: 44))
        self.navigationBar.isTranslucent = false
        self.navItem = UINavigationItem(title: uri);
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(didTapOnWebViewDoneButton));
        self.navItem.rightBarButtonItem = doneItem;
        self.navigationBar.setItems([self.navItem], animated: true);
        self.view.addSubview(navigationBar);
        
        self.currentHeight += self.navigationBar.frame.size.height
    }
    
    fileprivate func setUpProgressView() {
        self.progressView = UIProgressView(progressViewStyle: .default)
        self.progressView.frame.size.width = UIScreen.main.bounds.width
        self.progressView.frame.origin.y = self.currentHeight - 2
        self.view.addSubview(self.progressView)
    }
    
    fileprivate func setUpToolBar() {
        self.toolbar = UIToolbar(frame: CGRect(x: 0,
                                               y: UIScreen.main.bounds.height - self.toolBarOffset,
                                               width: UIScreen.main.bounds.width,
                                               height: self.toolBarOffset))
        
        self.toolbar.isTranslucent = false
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.backButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(didTapOnBackButton))
        self.backButton.isEnabled = false
        self.forwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(didTapOnForwardButton))
        self.forwardButton.isEnabled = false
        let refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapOnRefreshButton))
        let actionButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapOnActionButton))
        self.toolbar.setItems([self.backButton, space, self.forwardButton, space, refreshButton, space, actionButton], animated: true)
        
        self.view.addSubview(self.toolbar)
    }
    
    fileprivate func setUpWebView() {
        self.webView = WKWebView(
            frame: CGRect(x: 0,
                          y: self.currentHeight,
                          width: UIScreen.main.bounds.width,
                          height: UIScreen.main.bounds.height - self.currentHeight - self.toolbar.frame.size.height),
            configuration: WKWebViewConfiguration())
        
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.navigationDelegate = self
        
        guard let url = URL(string: self.uri) else {
            #if DEBUG
            print("InAppMessaging: Invalid URI.")
            #endif
            
            return
        }
        
        webView.load(URLRequest(url: url))
        self.view.addSubview(self.webView)
    }
    
    // Button selectors for webviews.
    @objc func didTapOnActionButton(sender: UIView) {
        let textToShare = self.uri
        let objectsToShare = [textToShare] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .saveToCameraRoll, .print, .assignToContact]
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func didTapOnWebViewDoneButton() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func didTapOnBackButton() {
        if self.webView.canGoBack && self.webView.url != nil {
            self.webView.goBack()
            self.webView.reload()
        }
    }
    
    @objc fileprivate func didTapOnForwardButton() {
        if self.webView.canGoForward && self.webView.url != nil {
            self.webView.goForward()
            self.webView.reload()
        }
    }
    
    @objc fileprivate func didTapOnRefreshButton() {
        if self.webView.url != nil {
            self.webView.reload()
        }
    }
    
    // Clean up.
    deinit {
        self.webView.removeObserver(self, forKeyPath: "title")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.progressView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
