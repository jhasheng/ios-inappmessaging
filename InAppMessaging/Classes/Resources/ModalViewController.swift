//
//  ModalViewController.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 6/28/18.
//

import UIKit

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
    
    override func viewDidLoad() {
//        let list = MessageMixerClient.sharedInstance.campaign
//        let campaignToDisplay = CampaignParser().findMatchingTrigger(trigger: self.triggerName!, campaignListOptional: list)
//        self.testLabel.text = campaignToDisplay?.messagePayload.messageBody
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        testLabel.text = "abcd" // TESTING. Remove later.
        
            let list = MessageMixerClient.sharedInstance.campaign
            let campaignToDisplay = CampaignParser().findMatchingTrigger(trigger: self.triggerName!, campaignListOptional: list)
            testLabel.text = campaignToDisplay?.messagePayload.messageBody
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let list = MessageMixerClient.sharedInstance.campaign
//        let campaignToDisplay = CampaignParser().findMatchingTrigger(trigger: self.triggerName!, campaignListOptional: list)
//        self.testLabel.text = campaignToDisplay?.messagePayload.messageBody
    }
}
