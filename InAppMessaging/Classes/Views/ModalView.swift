/**
 * Class that initializes the modal view using the passed in campaign information to build the UI.
 */
class ModalView: UIView, IAMModalView, RichContentBrowsable {

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
    let secondButtonGapSize: CGFloat = 8 // Size of the gap between the buttons when there are two buttons.
    let singleButtonWidthOffset: CGFloat = 0 // Width offset when only one button is given.
    let twoButtonWidthOffset: CGFloat = 24 // Width offset when two buttons are given.
    let horizontalSpacingOffset: CGFloat = 20 // The spacing between dialog view and the children elements.
    let initialFrameWidthOffset: CGFloat = 100 // Margin between the left and right frame width and message.
    let initialFrameWidthIPadMultiplier: CGFloat = 0.60 // Percentage size for iPad's to display
    let maxWindowHeightPercentage: CGFloat = 0.65 // The max height the window should take up before making text scrollable.
    let optOutMessageSize: CGFloat = 12 // Vertical height for the opt-out message and checkbox.
    let optOutMessageFontSize: CGFloat = 12 // Font size of the opt-out message
    let optOutCheckBoxOffset: CGFloat = 5 // How far the checkbox should be from the opt-out msg.
    var exitButtonSize: CGFloat = 0 // Size of the exit button.
    var exitButtonHeightOffset: CGFloat = 0 // Height offset for exit button from the actual message.
    var exitButtonFontSize: CGFloat = 0 // Font size of exit button.
    
    var backgroundView = UIView()
    var dialogView = UIView()
    var textView = UITextView()
    
    // Maps the button tag number to its link URI and campaign trigger.
    var buttonMapping = [Int: (uri: String?, trigger: Trigger?)]()

    // Opt-out checkbox.
    var optOutCheckbox: Checkbox?
    
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
    
    private func appendOptOutMessage() {
        let optOutMessage = UILabel()
        optOutMessage.textAlignment = .center
        optOutMessage.text = "Do not show me this message again.".localized
        optOutMessage.font = .systemFont(ofSize: optOutMessageFontSize)
        optOutMessage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnOptOutLabel)))
        optOutMessage.isUserInteractionEnabled = true
        optOutMessage.sizeToFit()
        optOutMessage.frame.origin.y = dialogViewCurrentHeight
        optOutMessage.center.x = dialogViewWidth / 2
        
        optOutCheckbox = Checkbox(frame:
            CGRect(x: optOutMessage.frame.origin.x - optOutMessageSize - optOutCheckBoxOffset,
                   y: dialogViewCurrentHeight,
                   width: optOutMessageSize,
                   height: optOutMessageSize
            )
        )
        
        guard let checkbox = optOutCheckbox else {
            return
        }
        
        checkbox.borderStyle = .square
        checkbox.uncheckedBorderColor = .black
        checkbox.checkedBorderColor = .black
        checkbox.checkmarkColor = .black
        checkbox.checkmarkStyle = .tick
        checkbox.borderWidth = 1
        checkbox.useHapticFeedback = false
        
        dialogView.addSubview(optOutMessage)
        dialogView.addSubview(checkbox)
        
        self.dialogViewCurrentHeight += checkbox.frame.height
    }
    
    fileprivate func setUpInitialValues() {
        // Set different values based on device -- either iPad or iPhone.
        if UIDevice.current.userInterfaceIdiom == .pad {
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
        let messagePayload = campaign.messagePayload
        
        // Check the type of campaign -- either rich content or regular.
        if let isRichContent = messagePayload.messageSettings.displaySettings.html,
            isRichContent == true,
            let messageBody = messagePayload.messageBody {
            
                appendWebView(withHtmlString: messageBody)
            
                if let isButtonEmpty = messagePayload.messageSettings.controlSettings?.buttons?.isEmpty,
                    (!isButtonEmpty || messagePayload.messageSettings.displaySettings.optOut) {
                    
                        self.dialogViewCurrentHeight += heightOffset
            }
        } else {
            // Scroll view for header and messages.
            if messagePayload.header != nil ||
                messagePayload.messageBody != nil ||
                messagePayload.messageLowerBody != nil {
                
                // Handle spacing case for when there is no header.
                if messagePayload.header != nil {
                    self.dialogViewCurrentHeight += heightOffset
                }

                self.appendTextView(withMessage: campaign.messagePayload)

                self.dialogViewCurrentHeight += self.textView.frame.height

                // Handle spacing case for when there are no messages.
                if messagePayload.messageBody != nil ||
                    messagePayload.messageLowerBody != nil {
                    
                        self.dialogViewCurrentHeight += heightOffset
                }
            }
        }
        
        // Opt-out message.
        if messagePayload.messageSettings.displaySettings.optOut {
            if messagePayload.header == nil &&
                messagePayload.messageBody == nil &&
                messagePayload.messageLowerBody == nil {
                
                    self.dialogViewCurrentHeight += heightOffset
            }
            
            appendOptOutMessage()
            self.dialogViewCurrentHeight += heightOffset
        }

        // Buttons.
        if let buttonList = messagePayload.messageSettings.controlSettings?.buttons, !buttonList.isEmpty {
            // Handle spacing for when there is only an image and buttons
            if messagePayload.resource.imageUrl != nil &&
                messagePayload.header == nil &&
                messagePayload.messageBody == nil &&
                messagePayload.messageLowerBody == nil {

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
    
    /**
     * Creates a webview and load in the HTML string provided by the Ping response.
     * @param { htmlString: String } HTML string by the backend. This string should
     * contain only safe characters -- it should NOT contain any un-escaped characters.
     */
    fileprivate func appendWebView(withHtmlString htmlString: String) {

        let webView = createWebView(withHtmlString: htmlString,
                                    andFrame: CGRect(x: frame.origin.x,
                                                     y: frame.origin.y,
                                                     width: dialogViewWidth,
                                                     height: frame.size.height * maxWindowHeightPercentage
            )
        )
        
        dialogViewCurrentHeight += webView.frame.height
        dialogView.addSubview(webView)
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
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onExitButtonClick)))

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
            
            // Add a mapping from the action type to the URL.
            buttonMapping[buttonToAdd.tag] = (button.buttonBehavior.uri ?? nil, button.campaignTrigger ?? nil)
            
            switch button.buttonBehavior.action {
                case .invalid:
                    return
                case .redirect:
                    buttonToAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onActionButtonClick)))
                case .deeplink:
                    buttonToAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onActionButtonClick)))
                case .close:
                    buttonToAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onExitButtonClick)))
            }
            
            buttonHorizontalSpace += buttonToAdd.frame.width + secondButtonGapSize
            
            self.dialogView.addSubview(buttonToAdd)
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
     * Obj-c selector to handle both redirect and deeplink type buttons.
     * When the URL fails to validate through canOpenUrl() or is empty, an alert message will pop up
     * to warn about the navigation error.
     * NOTE: The openUrl() method used here is deprecated and is being used because the SDK has to support iOS 9.
     * When iOS 10 becomes the minimum version supported by the SDK, please refer to:
     * https://developer.apple.com/documentation/uikit/uiapplication/1648685-openurl?language=objc
     */
    @objc fileprivate func onActionButtonClick(_ sender: UIGestureRecognizer) {
        dismiss()
        
        guard let tag = sender.view?.tag else {
            return
        }
        
        // Log and send impression.
        if let type = ImpressionType(rawValue: tag) {
            logImpression(withImpressionType: type)
        }
        
        if let isOptedOut = optOutCheckbox?.isChecked,
            isOptedOut == true,
            let campaign = self.campaign {
            
                logImpression(withImpressionType: .OPT_OUT)
                OptedOutRepository.addCampaign(campaign)
        }
        
        sendImpression()
        
        // Execute the action of the button.
        if let unwrappedUri = buttonMapping[tag]?.uri,
            let uriToOpen = URL(string: unwrappedUri),
            UIApplication.shared.canOpenURL(uriToOpen) {
            
                UIApplication.shared.openURL(uriToOpen)
        } else {
            let alert = UIAlertController(title: "Page not found", message: "Encountered error while navigating to the page.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        }
        
        // If the button came with a campaign trigger, log it.
        logButtonTrigger(with: tag)
    }
    
    /**
     * Obj-c selector to handle exit type buttons.
     * Includes the "X" button on the top right and the close action type button.
     */
    @objc fileprivate func onExitButtonClick(_ sender: UIGestureRecognizer) {
        dismiss()
        
        guard let tag = sender.view?.tag else {
            return
        }
        
        // To log and send impression.
        if let type = ImpressionType(rawValue: tag) {
            logImpression(withImpressionType: type)
        }
        
        if let isOptedOut = optOutCheckbox?.isChecked,
            isOptedOut == true,
            let campaign = self.campaign {
            
                logImpression(withImpressionType: .OPT_OUT)
                OptedOutRepository.addCampaign(campaign)
        }
        
        sendImpression()
        
        // If the button came with a campaign trigger, log it.
        logButtonTrigger(with: tag)
    }
    
    /**
     * Selector for changing the state of the opt-out checkbox when tapping on the label and not the checkbox itself.
     */
    @objc fileprivate func didTapOnOptOutLabel(_ sender: UIGestureRecognizer) {
        if let isChecked = optOutCheckbox?.isChecked {
            optOutCheckbox?.isChecked = !isChecked
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
