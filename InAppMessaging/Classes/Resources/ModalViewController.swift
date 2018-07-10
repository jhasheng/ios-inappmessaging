/**
 * Class to handle building the modal view using the campaign data passed in.
 */
class ModalViewController: UIViewController {
    
    @IBOutlet var modalView: UIView!
    @IBOutlet weak var testLabel: UILabel!
    private var campaign: CampaignData?
    
    init(nibName: String?, bundle: Bundle?, campaign: CampaignData) {
        super.init(nibName: nibName, bundle: bundle)
        self.campaign = campaign
        
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
        testLabel.text = campaign?.messagePayload.messageBody // TODO(daniel.tam) Delete after finalizing modal view UI.
    }
}
