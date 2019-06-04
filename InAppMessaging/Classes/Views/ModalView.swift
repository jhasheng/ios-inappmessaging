import UIKit
import SDWebImage

/**
 * Class that initializes the modal view using the passed in campaign information to build the UI.
 */
class ModalView: UIView, IAMView, ImpressionTrackable {

    var impressions: [Impression] = []
    var campaign: CampaignData?

    // Constant values used for UI elements in model views.
    let heightOffset: CGFloat = 18 // Height offset for every UI element.
    let backgroundViewAlpha: CGFloat = 0.66 // Value to adjust the transparency of the background view.
    let cornerRadiusForDialogView: CGFloat = 8 // Adjust how round the edge the dialog view will be.
    let cornerRadiusForButtons: CGFloat = 4 // Adjust how round the edge of the buttons will be.
    let headerMessageFontSize: CGFloat = 16 // Font size for the header message.
    let bodyMessageFontSize: CGFloat = 14 // Font size for the body message.
    let buttonTextFontSize: CGFloat = 14 // Font size for the button labels.
    let singleButtonWidthOffset: CGFloat = 0 // Width offset when only one button is given.
    let twoButtonWidthOffset: CGFloat = 24 // Width offset when two buttons are given.
    let horizontalSpacingOffset: CGFloat = 20 // The spacing between dialog view and the children elements.
    let initialFrameWidthOffset: CGFloat = 120 // Margin between the left and right frame width and message.
    let initialFrameWidthIPadMultiplier: CGFloat = 0.60 // Percentage size for iPad's to display
    let imageAspectRatio: CGFloat = 1.25 // Aspect ratio for image. Currently set to 3:4.
    let maxWindowHeightPercentage: CGFloat = 0.70 // The max height the window should take up before making text scrollable.
    var exitButtonSize: CGFloat = 0 // Size of the exit button.
    var exitButtonHeightOffset: CGFloat = 0 // Height offset for exit button from the actual message.
    var exitButtonFontSize: CGFloat = 0 // Font size of exit button.
    
    var backgroundView = UIView()
    var dialogView = UIView()
    var textView = UITextView()
    
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
    
    // Set the text view's content height based on the height of the UILabels that it contains.
    var textViewContentHeight: CGFloat = 0
    
    convenience init(withCampaign campaign: CampaignData, andImage image: UIImage?) {
        self.init(frame: UIScreen.main.bounds)
        self.campaign = campaign
        self.initializeView(withCampaign: campaign, andImage: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func initializeView(withCampaign campaign: CampaignData, andImage optionalImage: UIImage?) {
        // The opaque black background of modals.
        self.backgroundView.frame = frame
        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(backgroundViewAlpha)

        // Set up the initial values for UI based on device.
        self.setUpInitialValues()

        // Create the UIImageView first if there is an image.
        if let image = optionalImage {
            self.appendImageView(withImage: image)
        }
        
        self.createMessageBody(campaign: campaign)
        self.appendSubViews()
    }
    
    fileprivate func setUpInitialValues() {
        // Set different values based on device -- either iPad or iPhone.
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Use 75% of iPad's width.
            self.dialogViewWidth = frame.width * initialFrameWidthIPadMultiplier
            self.exitButtonSize = 22
            self.exitButtonHeightOffset = 35
            self.exitButtonFontSize = 16
        } else {
            self.dialogViewWidth = frame.width - initialFrameWidthOffset
            self.exitButtonSize = 15
            self.exitButtonHeightOffset = 25
            self.exitButtonFontSize = 13
        }
    }
    
    /**
     * Creates the modal view to be displayed using the campaign information.
     * @param { campaign: CampaignData } the campaign to be displayed.
     */
    internal func createMessageBody(campaign: CampaignData) {
        // Scroll view for header and messages.
        if campaign.messagePayload.header != nil ||
            campaign.messagePayload.messageBody != nil ||
            campaign.messagePayload.messageLowerBody != nil {

                // Handle spacing case for when there is no header.
                if campaign.messagePayload.header != nil {
                    self.dialogViewCurrentHeight += heightOffset
                }

                self.appendTextView(withMessage: campaign.messagePayload)

                self.dialogViewCurrentHeight += self.textView.frame.height

                // Handle spacing case for when there are no messages.
                if campaign.messagePayload.messageBody != nil ||
                    campaign.messagePayload.messageLowerBody != nil {

                        self.dialogViewCurrentHeight += heightOffset
                }

        }

        // Buttons.
        if let buttonList = campaign.messagePayload.messageSettings.controlSettings?.buttons, !buttonList.isEmpty {
            // Handle spacing for when there is only an image and buttons
            if campaign.messagePayload.resource.imageUrl != nil &&
                campaign.messagePayload.header == nil &&
                campaign.messagePayload.messageBody == nil &&
                campaign.messagePayload.messageLowerBody == nil {

                    self.dialogViewCurrentHeight += heightOffset
            }

            self.appendButtons(withButtonList: buttonList)
            self.dialogViewCurrentHeight += heightOffset
        }

        // The dialog view which is the rounded rectangle in the center.
        self.dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        self.dialogView.frame.size = CGSize(width: self.dialogViewWidth, height: self.dialogViewCurrentHeight)
        self.dialogView.backgroundColor = UIColor(hexFromString: campaign.messagePayload.backgroundColor)
        self.dialogView.layer.cornerRadius = cornerRadiusForDialogView
        self.dialogView.clipsToBounds = true
        self.dialogView.center  = self.center

        // Add the exit button on the top right.
        self.appendExitButton()
    }
    
    fileprivate func appendExitButton() {
        // The top right "X" button to dismiss.
        let exitButton = UILabel(
            frame: CGRect(x: dialogView.frame.maxX - exitButtonSize,
                          y: dialogView.frame.minY - exitButtonHeightOffset,
                          width: exitButtonSize,
                          height: exitButtonSize))
        
        exitButton.text = "X"
        exitButton.font = .systemFont(ofSize: exitButtonFontSize)
        exitButton.backgroundColor = .white
        exitButton.textColor = .black
        exitButton.textAlignment = .center
        exitButton.isUserInteractionEnabled = true
        exitButton.layer.cornerRadius = exitButton.frame.width / 2
        exitButton.layer.masksToBounds = true
        exitButton.tag = ImpressionType.EXIT.rawValue
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnExitButton)))
        self.backgroundView.addSubview(exitButton)
    }
    
    /**
     * Creates the text view to be displayed using the campaign information.
     * @param { messagePayload: MessagePayload } the campaign's message payload.
     */
    fileprivate func appendTextView(withMessage messagePayload: MessagePayload) {
        // Change textview background color
        self.textView.backgroundColor = UIColor(hexFromString: messagePayload.backgroundColor)
        
        // Header title.
        if let headerMessage = messagePayload.header {
            self.appendHeaderMessage(withHeader: headerMessage)
            self.textViewContentHeight += heightOffset
        }
        
        // Body message.
        if let bodyMessage = messagePayload.messageBody {
            
            if messagePayload.header == nil {
                self.textViewContentHeight += heightOffset
            }
            
            self.appendBodyMessage(withBody: bodyMessage)
            
            if messagePayload.messageLowerBody != nil {
                self.textViewContentHeight += heightOffset
            }
        }
        
        // Lower body message.
        if let lowerBodyMessage = messagePayload.messageLowerBody {
            
            if messagePayload.header == nil &&
                messagePayload.messageBody == nil {
                
                self.textViewContentHeight += heightOffset
            }
            
            self.appendLowerBodyMessage(withBody: lowerBodyMessage)
        }
        
        // Height of the current window.
        let overallHeight = self.dialogViewCurrentHeight + self.textViewContentHeight
        // The height of the frame when multipled with the cap.
        let maxFrameHeight = self.frame.height * maxWindowHeightPercentage
        
        // Calculate the optimal height based on the amount of text.
        // If the whole window were to exceed over 70% of the frame's height, then keep it at 70%
        // and make text scrollable
        let optimalHeight = overallHeight < maxFrameHeight ?
            self.textViewContentHeight :
            maxFrameHeight - self.dialogViewCurrentHeight

        self.textView.frame = CGRect(x: horizontalSpacingOffset,
                                     y: self.dialogViewCurrentHeight,
                                     width: self.dialogViewWidth - (horizontalSpacingOffset * 2),
                                     height: optimalHeight)
        
        textView.contentSize.height = self.textViewContentHeight
        textView.isEditable = false
        
        self.dialogView.addSubview(textView)
    }
    
    /**
     * Append image view to dialog view.
     * @param { iimage: UIImage } the image to display.
     */
    fileprivate func appendImageView(withImage image: UIImage) {
        
        // Image ratio to calculate the height.
        let imageRatio = self.dialogViewWidth / image.size.width
        
        let imageView = UIImageView(
            frame: CGRect(x: 0,
                          y: self.dialogViewCurrentHeight,
                          width: self.dialogViewWidth,
                          height: image.size.height * imageRatio))
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        self.dialogView.addSubview(imageView)
        self.dialogViewCurrentHeight += imageView.frame.height
    }
    
    /**
     * Append header message to dialog view.
     * @param { headerMessage: String } string of the header message.
     */
    fileprivate func appendHeaderMessage(withHeader headerMessage: String) {
        let headerMessageLabel = UILabel(
            frame: CGRect(x: 0,
                          y: self.textViewContentHeight,
                          width: self.dialogViewWidth - (horizontalSpacingOffset * 2),
                          height: 0))
        
        headerMessageLabel.text = headerMessage
        headerMessageLabel.setLineSpacing(lineSpacing: 3.0)
        headerMessageLabel.textAlignment = .center
        headerMessageLabel.lineBreakMode = .byWordWrapping
        headerMessageLabel.numberOfLines = 0
        headerMessageLabel.font = .boldSystemFont(ofSize: headerMessageFontSize)
        headerMessageLabel.frame.size.height = headerMessageLabel.optimalHeight
        self.textView.addSubview(headerMessageLabel)
        
        self.textViewContentHeight += headerMessageLabel.frame.height
    }
    
    /**
     * Append body message to dialog view.
     * @param { bodyMessage: String } string of the body message.
     */
    fileprivate func appendBodyMessage(withBody bodyMessage: String) {
        let bodyMessageLabel = UILabel(
            frame: CGRect(x: 0,
                          y: self.textViewContentHeight,
                          width: self.dialogViewWidth - (horizontalSpacingOffset * 2),
                          height: 0))
        
        bodyMessageLabel.text = bodyMessage
        bodyMessageLabel.setLineSpacing(lineSpacing: 3.0)
        bodyMessageLabel.font = .systemFont(ofSize: bodyMessageFontSize)
        bodyMessageLabel.textAlignment = .left
        bodyMessageLabel.lineBreakMode = .byWordWrapping
        bodyMessageLabel.numberOfLines = 0
        bodyMessageLabel.frame.size.height = bodyMessageLabel.optimalHeight
        self.textView.addSubview(bodyMessageLabel)
        
        self.textViewContentHeight += bodyMessageLabel.frame.height
    }
    
    /**
     * Append lower body message to dialog view.
     * @param { bodyMessage: String } string of the lower body message.
     */
    fileprivate func appendLowerBodyMessage(withBody lowerBodyMessage: String) {
        let lowerBodyMessageLabel = UILabel(
            frame: CGRect(x: 0,
                          y: self.textViewContentHeight,
                          width: self.dialogViewWidth - (horizontalSpacingOffset * 2),
                          height: 0))
        
        lowerBodyMessageLabel.text = lowerBodyMessage
        lowerBodyMessageLabel.setLineSpacing(lineSpacing: 3.0)
        lowerBodyMessageLabel.font = .systemFont(ofSize: bodyMessageFontSize)
        lowerBodyMessageLabel.textAlignment = .left
        lowerBodyMessageLabel.lineBreakMode = .byWordWrapping
        lowerBodyMessageLabel.numberOfLines = 0
        lowerBodyMessageLabel.frame.size.height = lowerBodyMessageLabel.optimalHeight
        self.textView.addSubview(lowerBodyMessageLabel)
        
        self.textViewContentHeight += lowerBodyMessageLabel.frame.height
    }
    
    /**
     * Append buttons to dialog view.
     * @param { buttonList: [Button] } list of Button data type.
     */
    fileprivate func appendButtons(withButtonList buttonList: [Button]) {
        
        var buttonHorizontalSpace: CGFloat = 20 // Space for the left and right margin.
        let buttonHeight: CGFloat = 40 // Define the height to use for the button.
        
        for (index, button) in buttonList.enumerated() {
            if let buttonAction = ButtonActionType(rawValue: button.buttonBehavior.action) {
                // Determine offset value based on numbers of buttons to display.
                var buttonWidthOffset: CGFloat
                var xPositionForButton: CGFloat
                
                if buttonList.count == 1 {
                    buttonWidthOffset = singleButtonWidthOffset
                    xPositionForButton = (self.dialogViewWidth / 4) + (buttonWidthOffset / 2)
                } else {
                    buttonWidthOffset = twoButtonWidthOffset
                    xPositionForButton = buttonHorizontalSpace
                }

                let buttonToAdd = UIButton(
                    frame: CGRect(x: xPositionForButton,
                                  y: self.dialogViewCurrentHeight,
                                  width: ((self.dialogViewWidth / 2) - buttonWidthOffset),
                                  height: buttonHeight))
                
                buttonToAdd.setTitle(button.buttonText, for: .normal)
                buttonToAdd.setTitleColor(UIColor(hexFromString: button.buttonTextColor), for: .normal)
                buttonToAdd.titleLabel?.font = .boldSystemFont(ofSize: buttonTextFontSize)
                buttonToAdd.layer.cornerRadius = cornerRadiusForButtons
                buttonToAdd.tag = index == 0 ? ImpressionType.ACTION_ONE.rawValue : ImpressionType.ACTION_TWO.rawValue
                buttonToAdd.backgroundColor = UIColor(hexFromString: button.buttonBackgroundColor)
                buttonToAdd.layer.borderColor = UIColor(hexFromString: button.buttonTextColor).cgColor
                buttonToAdd.layer.borderWidth = 1
                
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
        
        self.dialogViewCurrentHeight += buttonHeight
    }
    
    /**
     * Append sub views to present view when ready.
     */
    fileprivate func appendSubViews() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.dialogView)
        logImpression(withImpressionType: .IMPRESSION)
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
                logImpression(withImpressionType: type)
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
        self.dismiss()
        
        // To log and send impression.
        if let tag = sender.view?.tag,
            let type = ImpressionType(rawValue: tag) {
            logImpression(withImpressionType: type)
            sendImpression()
        }
    }
    
    func logImpression(withImpressionType type: ImpressionType) {
        // Log the impression.
        self.impressions.append(
            Impression(
                type: type,
                timestamp: Date().millisecondsSince1970
            )
        )
    }
}
