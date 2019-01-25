import UIKit
import SDWebImage

/**
 * Class that initializes the modal view using the passed in campaign information to build the UI.
 */
class ModalView: UIView, Modal, ImpressionTrackable {

    var impressions: [Impression] = []
    var properties: [Property] = []
    var campaign: CampaignData?

    let heightOffset: CGFloat = 8 // Height offset for every UI element.
    let exitButtonHeightOffset: CGFloat = 30 // Height offset for exit button from the actual message.
    let exitButtonSize: CGFloat = 20 // Size of the exit button.
    
    var backgroundView = UIView()
    var dialogView = UIView()
    
    // Field obtained from button behavior payload.
    var uri: String?
    
    // Boolean to change when the SDK will display the modal view.
    // Will change to true if campaign has an image URL.
    // If true, display after image has finish downloading.
    // If false, display after everything else is built.
    var hasImage = false
    
    // Spacing on the left and right side of subviews.
    var dialogViewWidth: CGFloat = 0
    
    // Counter of the height to dynamically set the height of the dialog view.
    // Will increment as more subviews are populated.
    var dialogViewCurrentHeight: CGFloat = 0
    
    convenience init(_ campaign: CampaignData) {
        self.init(frame: UIScreen.main.bounds)
        self.campaign = campaign
        self.initialize(campaign: campaign)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * Creates the modal view to be displayed using the campaign information.
     * @param { campaign: CampaignData } the campaign to be displayed.
     */
    internal func initialize(campaign: CampaignData) {
        // The opaque black background of modals.
        self.backgroundView.frame = frame
        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.66)
        
        // Set the initial width to -64 to leave spacing on the left and right side.
        self.dialogViewWidth = frame.width - 64
        
        // Image view.
        if let imageUrl = campaign.messagePayload.resource.imageUrl, !imageUrl.isEmpty {
            self.hasImage = true
            self.appendImageView(withUrl: imageUrl)
        } else {
            // Append some space between the exit button and header.
            self.dialogViewCurrentHeight += 20
        }

        // Header title.
        if let headerMessage = campaign.messagePayload.header {
            self.appendHeaderMessage(withHeader: headerMessage)
        }
        
        // Body message.
        if let bodyMessage = campaign.messagePayload.messageBody {
            self.appendBodyMessage(withBody: bodyMessage)
        }
        
        // Buttons.
        if let buttonList = campaign.messagePayload.messageSettings.controlSettings?.buttons, !buttonList.isEmpty {
            self.appendButtons(withButtonList: buttonList)
        }
        
        // The dialog view which is the rounded rectangle in the center.
        self.dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        self.dialogView.frame.size = CGSize(width: self.dialogViewWidth, height: self.dialogViewCurrentHeight)
        self.dialogView.backgroundColor = UIColor(hexFromString: campaign.messagePayload.backgroundColor)
        self.dialogView.layer.cornerRadius = 6
        self.dialogView.clipsToBounds = true
        self.dialogView.center  = self.center
        
        // The top right "X" button to dismiss.
        let exitButton = UILabel(
            frame: CGRect(x: dialogView.frame.maxX - exitButtonSize,
                          y: dialogView.frame.minY - exitButtonHeightOffset,
                          width: exitButtonSize,
                          height: exitButtonSize))
        
        exitButton.text = "X"
        exitButton.alpha = 1
        exitButton.backgroundColor = .white
        exitButton.textColor = .black
        exitButton.textAlignment = .center
        exitButton.isUserInteractionEnabled = true
        exitButton.layer.cornerRadius = exitButton.frame.width / 2
        exitButton.layer.masksToBounds = true
        exitButton.tag = ImpressionType.exitButton.rawValue
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnExitButton)))
        self.backgroundView.addSubview(exitButton)
        
        if !hasImage {
            self.appendSubViews()
        }
    }
    
    /**
     * Append image view to dialog view.
     * @param { imageUrl: String } string of the image URL.
     */
    fileprivate func appendImageView(withUrl imageUrl: String) {
        //TODO(Daniel Tam) Update aspect ratio here when finalized.
        let imageView = UIImageView(frame: CGRect(x: 0, y: self.dialogViewCurrentHeight, width: self.dialogViewWidth, height: self.dialogViewWidth / 1.3333))
        imageView.contentMode = .scaleAspectFit
        
        // URL encoding to read urls with space characters in the link.
        guard let encodedUrl = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        imageView.sd_setImage(with: URL(string: encodedUrl), placeholderImage: nil) { (image, error, SDImageCacheType, url) in
            self.appendSubViews()
        }
        
        self.dialogView.addSubview(imageView)
        
        self.dialogViewCurrentHeight += imageView.frame.height + heightOffset
    }
    
    /**
     * Append header message to dialog view.
     * @param { headerMessage: String } string of the header message.
     */
    fileprivate func appendHeaderMessage(withHeader headerMessage: String) {
        let headerMessageLabel = UILabel(frame: CGRect(x: 8, y: self.dialogViewCurrentHeight, width: self.dialogViewWidth - 16, height: 0))
        headerMessageLabel.text = headerMessage
        headerMessageLabel.textAlignment = .center
        headerMessageLabel.lineBreakMode = .byWordWrapping
        headerMessageLabel.numberOfLines = 0
        headerMessageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerMessageLabel.font = headerMessageLabel.font.withSize(20)
        headerMessageLabel.frame.size.height = headerMessageLabel.optimalHeight
        self.dialogView.addSubview(headerMessageLabel)
        
        self.dialogViewCurrentHeight += headerMessageLabel.frame.height + heightOffset
    }
    
    /**
     * Append body message to dialog view.
     * @param { bodyMessage: String } string of the body message.
     */
    fileprivate func appendBodyMessage(withBody bodyMessage: String) {
        let bodyMessageLabel = UILabel(frame: CGRect(x: 8, y: self.dialogViewCurrentHeight, width: self.dialogViewWidth - 16, height: 0))
        bodyMessageLabel.text = bodyMessage
        bodyMessageLabel.font = .boldSystemFont(ofSize: 14)
        bodyMessageLabel.textAlignment = .center
        bodyMessageLabel.lineBreakMode = .byWordWrapping
        bodyMessageLabel.numberOfLines = 0
        bodyMessageLabel.frame.size.height = bodyMessageLabel.optimalHeight
        self.dialogView.addSubview(bodyMessageLabel)
        
        self.dialogViewCurrentHeight += bodyMessageLabel.frame.height + heightOffset
    }
    
    /**
     * Append buttons to dialog view.
     * @param { buttonList: [Button] } list of Button data type.
     */
    fileprivate func appendButtons(withButtonList buttonList: [Button]) {
        
        var buttonHorizontalSpace: CGFloat = 8 // Space for the left and right margin.
        let buttonHeight: CGFloat = 30 // Define the height to use for the button.
        
        for (index, button) in buttonList.enumerated() {
            if let buttonAction = ButtonActionType(rawValue: button.buttonBehavior.action) {
                // Determine offset value based on numbers of buttons to display.
                let buttonWidthOffset: CGFloat = buttonList.count == 1 ? 16 : 12
                
                let buttonToAdd = UIButton(frame: CGRect(x: buttonHorizontalSpace,
                                                         y: self.dialogViewCurrentHeight,
                                                         width: ((self.dialogViewWidth / CGFloat(buttonList.count)) - buttonWidthOffset),
                                                         height: buttonHeight))
                
                buttonToAdd.setTitle(button.buttonText, for: .normal)
                buttonToAdd.setTitleColor(UIColor(hexFromString: button.buttonTextColor), for: .normal)
                buttonToAdd.titleLabel?.font = .boldSystemFont(ofSize: 14)
                buttonToAdd.layer.cornerRadius = 6
                buttonToAdd.tag = index == 0 ? ImpressionType.actionOneButton.rawValue : ImpressionType.actionTwoButton.rawValue
                buttonToAdd.backgroundColor = UIColor(hexFromString: button.buttonBackgroundColor)
                
                switch buttonAction {
                    case .invalid:
                        return
                    case .redirect:
                        self.uri = button.buttonBehavior.uri
                        buttonToAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnLink)))
                    case .deeplink:
                        self.uri = button.buttonBehavior.uri
                        buttonToAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnLink)))
                    case .close:
                        buttonToAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnExitButton)))
                }
                
                buttonHorizontalSpace += buttonToAdd.frame.width + 8
                
                self.dialogView.addSubview(buttonToAdd)
            }
        }
        
        self.dialogViewCurrentHeight += buttonHeight + heightOffset
    }
    
    /**
     * Append sub views to present view when ready.
     */
    fileprivate func appendSubViews() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.dialogView)
        logImpression(withImpressionType: .impression, withProperties: [])
    }
    
    // Button selectors for modal view.
    
    /**
     * Obj-c selector to handle both redirect and deeplink actions.
     * When the URL fails to validate through canOpenUrl() or is empty, an alert message will pop up
     * to warn about the navigation error.
     * NOTE: The openUrl() method used here is deprecated and is being used because the SDK has to support iOS 9.
     * When iOS 10 becomes the minimum version supported by the SDK, please refer to:
     * https://developer.apple.com/documentation/uikit/uiapplication/1648685-openurl?language=objc
     */
    @objc fileprivate func didTapOnLink(_ sender: UIGestureRecognizer){
        
        // To log and send impression.
        if let tag = sender.view?.tag,
            let type = ImpressionType(rawValue: tag) {
                logImpression(withImpressionType: type, withProperties: [])
                sendImpression()
        }
        
        if let unwrappedUri = self.uri,
            let uriToOpen = URL(string: unwrappedUri),
            UIApplication.shared.canOpenURL(uriToOpen) {
                UIApplication.shared.openURL(uriToOpen)
        } else {
            let alert = UIAlertController(title: "Page not found", message: "Encountered error while navigating to the page.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        }
        
        self.dismiss();
    }
    
    /**
     * Obj-c selector to dismiss the modal view when the 'X' is tapped.
     */
    @objc fileprivate func didTapOnExitButton(_ sender: UIGestureRecognizer){
        
        // To log and send impression.
        if let tag = sender.view?.tag,
            let type = ImpressionType(rawValue: tag) {
            logImpression(withImpressionType: type, withProperties: [])
            sendImpression()
        }
        
        self.dismiss()
    }
    
    func logImpression(withImpressionType type: ImpressionType, withProperties properties: [Property]) {
        
        // Log the impression.
        self.impressions.append(
            Impression(
                type: type,
                ts: Date().millisecondsSince1970
            )
        )
        
         //Log the properties.
        for property in properties {
            self.properties.append(property)
        }
    }
}
