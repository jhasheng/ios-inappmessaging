import UIKit
import SDWebImage

/**
 * Class that initializes the fullscreen view using the passed in campaign information to build the UI.
 */
class FullScreenView: UIView, NewIAMView {
    // ImpressionTrackable stubs
    var impressions: [Impression] = []
    var campaign: CampaignData?
    
    // NewIAMView stubs
    var backgroundView: UIView?
    var textView: UITextView?
    var image: UIImage?
    var dialogView = UIView()
    
    // Variables
    var dialogViewWidth: CGFloat = UIScreen.main.bounds.width
    var horizontalSpacingOffset: CGFloat = 40

    
    func logImpression(withImpressionType type: ImpressionType) {
        //
    }
    

    convenience init(withCampaign campaign: CampaignData, andImage image: UIImage?) {
        self.init(frame: UIScreen.main.bounds)
        self.campaign = campaign
        self.image = image
        
        if campaign.messagePayload.header != nil ||
            campaign.messagePayload.messageBody != nil {
            
                self.textView = UITextView()
        }
        
        self.initializeView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
