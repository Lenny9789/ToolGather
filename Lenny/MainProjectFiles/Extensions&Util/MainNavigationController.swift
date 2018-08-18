//
//  MainNavigationController.swift
//  SinglePages
//
//  Created by Lenny's Macbook Air on 2018/5/4.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
    }

    private func setViews() {
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
        navigationBar.barTintColor = UIColor.cc_NavigationBarLightBlack()
        navigationBar.tintColor = UIColor.cc_Blue()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -100, vertical: 0), for: .default)
    }
    
}
