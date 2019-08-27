import WebKit

/**
 * Protocol for any IAM Views that are capable of supporting rich content.
 */
protocol RichContentBrowsable {
    func createWebView(withHtmlString htmlString: String, andFrame frame: CGRect) -> WKWebView
}

extension RichContentBrowsable {
    func createWebView(withHtmlString htmlString: String, andFrame frame: CGRect) -> WKWebView {
        let webView = WKWebView()
        
        webView.loadHTMLString(htmlString, baseURL: nil)
        webView.frame = frame
    
        return webView
    }
}
