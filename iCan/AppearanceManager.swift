//
//  AppearanceManager.swift
//  iCan
//
//  Created by Nicholas Laughter on 6/23/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import UIKit

class AppearanceManager {
    
    static func setUpTheme() {
        UINavigationBar.appearance().tintColor = UIColor(netHex: 0xA7A9AC)
        UINavigationBar.appearance().backgroundColor = UIColor(netHex: 0x3A3A3A)
        UINavigationBar.appearance().barTintColor = UIColor(netHex: 0x404042)
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        UILabel.appearance().textColor = UIColor.whiteColor()
        UITableView.appearance().backgroundColor = UIColor(netHex: 0x3A3A3A)
        UIToolbar.appearance().tintColor = UIColor(netHex: 0xA7A9AC)
        UIToolbar.appearance().barTintColor = UIColor(netHex: 0x3A3A3A)
        UITextField.appearance().backgroundColor = UIColor(netHex: 0x666666)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor(netHex: 0x2D2D2D)
    }
}