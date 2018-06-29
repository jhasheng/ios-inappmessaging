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
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
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
//        modalView.backgroundColor = UIColor.clear
////        modalView.isOpaque = false
        testLabel.text = "abcd"
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        modalView.backgroundColor = UIColor.clear
//        //        modalView.isOpaque = false
//        testLabel.text = "abcd"
    }
    
}
