//
//  LennyTabBar.swift
//  LennyTab
//
//  Created by Lenny's Macbook Pro on 8/2/20.
//  Copyright © 2020 Lenny Piao. All rights reserved.
//

import UIKit


enum LennyCenterButtonStyle: Int {
    case center = 0
    case bulge
}


class LennyTabBar: UITabBar {

    let height_TabBar: CGFloat = 49
    
    var button_Center: UIButton = UIButton.init(type: .custom)
    
    var image_Center: UIImage? {
        didSet {
            if width_CenterButton <= 0 && height_CenterButton <= 0 {
                width_CenterButton = image_Center?.size.width ?? 0
                height_CenterButton = image_Center?.size.height ?? 0
            }
            button_Center.setImage(image_Center, for: .normal)
        }
    }

    var image_CenterSelected: UIImage? {
        didSet {
            button_Center.setImage(image_CenterSelected, for: .selected)
        }
    }
    
    var style_Center: LennyCenterButtonStyle = .center
    
    var width_CenterButton: CGFloat = 0
    var height_CenterButton: CGFloat = 0
    
    var offset_CenterButton: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button_Center.adjustsImageWhenHighlighted = false
        addSubview(button_Center)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch style_Center {
        case .center:
            button_Center.frame = CGRect(x: (UIScreen.main.bounds.size.width - width_CenterButton)/2.0, y: (height_TabBar - height_CenterButton)/2.0, width: width_CenterButton, height: height_CenterButton)
        case .bulge:
            button_Center.frame = CGRect(x: (UIScreen.main.bounds.size.width - width_CenterButton)/2.0, y: -height_CenterButton/2.0 + offset_CenterButton, width: width_CenterButton, height: height_CenterButton)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden == false {
            let tempPoint = button_Center.convert(point, from: self)
            if button_Center.bounds.contains(tempPoint) {
                return button_Center
            }
        }
        return super.hitTest(point, with: event)
    }
    
}
