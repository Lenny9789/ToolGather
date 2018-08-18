//
//  DataAbstractCell.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/9.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit
import FSPagerView
import SkeletonView

class ExchangeRateAbstractCell: FSPagerViewCell {

    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        isSkeletonable = true
        contentView.addSubview(titleLabel)
        contentView.isSkeletonable = true
        contentView.backgroundColor = UIColor.cc_NavigationBarLightBlack()
        
        titleLabel.whc_CenterX(0).whc_Top(0).whc_Left(0).whc_Right(0).whc_Height(30)
        titleLabel.textColor = UIColor.cc_Blue()
        titleLabel.text = "汇率"
        titleLabel.textAlignment = .center
        let line = UIView()
        contentView.addSubview(line)
        line.backgroundColor = UIColor.cc_BackgroundLightBlack()
        line.whc_Top(0, toView: titleLabel).whc_Left(0).whc_Right(0).whc_Height(5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
    }

}
