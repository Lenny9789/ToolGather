//
//  MainExtension.swift
//  SinglePages
//
//  Created by Lenny's Macbook Air on 2018/5/2.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func ccolor(with r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    static func mainColor() -> UIColor {
        return UIColor.ccolor(with: 236, g: 40, b: 40)
    }
    
    static func cc_191() -> UIColor {
        return UIColor.ccolor(with: 191, g: 191, b: 191)
    }
    static func cc_224() -> UIColor {
        return UIColor.ccolor(with: 224, g: 224, b: 224)
    }
    static func cc_136() -> UIColor {
        return UIColor.ccolor(with: 136, g: 136, b: 136)
    }
    static func cc_51() -> UIColor {
        return UIColor.ccolor(with: 51, g: 51, b: 51)
    }
    static func cc_71() -> UIColor {
        return UIColor.ccolor(with: 71, g: 71, b: 71)
    }
    static func cc_NavigationBarLightBlack() -> UIColor {
        return UIColor.ccolor(with: 46, g: 49, b: 57)
    }
    static func cc_BackgroundLightBlack() -> UIColor {
        return UIColor.ccolor(with: 29, g: 31, b: 39)
    }
    static func cc_Blue() -> UIColor {
        return UIColor.ccolor(with: 62, g: 115, b: 234)
    }
}

extension UIApplication {
    
    func navigationController() -> UINavigationController? {
        return  self.keyWindow?.rootViewController as? UINavigationController
    }
}

public let MainScreen = UIScreen.main.bounds

extension UIView {
    
    var viewController: UIViewController? {
        
        var vc: UIViewController?
        var next_Respoder: UIResponder? = self.next
        while let next = next_Respoder {
            
            if next is UIViewController {
                vc = next as? UIViewController
                break
            }
            next_Respoder = next_Respoder?.next
        }
        return vc
    }
}
