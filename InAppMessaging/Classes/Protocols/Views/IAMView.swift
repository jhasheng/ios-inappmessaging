/**
 * Base protocol that defines all of IAM's supported campaign views.
 */
protocol IAMView: ImpressionTrackable {
    var viewIdentifier: String { get }
    
    func show()
    func dismiss()
}

extension IAMView where Self: UIView {
    var viewIdentifier: String { return "IAMView" }

    /**
     * Function that handles the login for displaying Modal/Fullscreen IAM views.
     */
    func show() {
        displayView()
    }
    
    /**
     * Function that finds the presented view controller and add the IAMView on top.
     */
    func displayView() {
        self.accessibilityIdentifier = viewIdentifier
        
        // Check to see if any other IAMViews are presented.
        if let subviews = UIApplication.shared.keyWindow?.subviews {
            for subview in subviews {
                if subview.accessibilityIdentifier == viewIdentifier {
                    return
                }
            }
        }
        
        if let window =  UIApplication.shared.keyWindow {
            window.addSubview(self)
        }
    }
    
    /**
     * Function that dismisses the presented IAM view.
     */
    func dismiss() {
        self.removeFromSuperview()
        WorkScheduler.scheduleTask(Constants.Configuration.milliBetweenDisplays, closure: InAppMessagingViewController.display)
    }
}
