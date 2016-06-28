//
//  DefaultDetailViewController.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/22/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit

class DefaultDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        if UIApplication.sharedApplication().statusBarOrientation.isPortrait {
            let alert = UIAlertController(title: "Rotate to Landscape", message: "For the best user experience, rotate your device into landscape orientation.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
