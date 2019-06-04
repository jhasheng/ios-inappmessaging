//import UIKit
//import SDWebImage
//
///**
// * Class that initializes the fullscreen view using the passed in campaign information to build the UI.
// */
//class FullScreenView: UIView, IAMView, ImpressionTrackable {
//    // ImpressionTrackable stubs
//    var impressions: [Impression]
//    var campaign: CampaignData?
//    
//    func logImpression(withImpressionType type: ImpressionType) {
//        //
//    }
//    
//    var dialogView: UIView
//
//    convenience init(withCampaign campaign: CampaignData, andImage image: UIImage?) {
//        self.init(frame: UIScreen.main.bounds)
//        self.campaign = campaign
//        self.initializeView(withCampaign: campaign, andImage: image)
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
