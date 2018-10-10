/**
 * Handle all the displaying logic of the SDK.
 */
class InAppMessagingViewController: UIViewController {
    
    internal static var semaphore = DispatchSemaphore(value: 1)
    internal static var campaigns: [CampaignData] = []
    
    
    internal class func displayIndividualCampaign() {
        
        // Display first campaign.
        if !self.campaigns.isEmpty {
            
            guard let firstCampaignInlist = self.campaigns.first,
                let campaignViewType = CampaignHelper.findViewType(campaign: firstCampaignInlist)
            else {
                return
            }
            
            // Permission check here.
            if !PermissionClient().checkPermission(withCampaign: firstCampaignInlist){
                return
            }
            
            DispatchQueue.main.async {
                var view: Modal?
                
                // TODO(daniel.tam) Add the other view types.
                switch campaignViewType {
                case .modal:
                    view = ModalView(campaign: firstCampaignInlist)
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
                    CampaignHelper.appendShownCampaign(campaignId: firstCampaignInlist.campaignId)
                    viewToDisplay.show()
                    self.campaigns.removeFirst()
                }
            }
        }
    }
    
    /**
     * Contains logic to display the correct view type -- modal, slideup, fullscreen, html -- and create
     * a view controller to present.
     * @param { eventType: Int } Enum value of the event type.
     */
    internal class func display(_ eventType: Int) {
        // Fetch matching campaigns and assign to .
        self.campaigns = CampaignHelper.fetchCampaigns(withEventType: eventType)
        
        // Display first campaign.
        if !self.campaigns.isEmpty {
            displayIndividualCampaign()
        }
    }
}
