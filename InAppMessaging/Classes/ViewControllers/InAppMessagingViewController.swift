/**
 * Handle all the displaying logic of the SDK.
 */
class InAppMessagingViewController: UIViewController {
    
//    internal static var campaigns: [CampaignData] = []
    
    /**
     * Fetches a list of campaigns that matches the eventType
     * and then display the returned campaigns.
     * @param { eventType: Int } Enum value of the event type.
     */
    internal class func display(_ eventType: Int) {
        // Fetch matching campaigns.
//        self.campaigns = CampaignHelper.fetchCampaigns(withEventType: eventType)
        
        // Display first campaign if the ready campaign list is not empty.
        if let firstCampaign = ReadyCampaignRepository.getFirst() {
            displayIndividualCampaign(firstCampaign)
        }
    }
    
    /**
     * Contains logic to display the correct view type -- modal, slideup, fullscreen, html -- and create
     * a view controller to present a single campaign.
     */
    internal class func displayIndividualCampaign(_ campaign: Campaign) {
        
        // Display first campaign.
        guard let campaignViewType = CampaignHelper.findViewType(campaign: campaign.campaignData) else {
            return
        }
        
        // Permission check here.
//        if !PermissionClient().checkPermission(withCampaign: firstCampaignInlist){
//            return
//        }
        
        DispatchQueue.main.async {
            var view: Modal?
            
            // TODO(daniel.tam) Add the other view types.
            switch campaignViewType {
            case .modal:
                view = ModalView(campaign.campaignData)
                break
            case .invalid:
                break
            case .full:
                break
            case .slide:
                break
            case .html:
                break
            }
            
            // Display the campaign if the view exists.
            if let viewToDisplay = view {
//                CampaignHelper.appendShownCampaign(campaignId: firstCampaignInlist.campaignId)
                ShownRepository.addCampaign(campaign)
                viewToDisplay.show()
                ReadyCampaignRepository.removeFirst()
//                self.campaigns.removeFirst()
            }
        }    }
}
