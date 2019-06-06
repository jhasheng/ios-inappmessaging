import UIKit

/**
 * Protocol to define the IAM view.
 */
protocol NewIAMView: ImpressionTrackable {
    func show()
    func dismiss()
    func appendSubViews()
    func initializeView()
    func appendImageView(withImage image: UIImage)
    func createMessageBody(withCampaign campaign: CampaignData)
    func appendHeaderMessage(withHeader headerMessage: String)
    var backgroundView: UIView? { get }
    var dialogView: UIView { get set }
    var textView: UITextView? { get set }
    var image: UIImage? { get set }
    var dialogViewWidth: CGFloat { get set }
    var dialogViewCurrentHeight: CGFloat { get }
    var textViewCurrentHeight: CGFloat { get }
    var horizontalSpacingOffset: CGFloat { get }
    
}

extension NewIAMView where Self: UIView {
//    var backgroundView: UIView? { return nil } // Not all views will be using a background view.
//    var image: UIImage? { return nil }
//    var textView: UITextView? { return nil }
    
    var dialogViewCurrentHeight: CGFloat {
        get {
            var height: CGFloat = 0
            for subview in self.dialogView.subviews {
                height += subview.bounds.height
            }
            
            return height
        }
    }
    
    var textViewCurrentHeight: CGFloat {
        get {
            var height: CGFloat = 0
            if let textView = self.textView {
                for subview in textView.subviews {
                    height += subview.bounds.height
                }
            }
            
            return height
        }
    }
    
    /**
     * Function that finds the presented view controller and add the modal sub view on top.
     */
    func show() {
        if let window =  UIApplication.shared.keyWindow {
            InAppMessagingViewController.isRunning = true
            window.addSubview(self)
        }
    }
    
    /**
     * Function that dismisses the presented IAM view.
     */
    func dismiss() {
        removeFromSuperview()
        InAppMessagingViewController.isRunning = false
        
        WorkScheduler.scheduleTask(5000, closure: InAppMessagingViewController.display)
    }
    
    func initializeView() {
        backgroundColor = .black // TODO: change to white
        
        // See if image exist
        if let image = self.image {
            appendImageView(withImage: image)
        }
        
        if let campaign = self.campaign {
            createMessageBody(withCampaign: campaign)
        }
        
        appendSubViews()
    }
    
    func appendImageView(withImage image: UIImage) {
        // Image ratio to calculate the height.
        let imageRatio = self.dialogViewWidth / image.size.width
        
        let imageView = UIImageView(
            frame: CGRect(x: 0,
                          y: dialogViewCurrentHeight,
                          width: dialogViewWidth,
                          height: image.size.height * imageRatio))
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        self.dialogView.addSubview(imageView)

    }
    
    func createMessageBody(withCampaign campaign: CampaignData) {
        // Scroll view for header and messages.
        if campaign.messagePayload.header != nil ||
            campaign.messagePayload.messageBody != nil {
            
            // Align TextView to the center of the available space
            appendTextView(withMessage: campaign.messagePayload)
            
            
        }
    }
    
    func appendTextView(withMessage messagePayload: MessagePayload) {
        
        guard let textView = self.textView else {
            return
        }
        
        // Change textview background color.
        textView.backgroundColor = UIColor(hexFromString: messagePayload.backgroundColor)
        
        // Header title.
        if let headerMessage = messagePayload.header {
            appendHeaderMessage(withHeader: headerMessage)
        }
        
        textView.frame = CGRect(x: horizontalSpacingOffset,
                                      y: dialogViewCurrentHeight,
                                      width: bounds.size.width - (horizontalSpacingOffset * 2),
                                      height: bounds.size.height - dialogViewCurrentHeight - 50)
        
        textView.contentSize.height = textViewCurrentHeight
        textView.isEditable = false
//
        self.dialogView.addSubview(textView)
    }
    
    func appendHeaderMessage(withHeader headerMessage: String) {
        let headerMessageLabel = UILabel(
            frame: CGRect(x: 0,
                          y: textViewCurrentHeight,
                          width: bounds.size.width - (horizontalSpacingOffset * 2),
                          height: 0))
        
        headerMessageLabel.text = headerMessage
        headerMessageLabel.setLineSpacing(lineSpacing: 3.0)
        headerMessageLabel.textAlignment = .center
        headerMessageLabel.lineBreakMode = .byWordWrapping
        headerMessageLabel.numberOfLines = 0
        headerMessageLabel.font = .boldSystemFont(ofSize: 16)
        headerMessageLabel.frame.size.height = headerMessageLabel.optimalHeight
        textView!.addSubview(headerMessageLabel)
        
    }
    
    
     func appendSubViews() {
        self.addSubview(dialogView)
        logImpression(withImpressionType: .IMPRESSION)
    }
}
