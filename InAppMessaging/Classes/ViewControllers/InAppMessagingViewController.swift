/**
 * Handle all the displaying logic of the SDK.
 */
class InAppMessagingViewController: UIViewController {
    
    /**
     * Contains logic to display the correct view type -- modal, slideup, fullscreen, html -- and create
     * a view controller to present.
     * @param { eventType: Int } Enum value of the event type.
     */
    internal class func display(_ eventType: Int) {
        
        // Fetch matching campaign and get its view type.
        guard let campaignToDisplay = CampaignHelper.fetchCampaign(withEventType: eventType),
            let campaignViewType = CampaignHelper.findViewType(campaign: campaignToDisplay) else {
            
                return
        }
        
        // Permission check here.
        if !PermissionClient().checkPermission(withCampaign: campaignToDisplay){
            return
        }
        
        DispatchQueue.main.async {
            var view: Modal?
            
            // TODO(daniel.tam) Add the other view types.
            switch campaignViewType {
            case .modal:
                view = ModalView(campaign: campaignToDisplay)
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
                CampaignHelper.appendShownCampaign(campaignId: campaignToDisplay.campaignId)
                viewToDisplay.show()
            }
        }
    }
}
