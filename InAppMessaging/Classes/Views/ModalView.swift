import UIKit
import SDWebImage

/**
 * Class that initializes the modal view using the passed in campaign information to build the UI.
 */
class ModalView: UIView, Modal {
    var backgroundView = UIView()
    var dialogView = UIView()
    
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
        
        // NOTE: DO NOT CHANGE!
        // Boolean to change when the SDK will display the modal view.
        // Will change to true if campaign has an image URL.
        // If true, display after image has finish downloading.
        // If false, display after everything else is built.
        var hasImage = false
        
        // The opaque black background of modals.
        backgroundView.frame = frame
        backgroundView.backgroundColor = .black
        self.addSubview(backgroundView)
        
        // Minus 64 to leave spacing on the left and right side.
        let dialogViewWidth = frame.width - 64
        
        // Counter of the height to dynamically set the height of the dialog view.
        // Will increment as more subviews are populated.
        var dialogViewCurrentHeight: CGFloat = 0
        
        if let imageUrl = campaign.messagePayload.resource.imageUrl {
            hasImage = true
            //TODO(Daniel Tam) Update aspect ratio here when finalized.
            let imageView = UIImageView(frame: CGRect(x: 0, y: dialogViewCurrentHeight, width: dialogViewWidth, height: dialogViewWidth / 2.9))
            imageView.contentMode = .scaleAspectFit
            
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil) { (image, error, SDImageCacheType, url) in
                self.addSubview(self.dialogView)
            }
            
            dialogView.addSubview(imageView)
            
            dialogViewCurrentHeight += imageView.frame.height
        }

        // Header title.
        if let headerMessage = campaign.messagePayload.header {
            let headerMessageLabel = UILabel(frame: CGRect(x: 8, y: dialogViewCurrentHeight, width: dialogViewWidth - 16, height: 0))
            headerMessageLabel.text = headerMessage
            headerMessageLabel.textAlignment = .center
            headerMessageLabel.lineBreakMode = .byWordWrapping
            headerMessageLabel.numberOfLines = 0
            headerMessageLabel.font = UIFont.boldSystemFont(ofSize: 16)
            headerMessageLabel.font = headerMessageLabel.font.withSize(20)
            headerMessageLabel.frame.size.height = headerMessageLabel.optimalHeight
            dialogView.addSubview(headerMessageLabel)
            
            dialogViewCurrentHeight += headerMessageLabel.frame.height + 8
        }
        
        // Body message.
        if let bodyMessage = campaign.messagePayload.messageBody {
            let bodyMessageLabel = UILabel(frame: CGRect(x: 8, y: dialogViewCurrentHeight, width: dialogViewWidth - 16, height: 0))
            bodyMessageLabel.text = bodyMessage
            bodyMessageLabel.textAlignment = .center
            bodyMessageLabel.lineBreakMode = .byWordWrapping
            bodyMessageLabel.numberOfLines = 0
            bodyMessageLabel.frame.size.height = bodyMessageLabel.optimalHeight
            dialogView.addSubview(bodyMessageLabel)
            
            dialogViewCurrentHeight += bodyMessageLabel.frame.height + 8
        }
        
        // Buttons.
        if let buttonsList = campaign.messagePayload.messageSettings.controlSettings?.buttons {
            if buttonsList.count != 0 {
                
                var buttonHorizontalSpace: CGFloat = 8 // Space for the left and right margin.
                let buttonHeight: CGFloat = 30 // Define the height to use for the button.
                
                for (index, button) in buttonsList.enumerated() {
                    
                    // Determine offset value based on numbers of buttons to display.
                    let buttonWidthOffset: CGFloat = buttonsList.count == 1 ? 16 : 12
                    
                    let buttonToAdd = UIButton(frame: CGRect(x: buttonHorizontalSpace,
                                                             y: dialogViewCurrentHeight,
                                                             width: ((dialogViewWidth / CGFloat(buttonsList.count)) - buttonWidthOffset),
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
                    
                    dialogView.addSubview(buttonToAdd)
                }
                
                dialogViewCurrentHeight += buttonHeight + 8
            }
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
        dialogView.addSubview(exitButton)
        
        // The dialog view which is the rounded rectangle in the center.
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewCurrentHeight)
        dialogView.backgroundColor = .white
        dialogView.layer.cornerRadius = 6
        dialogView.clipsToBounds = true
        
        if !hasImage {
            self.addSubview(dialogView)
        }
    }
    
    /**
     * Obj-c selector to dismiss the modal view when the 'X' is tapped.
     */
    @objc fileprivate func didTappedOnExitButton(){
        dismiss()
    }
}
