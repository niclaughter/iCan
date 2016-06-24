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
    }
}
