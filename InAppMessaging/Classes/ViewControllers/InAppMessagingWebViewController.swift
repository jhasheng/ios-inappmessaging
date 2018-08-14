//
//  WebViewController.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 8/14/18.
//

import WebKit

class InAppMessagingWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nav bar
        let navBar: UINavigationBar =  UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.09))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "SomeTitle");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: "selector");
        navItem.rightBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: false);
        
        // Web view
        webView = WKWebView(frame: CGRect(x: 0, y: navBar.frame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        self.view.addSubview(webView)

        
        let url = URL(string: "https://google.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

//        let myWebView:UIWebView = UIWebView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//
//
//        myWebView.delegate = self as? UIWebViewDelegate
//        self.view.addSubview(myWebView)
//        let url = URL (string: "https://google.com");
//        let request = URLRequest(url: url! as URL);
//        myWebView.loadRequest(request);
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
