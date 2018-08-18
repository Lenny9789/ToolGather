//
//  TransitionAnimateManager.swift
//  TransitionTest
//
//  Created by Lenny on 2018/3/14.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

enum LennyTransitionAnimateType: UInt8 {
    case Default
    case Custom
    case PushFromRight
    case PushFromLeft
    case PushFromTop
    case PushFromBottom
    case PushAfterInside
    case Boom
    case SpreadFromRight
    case SpreadFromLeft
    case SpreadFromTop
    case SpreadFromBottom
}

class LennyTransitionAnimateManager: NSObject {
    
    private var transitionAnimateDuration: TimeInterval = 0.3
    
    func setTransitionAnimate(duration: TimeInterval) {
        transitionAnimateDuration = duration
    }
    
    private var transitionAnimateType: LennyTransitionAnimateType = .Default
    
    func setTransitionAnimate(type: LennyTransitionAnimateType) {
        transitionAnimateType = type
    }
    
    class var shared: LennyTransitionAnimateManager {
        struct Stat {
            static let instance = LennyTransitionAnimateManager.init()
        }
        return Stat.instance
    }
    
    enum ViewTransitionType: UInt8 {
        case push = 0
        case pop
        case present
        case dismiss
    }
    ///界面跳转的真实方式
    private var transitionType: ViewTransitionType = .push
    
    func setTransition(type: ViewTransitionType) {
        transitionType = type
    }
    ///使用系统自带的动画时发射的block
    private var didCAAnimationCompleted: ( () -> Void)?
    typealias CustomAnimate = ( (_ transitionContext: UIViewControllerContextTransitioning) -> Void)
    ///自定义动画Block
    private var customAnimate: CustomAnimate?
    func setTransitionCustomAnimate(animate: CustomAnimate?) {
        customAnimate = animate
    }
    
    private var percentDrivenTransition = UIPercentDrivenInteractiveTransition()
    func setPercentDrivenTransition(transition: UIPercentDrivenInteractiveTransition) {
        percentDrivenTransition = transition
    }
    func setPercentDrivenTransitionUpdate(progress: CGFloat) {
        percentDrivenTransition.update(progress)
    }
    func setPercentDrivenTransitionFinish() {
        percentDrivenTransition.finish()
    }
    func setPercentDrivenTransitionCancel() {
        percentDrivenTransition.cancel()
    }
}

extension LennyTransitionAnimateManager: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let didAnimateCompleted = didCAAnimationCompleted {
            didAnimateCompleted()
        }
    }
}

extension LennyTransitionAnimateManager: UIViewControllerAnimatedTransitioning {

    func animationEnded(_ transitionCompleted: Bool) {
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionAnimateDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        switch transitionType {
        case .push:
            push(by: transitionAnimateType, transitionContext: transitionContext)
            break
        case .pop:
            pop(by: transitionAnimateType, transitionContext: transitionContext)
            break
        case .present:
            present(by: transitionAnimateType, transitionContext: transitionContext)
            break
        case .dismiss:
            dismiss(by: transitionAnimateType, transitionContext: transitionContext)
        }
    }
}

/*
 
 */
extension LennyTransitionAnimateManager {
    
    func push(by animate: LennyTransitionAnimateType, transitionContext: UIViewControllerContextTransitioning) {
        
    }
    func pop(by animate: LennyTransitionAnimateType, transitionContext: UIViewControllerContextTransitioning) {
        
    }
    func present(by animate: LennyTransitionAnimateType, transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        
        if animate == .Custom {
            customAnimate?(transitionContext)
        }
        if animate == .PushFromRight {
            containerView.addSubview(fromViewController!.view)
            containerView.addSubview(toViewController!.view)
            toViewController!.view.transform = CGAffineTransform.init(translationX: screenWidth, y: 0)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                toViewController!.view.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .PushFromLeft {
            containerView.addSubview(fromViewController!.view)
            containerView.addSubview(toViewController!.view)
            toViewController!.view.transform = CGAffineTransform.init(translationX: -screenWidth, y: 0)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                toViewController!.view.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .PushFromBottom {
            containerView.addSubview(fromViewController!.view)
            containerView.addSubview(toViewController!.view)
            toViewController!.view.transform = CGAffineTransform.init(translationX: 0, y: screenHeight)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                toViewController!.view.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .PushFromTop {
            containerView.addSubview(fromViewController!.view)
            containerView.addSubview(toViewController!.view)
            toViewController!.view.transform = CGAffineTransform.init(translationX: 0, y: -screenHeight)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                toViewController!.view.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .PushAfterInside {
            containerView.addSubview(fromViewController!.view)
            containerView.addSubview(toViewController!.view)
            toViewController!.view.transform = CGAffineTransform.init(translationX: screenWidth, y: 0)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                fromViewController!.view.transform = CGAffineTransform.init(scaleX: 0.91, y: 0.95)
                toViewController!.view.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                fromViewController!.view.transform = CGAffineTransform.identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .Boom {
            containerView.addSubview(fromViewController!.view)
            containerView.addSubview(toViewController!.view)
            toViewController!.view.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: transitionAnimateDuration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1/0.8, options: UIViewAnimationOptions.init(rawValue: 0), animations: {
                toViewController!.view.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .SpreadFromRight {
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                fromViewController!.view.frame = CGRect.init(x: 0, y: 0, width: 0, height: screenHeight)
            }, completion: { (_ ) in
                fromViewController!.view.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .SpreadFromLeft {
            
            containerView.addSubview(fromViewController!.view)
            containerView.addSubview(toViewController!.view)
            let rect1 = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
            let rect0 = CGRect.init(x: 0, y: 0, width: 0, height: screenHeight)
            let startPath = UIBezierPath.init(rect: rect0)
            let endPath = UIBezierPath.init(rect: rect1)
            let animation = CABasicAnimation.init()
            animation.fromValue = startPath.cgPath
            animation.toValue = endPath.cgPath
            animation.duration = transitionAnimateDuration
            animation.delegate = self
            let maskLayer = CAShapeLayer()
            maskLayer.path = endPath.cgPath
            toViewController?.view.layer.mask = maskLayer
            maskLayer.add(animation, forKey: "path")
            didCAAnimationCompleted = {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    /*****************************************/
    ///Dismiss Animate
    func dismiss(by animate: LennyTransitionAnimateType, transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        
        if animate == .Custom {
            customAnimate?(transitionContext)
        }
        if animate == .PushFromRight {
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                fromViewController!.view.transform = CGAffineTransform.init(translationX: screenWidth, y: 0)
            }, completion: { (finished) in
                fromViewController!.view.transform = CGAffineTransform.identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .PushFromLeft {
            containerView.addSubview(fromViewController!.view)
            containerView.addSubview(toViewController!.view)
            containerView.bringSubview(toFront: fromViewController!.view)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                fromViewController!.view.transform = CGAffineTransform.init(translationX: -screenWidth, y: 0)
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .PushFromBottom {
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                fromViewController!.view.transform = CGAffineTransform.init(translationX: 0, y: screenHeight)
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .PushFromTop {
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                fromViewController!.view.transform = CGAffineTransform.init(translationX: 0, y: -screenHeight)
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .PushAfterInside {
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            toViewController!.view.transform = CGAffineTransform.init(scaleX: 0.91, y: 0.95)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                fromViewController!.view.transform = CGAffineTransform.init(translationX: screenWidth, y: 0)
                toViewController!.view.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                fromViewController!.view.transform = CGAffineTransform.identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .Boom {
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            UIView.animate(withDuration: transitionAnimateDuration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1/0.8, options: UIViewAnimationOptions.init(rawValue: 0), animations: {
                fromViewController!.view.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            }, completion: { (finished) in
                fromViewController!.view.transform = CGAffineTransform.identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .SpreadFromRight {
            containerView.addSubview(fromViewController!.view)
            containerView.addSubview(toViewController!.view)
            toViewController!.view.frame = CGRect.init(x: 0, y: 0, width: 0, height: screenHeight)
            UIView.animate(withDuration: transitionAnimateDuration, animations: {
                toViewController!.view.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
            }, completion: { (_ ) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
        if animate == .SpreadFromLeft {
            
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            let rect1 = CGRect.init(x: 0, y: 0, width: 0, height: screenHeight)
            let rect0 = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
            let startPath = UIBezierPath.init(rect: rect0)
            let endPath = UIBezierPath.init(rect: rect1)
            let animation = CABasicAnimation.init()
            animation.fromValue = startPath.cgPath
            animation.toValue = endPath.cgPath
            animation.duration = transitionAnimateDuration
            animation.delegate = self
            let maskLayer = CAShapeLayer()
            maskLayer.path = endPath.cgPath
            fromViewController?.view.layer.mask = maskLayer
            maskLayer.add(animation, forKey: "path")
            didCAAnimationCompleted = {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

/*
 NavigationController Delegate 的扩展
 */
extension LennyTransitionAnimateManager: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
}
///UIViewControllerTransitioningDelegate
extension LennyTransitionAnimateManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.percentDrivenTransition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.percentDrivenTransition
    }
    
}

extension LennyTransitionAnimateManager: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
}

private struct GesturePresentProperty {
    var viewControllerForPresent: UIViewController
    var animateType: LennyTransitionAnimateType
    var duration: TimeInterval?
    var customAnimate: LennyTransitionAnimateManager.CustomAnimate
    var completion: ( () -> Void)
}

private var presentGestureProperty = GesturePresentProperty(viewControllerForPresent: UIViewController(), animateType: LennyTransitionAnimateType.Default, duration: 0.3, customAnimate: { (_) in}) {}
private var dismissGestureProperty = GesturePresentProperty(viewControllerForPresent: UIViewController(), animateType: LennyTransitionAnimateType.Default, duration: 0.3, customAnimate: { (_) in}) {}

extension UIViewController {
    
    
    ///设置 VC可以手势驱动Present
    func lenny_OpenGesturePresent(to viewController: UIViewController, with panGestureFrom: UIRectEdge) {
        let pan = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(edgePanGesture(edgePan:)))
        pan.edges = panGestureFrom
        view.addGestureRecognizer(pan)
        lenny_OpenGesturePresent(viewController: viewController, animateType: .Default, duration: nil, customAnimate: { (_) in }) {}
    }
    
    func lenny_OpenGesturePresent(to viewController: UIViewController, with panGestureFrom: UIRectEdge, animateType: LennyTransitionAnimateType) {
        let pan = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(edgePanGesture(edgePan:)))
        pan.edges = panGestureFrom
        view.addGestureRecognizer(pan)
        lenny_OpenGesturePresent(viewController: viewController, animateType: animateType, duration: nil, customAnimate: { (_) in }) {}
    }
    
    /// 设置Presented 的VC 可以手势滑动返回
    func lenny_OpenGestureDismiss(with panGestureFrom: UIRectEdge) {
        let pan = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(edgePanGesture(edgePan:)))
        pan.edges = panGestureFrom
        view.addGestureRecognizer(pan)
        lenny_OpenGestureDismiss(animateType: .Default, duration: nil, customAnimate: { (_) in }) {}
    }
    
    func lenny_OpenGestureDismiss(with panGestureFrom: UIRectEdge, with animateType: LennyTransitionAnimateType) {
        let pan = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(edgePanGesture(edgePan:)))
        pan.edges = panGestureFrom
        view.addGestureRecognizer(pan)
        lenny_OpenGestureDismiss(animateType: animateType, duration: nil, customAnimate: { (_) in }) {}
    }
    
    func lenny_OpenGestureDismiss(panGestureFrom: UIRectEdge, customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate) {
        let pan = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(edgePanGesture(edgePan:)))
        pan.edges = panGestureFrom
        view.addGestureRecognizer(pan)
        lenny_OpenGestureDismiss(animateType: .Custom, duration: nil, customAnimate: customAnimate) {}
    }
    @objc private func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = abs(edgePan.translation(in: UIApplication.shared.keyWindow!).x) / UIApplication.shared.keyWindow!.bounds.width
        
        if edgePan.state == UIGestureRecognizerState.began {
            LennyTransitionAnimateManager.shared.setPercentDrivenTransition(transition: UIPercentDrivenInteractiveTransition())
            if edgePan.edges == UIRectEdge.right {
                lenny_Present(viewController: presentGestureProperty.viewControllerForPresent, animateType: presentGestureProperty.animateType, duration: presentGestureProperty.duration, customAnimate: presentGestureProperty.customAnimate, complettion: presentGestureProperty.completion)
            } else if edgePan.edges == UIRectEdge.left {
                lenny_Dismiss(animateType: dismissGestureProperty.animateType, duration: dismissGestureProperty.duration, customAnimate: dismissGestureProperty.customAnimate, complettion: dismissGestureProperty.completion)
            }
        } else if edgePan.state == UIGestureRecognizerState.changed {
            LennyTransitionAnimateManager.shared.setPercentDrivenTransitionUpdate(progress: progress)
        } else if edgePan.state == UIGestureRecognizerState.cancelled || edgePan.state == UIGestureRecognizerState.ended {
            if progress > 0.5 {
                LennyTransitionAnimateManager.shared.setPercentDrivenTransitionFinish()
            } else {
                LennyTransitionAnimateManager.shared.setPercentDrivenTransitionCancel()
            }
        }
    }
    
    private func lenny_OpenGesturePresent(viewController: UIViewController, animateType: LennyTransitionAnimateType, duration: TimeInterval?, customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate, complettion: @escaping ( () -> Void)) {
        presentGestureProperty.viewControllerForPresent = viewController
        presentGestureProperty.animateType = animateType
        presentGestureProperty.duration = duration
        presentGestureProperty.customAnimate = customAnimate
        presentGestureProperty.completion = complettion
    }
    private func lenny_OpenGestureDismiss(animateType: LennyTransitionAnimateType, duration: TimeInterval?, customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate, complettion: @escaping ( () -> Void)) {
        dismissGestureProperty.animateType = animateType
        dismissGestureProperty.duration = duration
        dismissGestureProperty.customAnimate = customAnimate
        dismissGestureProperty.completion = complettion
    }
    /**************************************************************/
    
    func lenny_Present(viewController: UIViewController) {
        lenny_Present(viewController: viewController, animateType: .Default, duration: nil, customAnimate: { (_) in }) {}
    }
    func lenny_Present(viewController: UIViewController, completion: @escaping (() -> Void)) {
        lenny_Present(viewController: viewController, animateType: .Default, duration: nil, customAnimate: { (_) in }) { completion() }
    }
    func lenny_Present(viewController: UIViewController, duration: TimeInterval) {
        lenny_Present(viewController: viewController, animateType: .Default, duration: duration, customAnimate: { (_) in }) {}
    }
    func lenny_Present(viewController: UIViewController, duration: TimeInterval, completion: @escaping ( () -> Void)) {
        lenny_Present(viewController: viewController, animateType: .Default, duration: duration, customAnimate: { (_) in }) { completion() }
    }
    func lenny_Present(viewController: UIViewController, animateType: LennyTransitionAnimateType) {
        lenny_Present(viewController: viewController, animateType: animateType, duration: nil, customAnimate: { (_) in }) {}
    }
    func lenny_Present(viewController: UIViewController, animateType: LennyTransitionAnimateType, completion: @escaping ( () -> Void)) {
        lenny_Present(viewController: viewController, animateType: animateType, duration: nil, customAnimate: { (_) in }) { completion() }
    }
    func lenny_Present(viewController: UIViewController, duration: TimeInterval, animateType: LennyTransitionAnimateType) {
        lenny_Present(viewController: viewController, animateType: animateType, duration: duration, customAnimate: { (_) in }) {}
    }
    func lenny_Present(viewController: UIViewController, duration: TimeInterval, animateType: LennyTransitionAnimateType, completion: @escaping ( () -> Void)) {
        lenny_Present(viewController: viewController, animateType: animateType, duration: duration, customAnimate: { (_) in }) { completion() }
    }

    func lenny_Present(viewController: UIViewController, customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate) {
        lenny_Present(viewController: viewController, animateType: .Custom, duration: nil, customAnimate: customAnimate) {}
    }
    func lenny_Present(viewController: UIViewController, customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate, completion: @escaping ( () -> Void)  ) {
        lenny_Present(viewController: viewController, animateType: .Custom, duration: nil, customAnimate: customAnimate) { completion() }
    }
    func lenny_Present(viewController: UIViewController, customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate, duration: TimeInterval) {
        lenny_Present(viewController: viewController, animateType: .Custom, duration: duration, customAnimate: customAnimate) {}
    }
    func lenny_Present(viewController: UIViewController, customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate, duration: TimeInterval, completion: @escaping ( () -> Void)) {
        lenny_Present(viewController: viewController, animateType: .Custom, duration: duration, customAnimate: customAnimate) { completion() }
    }
    func lenny_Present(viewController: UIViewController, animateType: LennyTransitionAnimateType, duration: TimeInterval?, customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate, complettion: @escaping ( () -> Void)) {
        
        LennyTransitionAnimateManager.shared.setTransitionAnimate(type: animateType)
        if let duration = duration  {
            LennyTransitionAnimateManager.shared.setTransitionAnimate(duration: duration)
        }
        if animateType == .Custom {
            LennyTransitionAnimateManager.shared.setTransitionCustomAnimate(animate: customAnimate)
        }
        if animateType == .Default {
            LennyTransitionAnimateManager.shared.setTransitionAnimate(type: .PushFromBottom)
        }
        LennyTransitionAnimateManager.shared.setTransition(type: .present)
        viewController.transitioningDelegate = LennyTransitionAnimateManager.shared
        self.present(viewController, animated: true, completion: complettion)
    }
    
    /*******************************************************************/
    func lenny_Dismiss() {
        lenny_Dismiss(animateType: .Default, duration: nil, customAnimate: { (_) in }) {}
    }
    func lenny_Dismiss(completion: @escaping (() -> Void)) {
        lenny_Dismiss(animateType: .Default, duration: nil, customAnimate: { (_) in }) { completion() }
    }
    func lenny_Dismiss(duration: TimeInterval) {
        lenny_Dismiss(animateType: .Default, duration: duration, customAnimate: { (_) in }) {}
    }
    func lenny_Dismiss(duration: TimeInterval, completion: @escaping ( () -> Void)) {
        lenny_Dismiss(animateType: .Default, duration: duration, customAnimate: { (_) in }) { completion() }
    }
    func lenny_Dismiss(animateType: LennyTransitionAnimateType) {
        lenny_Dismiss(animateType: animateType, duration: nil, customAnimate: { (_) in }) {}
    }
    func lenny_Dismiss(animateType: LennyTransitionAnimateType, completion: @escaping ( () -> Void)) {
        lenny_Dismiss(animateType: animateType, duration: nil, customAnimate: { (_) in }) { completion() }
    }
    func lenny_Dismiss(duration: TimeInterval, animateType: LennyTransitionAnimateType) {
        lenny_Dismiss(animateType: animateType, duration: duration, customAnimate: { (_) in }) {}
    }
    func lenny_Dismiss(duration: TimeInterval, animateType: LennyTransitionAnimateType, completion: @escaping ( () -> Void)) {
        lenny_Dismiss(animateType: animateType, duration: duration, customAnimate: { (_) in }) { completion() }
    }
    
    func lenny_Dismiss(customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate) {
        lenny_Dismiss(animateType: .Custom, duration: nil, customAnimate: customAnimate) {}
    }
    func lenny_Dismiss(customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate, completion: @escaping ( () -> Void)  ) {
        lenny_Dismiss(animateType: .Custom, duration: nil, customAnimate: customAnimate) { completion() }
    }
    func lenny_Dismiss(customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate, duration: TimeInterval) {
        lenny_Dismiss(animateType: .Custom, duration: duration, customAnimate: customAnimate) {}
    }
    func lenny_Dismiss(customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate, duration: TimeInterval, completion: @escaping ( () -> Void)) {
        lenny_Dismiss(animateType: .Custom, duration: duration, customAnimate: customAnimate) { completion() }
    }
    func lenny_Dismiss(animateType: LennyTransitionAnimateType, duration: TimeInterval?, customAnimate: @escaping LennyTransitionAnimateManager.CustomAnimate, complettion: @escaping ( () -> Void)) {
        
        LennyTransitionAnimateManager.shared.setTransitionAnimate(type: animateType)
        if let duration = duration  {
            LennyTransitionAnimateManager.shared.setTransitionAnimate(duration: duration)
        }
        if animateType == .Custom {
            LennyTransitionAnimateManager.shared.setTransitionCustomAnimate(animate: customAnimate)
        }
        if animateType == .Default {
            LennyTransitionAnimateManager.shared.setTransitionAnimate(type: .PushFromBottom)
        }
        LennyTransitionAnimateManager.shared.setTransition(type: .dismiss)
        self.transitioningDelegate = LennyTransitionAnimateManager.shared
        self.dismiss(animated: true, completion: complettion)
    }
}

extension UINavigationController {
    
    func lenny_Push(viewController: UIViewController, duration: TimeInterval?) {
        if let duration = duration {
            LennyTransitionAnimateManager.shared.setTransitionAnimate(duration: duration)
        }
        self.delegate = LennyTransitionAnimateManager.shared
        self.pushViewController(viewController, animated: true)
    }
    
    func lenny_Pop(duration: TimeInterval?) {
        if let duration = duration {
            LennyTransitionAnimateManager.shared.setTransitionAnimate(duration: duration)
        }
        self.navigationController?.delegate = LennyTransitionAnimateManager.shared
        self.navigationController?.popViewController(animated: true)
    }
}




