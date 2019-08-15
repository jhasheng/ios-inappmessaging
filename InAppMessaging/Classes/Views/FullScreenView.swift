import UIKit
import SDWebImage

/**
 * Class that initializes the modal view using the passed in campaign information to build the UI.
 */
class FullScreenView: UIView, IAMFullScreenview {
    
    var impressions: [Impression] = []
    var campaign: CampaignData?
    
    // Constant values used for UI elements in model views.
    let heightOffset: CGFloat = 18 // Height offset for every UI element.
    let backgroundViewAlpha: CGFloat = 0.66 // Value to adjust the transparency of the background view.
    let cornerRadiusForDialogView: CGFloat = 0 // Adjust how round the edge the dialog view will be.
    let cornerRadiusForButtons: CGFloat = 4 // Adjust how round the edge of the buttons will be.
    let headerMessageFontSize: CGFloat = 16 // Font size for the header message.
    let bodyMessageFontSize: CGFloat = 14 // Font size for the body message.
    let buttonTextFontSize: CGFloat = 14 // Font size for the button labels.
    let secondButtonGapSize: CGFloat = 8 // Size of the gap between the buttons when there are two buttons.
    let singleButtonWidthOffset: CGFloat = 0 // Width offset when only one button is given.
    let twoButtonWidthOffset: CGFloat = 24 // Width offset when two buttons are given.
    let horizontalSpacingOffset: CGFloat = 20 // The spacing between dialog view and the children elements.
    let initialFrameWidthOffset: CGFloat = 0 // Margin between the left and right frame width and message.
    let initialFrameWidthIPadMultiplier: CGFloat = 1.0 // Percentage size for iPad's to display
    let maxWindowHeightPercentage: CGFloat = 0.90 // The max height the window should take up before making text scrollable.
    var exitButtonSize: CGFloat = 0 // Size of the exit button.
    var exitButtonHeightOffset: CGFloat = 0 // Height offset for exit button from the actual message.
    var exitButtonFontSize: CGFloat = 0 // Font size of exit button.
    var exitButtonGapHeight: CGFloat = 55 // Size of the gap between the exit button and textview.
    var exitButtonYPosition: CGFloat = 30 // Position of where the button should be relative to the safe area frame.
    
    var backgroundView = UIView()
    var dialogView = UIView()
    var textView = UITextView()
    
    // Maps the button tag number to its link URI and campaign trigger.
    var buttonMapping = [Int: (uri: String?, trigger: Trigger?)]()
    
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
        initializeView(withCampaign: campaign, andImage: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeView(withCampaign campaign: CampaignData, andImage optionalImage: UIImage?) {
        // The opaque black background of modals.
        backgroundView.frame = frame
        backgroundView.backgroundColor = .white
        
        // Set up the initial values for UI based on device.
        setUpInitialValues()
        
        // Create the UIImageView first if there is an image.
        if let image = optionalImage {
            hasImage = true
            appendImageView(withImage: image)
        }
        
        createMessageBody(campaign: campaign)
        appendSubViews()
    }
    
    private func setUpInitialValues() {
        // Set different values based on device -- either iPad or iPhone.
        if UIDevice.current.userInterfaceIdiom == .pad {
            dialogViewWidth = frame.width * initialFrameWidthIPadMultiplier
            exitButtonSize = 32
            exitButtonHeightOffset = 25
            exitButtonFontSize = 16
        } else {
            dialogViewWidth = frame.width - initialFrameWidthOffset
            exitButtonSize = 25
            exitButtonHeightOffset = 5
            exitButtonFontSize = 14
        }
    }
    
    /**
     * Creates the modal view to be displayed using the campaign information.
     * @param { campaign: CampaignData } the campaign to be displayed.
     */
    func createMessageBody(campaign: CampaignData) {
        // Add the exit button on the top right.
        appendExitButton()
        
        // Scroll view for header and messages.
        if campaign.messagePayload.header != nil ||
            campaign.messagePayload.messageBody != nil ||
            campaign.messagePayload.messageLowerBody != nil {
            
            // Handle spacing case for when there is no header.
            if campaign.messagePayload.header != nil {
                dialogViewCurrentHeight += heightOffset
            }
            
            appendTextView(withMessage: campaign.messagePayload)
            
            dialogViewCurrentHeight += textView.frame.height
            
            // Handle spacing case for when there are no messages.
            if campaign.messagePayload.messageBody != nil ||
                campaign.messagePayload.messageLowerBody != nil {
                
                dialogViewCurrentHeight += heightOffset
            }
        }
        
        // Buttons.
        if let buttonList = campaign.messagePayload.messageSettings.controlSettings?.buttons, !buttonList.isEmpty {
            // Handle spacing for when there is only an image and buttons
            if campaign.messagePayload.resource.imageUrl != nil &&
                campaign.messagePayload.header == nil &&
                campaign.messagePayload.messageBody == nil &&
                campaign.messagePayload.messageLowerBody == nil {

                    dialogViewCurrentHeight += heightOffset
            }

            appendButtons(withButtonList: buttonList)
            dialogViewCurrentHeight += heightOffset
        }
        
        if #available(iOS 11.0, *) {
            dialogView.frame = UIApplication.shared.keyWindow!.safeAreaLayoutGuide.layoutFrame
        } else {
            dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
            dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewCurrentHeight)
            dialogView.center = center
        }
        
        dialogView.backgroundColor = UIColor(hexFromString: campaign.messagePayload.backgroundColor)
        dialogView.layer.cornerRadius = cornerRadiusForDialogView
        dialogView.clipsToBounds = true
    }
    
    private func appendExitButton() {
        var safeFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if #available(iOS 11.0, *) {
            safeFrame = UIApplication.shared.keyWindow!.safeAreaLayoutGuide.layoutFrame
        }
        
        // The top right "X" button to dismiss.
        let exitButton = UILabel(
            frame: CGRect(x: safeFrame.maxX - (exitButtonSize * 2.0),
                          y: exitButtonYPosition,
                          width: exitButtonSize,
                          height: exitButtonSize))
        
        exitButton.text = "X"
        exitButton.font = .systemFont(ofSize: exitButtonFontSize)
        exitButton.backgroundColor = hasImage ? .white : .black
        exitButton.textColor = hasImage ? .black : .white
        exitButton.textAlignment = .center
        exitButton.isUserInteractionEnabled = true
        exitButton.layer.cornerRadius = exitButton.frame.width / 2
        exitButton.layer.masksToBounds = true
        exitButton.tag = ImpressionType.EXIT.rawValue
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onExitButtonClick)))
        dialogView.addSubview(exitButton)
        
        dialogViewCurrentHeight += hasImage ? 0 : exitButtonGapHeight
    }
    
    /**
     * Creates the text view to be displayed using the campaign information.
     * @param { messagePayload: MessagePayload } the campaign's message payload.
     */
    private func appendTextView(withMessage messagePayload: MessagePayload) {
        // Change textview background color
        textView.backgroundColor = UIColor(hexFromString: messagePayload.backgroundColor)
        
        // Header title.
        if let headerMessage = messagePayload.header {
            appendHeaderMessage(withHeader: headerMessage)
            textViewContentHeight += heightOffset
        }
        
        // Body message.
        if let bodyMessage = messagePayload.messageBody {
            if messagePayload.header == nil {
                textViewContentHeight += heightOffset
            }
            
            appendBodyMessage(withBody: bodyMessage)
            
            if messagePayload.messageLowerBody != nil {
                textViewContentHeight += heightOffset
            }
        }
        
        // Lower body message.
        if let lowerBodyMessage = messagePayload.messageLowerBody {
            if messagePayload.header == nil &&
                messagePayload.messageBody == nil {
                
                textViewContentHeight += heightOffset
            }
            
            appendLowerBodyMessage(withBody: lowerBodyMessage)
        }
        
        // Height of the current window.
        let overallHeight = dialogViewCurrentHeight + textViewContentHeight
        // The height of the frame when multipled with the cap.
        var maxFrameHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            maxFrameHeight = UIApplication.shared.keyWindow!.safeAreaLayoutGuide.layoutFrame.height * maxWindowHeightPercentage
        } else {
            maxFrameHeight = frame.height * maxWindowHeightPercentage
        }
        
        // Calculate the optimal height based on the amount of text.
        // If the whole window were to exceed over 70% of the frame's height, then keep it at 70%
        // and make text scrollable
        let optimalHeight = overallHeight < maxFrameHeight ?
            textViewContentHeight :
            maxFrameHeight - dialogViewCurrentHeight
        
        textView.frame = CGRect(x: horizontalSpacingOffset,
                                     y: dialogViewCurrentHeight,
                                     width: dialogViewWidth - (horizontalSpacingOffset * 2),
                                     height: optimalHeight)
        
        textView.contentSize.height = textViewContentHeight
        textView.isEditable = false
        
        dialogView.addSubview(textView)
    }
    
    /**
     * Append image view to dialog view.
     * @param { iimage: UIImage } the image to display.
     */
    private func appendImageView(withImage image: UIImage) {
        // Image ratio to calculate the height.
        let imageRatio = dialogViewWidth / image.size.width
        
        let imageView = UIImageView(
            frame: CGRect(x: 0,
                          y: dialogViewCurrentHeight,
                          width: dialogViewWidth,
                          height: image.size.height * imageRatio))
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        dialogView.addSubview(imageView)
        dialogViewCurrentHeight += imageView.frame.height
    }
    
    /**
     * Append header message to dialog view.
     * @param { headerMessage: String } string of the header message.
     */
    private func appendHeaderMessage(withHeader headerMessage: String) {
        let headerMessageLabel = UILabel(
            frame: CGRect(x: 0,
                          y: textViewContentHeight,
                          width: dialogViewWidth - (horizontalSpacingOffset * 2),
                          height: 0))
        
        headerMessageLabel.text = headerMessage
        headerMessageLabel.setLineSpacing(lineSpacing: 3.0)
        headerMessageLabel.textAlignment = .center
        headerMessageLabel.lineBreakMode = .byWordWrapping
        headerMessageLabel.numberOfLines = 0
        headerMessageLabel.font = .boldSystemFont(ofSize: headerMessageFontSize)
        headerMessageLabel.frame.size.height = headerMessageLabel.optimalHeight
        textView.addSubview(headerMessageLabel)
        
        textViewContentHeight += headerMessageLabel.frame.height
    }
    
    /**
     * Append body message to dialog view.
     * @param { bodyMessage: String } string of the body message.
     */
    private func appendBodyMessage(withBody bodyMessage: String) {
        let bodyMessageLabel = UILabel(
            frame: CGRect(x: 0,
                          y: textViewContentHeight,
                          width: dialogViewWidth - (horizontalSpacingOffset * 2),
                          height: 0))
        
        bodyMessageLabel.text = bodyMessage
        bodyMessageLabel.setLineSpacing(lineSpacing: 3.0)
        bodyMessageLabel.font = .systemFont(ofSize: bodyMessageFontSize)
        bodyMessageLabel.textAlignment = .left
        bodyMessageLabel.lineBreakMode = .byWordWrapping
        bodyMessageLabel.numberOfLines = 0
        bodyMessageLabel.frame.size.height = bodyMessageLabel.optimalHeight
        textView.addSubview(bodyMessageLabel)
        
        textViewContentHeight += bodyMessageLabel.frame.height
    }
    
    /**
     * Append lower body message to dialog view.
     * @param { bodyMessage: String } string of the lower body message.
     */
    private func appendLowerBodyMessage(withBody lowerBodyMessage: String) {
        let lowerBodyMessageLabel = UILabel(
            frame: CGRect(x: 0,
                          y: textViewContentHeight,
                          width: dialogViewWidth - (horizontalSpacingOffset * 2),
                          height: 0))
        
        lowerBodyMessageLabel.text = lowerBodyMessage
        lowerBodyMessageLabel.setLineSpacing(lineSpacing: 3.0)
        lowerBodyMessageLabel.font = .systemFont(ofSize: bodyMessageFontSize)
        lowerBodyMessageLabel.textAlignment = .left
        lowerBodyMessageLabel.lineBreakMode = .byWordWrapping
        lowerBodyMessageLabel.numberOfLines = 0
        lowerBodyMessageLabel.frame.size.height = lowerBodyMessageLabel.optimalHeight
        textView.addSubview(lowerBodyMessageLabel)
        
        textViewContentHeight += lowerBodyMessageLabel.frame.height
    }
    
    /**
     * Append buttons to dialog view.
     * @param { buttonList: [Button] } list of Button data type.
     */
    private func appendButtons(withButtonList buttonList: [Button]) {
        
        var buttonHorizontalSpace: CGFloat = 20 // Space for the left and right margin.
        let buttonHeight: CGFloat = 40 // Define the height to use for the button.
        
        for (index, button) in buttonList.enumerated() {
            // Determine offset value based on numbers of buttons to display.
            var buttonWidthOffset: CGFloat
            var xPositionForButton: CGFloat
            
            if buttonList.count == 1 {
                buttonWidthOffset = singleButtonWidthOffset
                xPositionForButton = (dialogViewWidth / 4) + (buttonWidthOffset / 2)
            } else {
                buttonWidthOffset = twoButtonWidthOffset
                xPositionForButton = buttonHorizontalSpace
            }
            
            var safeAreaFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
            var bottomInset: CGFloat = 0
            if #available(iOS 11.0, *) {
                safeAreaFrame = UIApplication.shared.keyWindow!.safeAreaLayoutGuide.layoutFrame
                bottomInset = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
            }
            
            let buttonToAdd = UIButton(
                frame: CGRect(x: xPositionForButton,
                              y: safeAreaFrame.height - buttonHeight - heightOffset,
                              width: ((dialogViewWidth / 2) - buttonWidthOffset),
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
            
            dialogView.addSubview(buttonToAdd)
        }
    }
    
    /**
     * Append sub views to present view when ready.
     */
    private func appendSubViews() {
        addSubview(backgroundView)
        addSubview(dialogView)
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
    @objc private func onActionButtonClick(_ sender: UIGestureRecognizer) {
        
        guard let tag = sender.view?.tag else {
            return
        }
        
        // Log and send impression.
        if let type = ImpressionType(rawValue: tag) {
            logImpression(withImpressionType: type)
            sendImpression()
        }
        
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
        
        dismiss()
    }
    
    /**
     * Obj-c selector to handle exit type buttons.
     * Includes the "X" button on the top right and the close action type button.
     */
    @objc private func onExitButtonClick(_ sender: UIGestureRecognizer) {
        dismiss()
        
        guard let tag = sender.view?.tag else {
            return
        }
        
        // To log and send impression.
        if let type = ImpressionType(rawValue: tag) {
            logImpression(withImpressionType: type)
            sendImpression()
        }
        
        // If the button came with a campaign trigger, log it.
        logButtonTrigger(with: tag)
    }
    
    func logImpression(withImpressionType type: ImpressionType) {
        // Log the impression.
        impressions.append(
            Impression(
                type: type,
                timestamp: Date().millisecondsSince1970
            )
        )
    }
}
