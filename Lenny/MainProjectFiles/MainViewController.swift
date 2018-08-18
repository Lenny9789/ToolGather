//
//  MainViewController.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/8.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit
import FSPagerView
import WHC_Layout
import SkeletonView
import Kingfisher
import Alamofire

class MainViewController: LennyBasicViewController {

    override var hasBottomTabbar: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
    }

    let mainPageView = FSPagerView.init(frame: CGRect.zero)
    
    private func setViews() {
        
        self.tabBarController?.navigationItem.title = "主页"
        contentView.backgroundColor = UIColor.cc_BackgroundLightBlack()
        contentView.addSubview(mainPageView)
        mainPageView.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 0)
        mainPageView.delegate = self
        mainPageView.dataSource = self
        mainPageView.interitemSpacing = 40
        mainPageView.isInfinite = true
        mainPageView.itemSize = CGSize.init(width: MainScreen.width - 100, height: MainScreen.height - navigationBarHeight - 200)
        mainPageView.alwaysBounceHorizontal = true
        mainPageView.register(ExchangeRateAbstractCell.self, forCellWithReuseIdentifier: "cell")
//        mainPageView.transformer = FSPagerViewTransformer.init(type: .linear)
    }
}

extension MainViewController: FSPagerViewDelegate {
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        
        let frame = CGRect.init(x: 50, y: navigationBarHeight + 100, width: MainScreen.width - 100, height: MainScreen.height - navigationBarHeight - 200)
        var vc: LennyBasicViewController = ViewController()
        if index == 0 { vc = ExchangeViewController()}
        if index == 1 { }
        vc.transitionBounds = frame
        lenny_Present(viewController: MainNavigationController(rootViewController: vc), animateType: .Custom, duration: 0.5, customAnimate: { (context) in
            
            let fromViewController = context.viewController(forKey: .from)
            let toViewController = context.viewController(forKey: .to)
            let containerView = context.containerView
            containerView.addSubview(fromViewController!.view)
            containerView.addSubview(toViewController!.view)
            toViewController?.view.frame = frame
            toViewController?.view.alpha = 0.2
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                toViewController?.view.frame = MainScreen
                toViewController!.view.alpha = 1
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
            })
        }) {}
        
        
    }
}

private let images = ["https://gratisography.com/thumbnails/gratisography-241-thumbnail.jpg"
                    , "https://gratisography.com/thumbnails/gratisography-364-thumbnail.jpg"
                    , "https://gratisography.com/thumbnails/gratisography-402-thumbnail.jpg"
                    , "https://gratisography.com/thumbnails/gratisography-391-thumbnail.jpg"]

extension MainViewController: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        return pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
    }
}

