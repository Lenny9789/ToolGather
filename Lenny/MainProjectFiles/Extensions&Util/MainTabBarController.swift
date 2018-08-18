//
//  MainTabBarController.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/9.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit
import ESTabBarController_swift


class MainTabBarController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
    }

    private func setViews() {
        
        if let tabBar = tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = ESTabBarItemPositioning.fillIncludeSeparator
            
        }
        
        let v1 = MainViewController()
        let v2 = ExchangeViewController()
        let v3 = StockViewController()
        let v4 = ViewController()
        let v5 = ViewController()
        
        
        v1.tabBarItem = ESTabBarItem.init(TabBarItemContentView(),title: nil, image: UIImage(named: "home_icon_off"), selectedImage: UIImage(named: "home_icon_on"))
        v4.tabBarItem = ESTabBarItem.init(TabBarItemContentView(), title: nil, image: UIImage(named: "Quotes_icon_off"), selectedImage: UIImage(named: "Quotes_icon_on"))
        v2.tabBarItem = ESTabBarItem.init(TabBarItemContentView(), title: nil, image: UIImage(named: "Conversion_icon_off"), selectedImage: UIImage(named: "Conversion_icon_on"))
        v3.tabBarItem = ESTabBarItem.init(TabBarItemContentView(), title: nil, image: UIImage(named: "stock_icon_off"), selectedImage: UIImage(named: "stock_icon_on"))
        v5.tabBarItem = ESTabBarItem.init(TabBarItemContentView(), title: nil, image: UIImage(named: "Information_icon_off"), selectedImage: UIImage(named: "Information_icon_on"))
        
        viewControllers = [v1, v2, v3, v4, v5]
    
    }
}

class TabBarItemContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.init(white: 165.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 165.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        backdropColor = UIColor.init(red: 37/255.0, green: 39/255.0, blue: 42/255.0, alpha: 1.0)
        highlightBackdropColor = UIColor.init(red: 22/255.0, green: 24/255.0, blue: 25/255.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
