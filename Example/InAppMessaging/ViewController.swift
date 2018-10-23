//
//  ViewController.swift
//  InAppMessaging
//
//  Created by dctam on 04/11/2018.
//  Copyright (c) 2018 dctam. All rights reserved.
//

import UIKit
import InAppMessaging

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showModalButton(_ sender: Any) {
        InAppMessaging.logEvent(PurchaseSuccessfulEvent(withCustomAttributes: nil))
    }
    @IBAction func loginSuccessfulButton(_ sender: Any) {
        InAppMessaging.logEvent(LoginSuccessfulEvent(withCustomAttributes: nil))
    }
}
