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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goToSecondPage(_:)),
                                               name: Notification.Name("showSecondPage"),
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func purchaseSuccessfulButton(_ sender: Any) {
        InAppMessaging.logEvent(
            PurchaseSuccessfulEvent.init(
                withPurchaseAmount: 20,
                withNumberOfItems: 2,
                withCurrencyCode: "USD",
                withItems: []))
    }
    @IBAction func loginSuccessfulButton(_ sender: Any) {
        InAppMessaging.logEvent(LoginSuccessfulEvent())
    }
    @IBAction func customTestButton(_ sender: Any) {
        InAppMessaging.logEvent(
            CustomEvent(
                withName: "second activity",
                withCustomAttributes: [CustomAttribute(withKeyName: "click", withBoolValue: true)]
            )
        )        
    }
    
    @IBAction func appStartButton(_ sender: Any) {
        InAppMessaging.logEvent(AppStartEvent())
    }
    
    @IBAction func goToSecondPage(_ sender: Any) {
        // Register Nib
        let newViewController = SecondPageViewController(nibName: "SecondPageViewController", bundle: nil)
        self.present(newViewController, animated: true, completion: nil)
    }
}
