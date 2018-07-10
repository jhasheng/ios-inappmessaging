/**
 * Class to handle building the modal view using the campaign data passed in.
 */
class ModalViewController: UIViewController {
    
    @IBOutlet var modalView: UIView!
    @IBOutlet weak var testLabel: UILabel!
    private var triggerName: String?
    
    init(nibName: String?, bundle: Bundle?, triggerName: String) {
        super.init(nibName: nibName, bundle: bundle)
        self.triggerName = triggerName
        
        self.modalPresentationStyle = .overCurrentContext
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "ModalViewController", bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let list = MessageMixerClient.sharedInstance.campaign
        let campaignToDisplay = CampaignParser().findMatchingTrigger(trigger: self.triggerName!, campaignListOptional: list)
        testLabel.text = campaignToDisplay?.messagePayload.messageBody // TODO(daniel.tam) Delete after finalizing modal view UI.
    }
}
