//
//  ViewController.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/8.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit

class ViewController: LennyBasicViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
    }

    private func setViews() {
        lenny_OpenGestureDismiss(panGestureFrom: .left) { (context) in
            
            let fromViewController = context.viewController(forKey: .from)
            let toViewController = context.viewController(forKey: .to)
            let containerView = context.containerView
            
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            let originalFrame = fromViewController?.view.frame
            UIView.animate(withDuration: 0.3, animations: {
                fromViewController?.view.frame = self.transitionBounds
                fromViewController!.view.alpha = 0
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
                fromViewController?.view.frame = originalFrame!
                fromViewController?.view.alpha = 1.0
            })
            
        }
        view.backgroundColor = UIColor.cc_BackgroundLightBlack()
    }
    

}

