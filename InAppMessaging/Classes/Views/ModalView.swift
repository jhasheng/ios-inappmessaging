import UIKit
import SDWebImage

/**
 * Class that initializes the modal view using the passed in campaign information to build the UI.
 */
class ModalView: UIView, Modal {
    var backgroundView = UIView()
    var dialogView = UIView()
    
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
    
    convenience init(campaign: CampaignData) {
        self.init(frame: UIScreen.main.bounds)
        
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
        self.backgroundView.backgroundColor = .black
        self.backgroundView.alpha = 0.66

        self.addSubview(backgroundView)
        
        // Set the initial width to -64 to leave spacing on the left and right side.
        self.dialogViewWidth = frame.width - 64
        
        // Image view.
        if let imageUrl = campaign.messagePayload.resource.imageUrl, !imageUrl.isEmpty {
            self.hasImage = true
            appendImageView(withUrl: imageUrl)
        }

        // Header title.
        if let headerMessage = campaign.messagePayload.header {
            appendHeaderMessage(withHeader: headerMessage)
        }
        
        // Body message.
        if let bodyMessage = campaign.messagePayload.messageBody {
            appendBodyMessage(withBody: bodyMessage)
        }
        
        // Buttons.
        if let buttonList = campaign.messagePayload.messageSettings.controlSettings?.buttons, !buttonList.isEmpty {
            appendButtons(withButtonList: buttonList)
        }
        
        // The top right "X" button to dismiss.
        let exitButton = UILabel(frame: CGRect(x: dialogViewWidth - 25, y: 4, width: 20, height: 20))
        exitButton.text = "X"
        exitButton.backgroundColor = .gray
        exitButton.textColor = .white
        exitButton.textAlignment = .center
        exitButton.isUserInteractionEnabled = true
        exitButton.layer.cornerRadius = exitButton.frame.width / 2
        exitButton.layer.masksToBounds = true
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnExitButton)))
        self.dialogView.addSubview(exitButton)
        
        // The dialog view which is the rounded rectangle in the center.
        self.dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        self.dialogView.frame.size = CGSize(width: self.dialogViewWidth, height: self.dialogViewCurrentHeight)
        self.dialogView.backgroundColor = .white
        self.dialogView.layer.cornerRadius = 6
        self.dialogView.clipsToBounds = true
        self.dialogView.center  = self.center
        
        if !hasImage {
            self.addSubview(self.dialogView)
        }
    }
    
    /**
     * Obj-c selector to dismiss the modal view when the 'X' is tapped.
     */
    @objc fileprivate func didTappedOnExitButton(){
        dismiss()
    }
    
    /**
     * Append image view to dialog view.
     * @param { imageUrl: String } string of the image URL.
     */
    fileprivate func appendImageView(withUrl imageUrl: String) {
        //TODO(Daniel Tam) Update aspect ratio here when finalized.
        let imageView = UIImageView(frame: CGRect(x: 0, y: self.dialogViewCurrentHeight, width: self.dialogViewWidth, height: self.dialogViewWidth / 2.9))
        imageView.contentMode = .scaleAspectFit
        
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil) { (image, error, SDImageCacheType, url) in
            self.addSubview(self.dialogView)
        }
        
        self.dialogView.addSubview(imageView)
        
        self.dialogViewCurrentHeight += imageView.frame.height
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
        
        self.dialogViewCurrentHeight += headerMessageLabel.frame.height + 8
    }
    
    /**
     * Append body message to dialog view.
     * @param { bodyMessage: String } string of the body message.
     */
    fileprivate func appendBodyMessage(withBody bodyMessage: String) {
        let bodyMessageLabel = UILabel(frame: CGRect(x: 8, y: self.dialogViewCurrentHeight, width: self.dialogViewWidth - 16, height: 0))
        bodyMessageLabel.text = bodyMessage
        bodyMessageLabel.textAlignment = .center
        bodyMessageLabel.lineBreakMode = .byWordWrapping
        bodyMessageLabel.numberOfLines = 0
        bodyMessageLabel.frame.size.height = bodyMessageLabel.optimalHeight
        self.dialogView.addSubview(bodyMessageLabel)
        
        self.dialogViewCurrentHeight += bodyMessageLabel.frame.height + 8
    }
    
    /**
     * Append buttons to dialog view.
     * @param { buttonList: [Button] } list of Button data type.
     */
    fileprivate func appendButtons(withButtonList buttonList: [Button]) {
        
        var buttonHorizontalSpace: CGFloat = 8 // Space for the left and right margin.
        let buttonHeight: CGFloat = 30 // Define the height to use for the button.
        
        for (index, button) in buttonList.enumerated() {
            
            // Determine offset value based on numbers of buttons to display.
            let buttonWidthOffset: CGFloat = buttonList.count == 1 ? 16 : 12
            
            let buttonToAdd = UIButton(frame: CGRect(x: buttonHorizontalSpace,
                                                     y: self.dialogViewCurrentHeight,
                                                     width: ((self.dialogViewWidth / CGFloat(buttonList.count)) - buttonWidthOffset),
                                                     height: buttonHeight))
            
            buttonToAdd.setTitle(button.buttonText, for: .normal)
            buttonToAdd.layer.cornerRadius = 6
            
            //TODO(Daniel Tam) Remove hardcoded colors when backend is ready.
            if index == 0 {
                buttonToAdd.backgroundColor = .blue
                
            } else if index == 1 {
                buttonToAdd.backgroundColor = .gray
            }
            
            buttonHorizontalSpace += buttonToAdd.frame.width + 8
            
            self.dialogView.addSubview(buttonToAdd)
        }
        
        self.dialogViewCurrentHeight += buttonHeight + 8
    }
}
