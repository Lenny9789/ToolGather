//
//  LennyTabBarController.swift
//  LennyTab
//
//  Created by Lenny's Macbook Pro on 8/2/20.
//  Copyright © 2020 Lenny Piao. All rights reserved.
//

import UIKit

class LennyTabBarController: UITabBarController {

    var lyTabBar = LennyTabBar.init(frame: CGRect.zero)
    
    weak var lyDelegate: LennyTabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        lyTabBar.button_Center.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        setValue(lyTabBar, forKey: "tabBar")
    }

    @objc private func buttonAction() {
        let count = viewControllers?.count ?? 0
        selectedIndex = count/2
        tabBarController(self, didSelect: viewControllers![selectedIndex])
    }
}

extension LennyTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        lyTabBar.button_Center.isSelected = (tabBarController.selectedIndex == (viewControllers?.count)!/2)
        lyDelegate?.lyTabBarController(tabBarController, didSelect: viewController)
    }
}

protocol LennyTabBarControllerDelegate : NSObjectProtocol {
     func lyTabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
}
