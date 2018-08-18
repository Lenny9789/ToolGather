//
//  LennyPullRefresh.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/16.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit

private var headerHeight: CGFloat = 64.0

extension UIScrollView {
    
    enum LennyPullRefreshStyle: Int {
        case Header
        case Footer
        case All
    }

    func setLennyRefresh(style: LennyPullRefreshStyle, delegate: LennyPullRefreshProtocol?) {
        
        delegate_ = delegate
        addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        isHeaderViewShouldStay = false
        switch style {
        case .Header:
            if headerView == nil { headerView = UIView() }
            break
        case .Footer:
            if footerView == nil { footerView = UIView() }
            break
        case .All:
            if headerView == nil { headerView = UIView() }
            if footerView == nil { footerView = UIView() }
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let keyPath = keyPath, keyPath == "contentOffset", let change = change {
            if let pointer = change[NSKeyValueChangeKey.newKey] as? CGPoint {
                print(pointer)
                scrollViewDidScrolling(contentOffset: pointer.y)
            }
        }
    }
    
    private func scrollViewDidScrolling(contentOffset: CGFloat) {
        
        if contentOffset < 0 {
            
            if abs(contentOffset) > headerHeight {
                headerView?.frame = CGRect.init(x: 0, y: abs(contentOffset) - headerHeight, width: MainScreen.width, height: headerHeight)
                contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0)
                isHeaderViewShouldStay = true
                if let delegate = delegate_ {
                    if delegate.responds(to: #selector(LennyPullRefreshProtocol.LennyPullRefreshDidPullDown)) {
                        delegate.LennyPullRefreshDidPullDown!()
                    }
                }
                return
            }
            if headerView?.superview != nil { headerView?.removeFromSuperview() }
            superview?.insertSubview(headerView!, at: 0)
            headerView?.backgroundColor = UIColor.alizarin
            headerView?.frame = CGRect.init(x: 0, y: 0, width: MainScreen.width, height: abs(contentOffset))
            if isHeaderViewShouldStay! {
                contentInset = UIEdgeInsetsMake(-contentOffset, 0, 0, 0)
            }
            
            
        }else {
            
        }
        
        if contentOffset == 0 {
            headerView?.removeFromSuperview()
        }
    }
    
    func didLennyRefreshCompeleted(style: LennyPullRefreshStyle) {
        switch style {
        case .Header:
//            isHeaderViewShouldStay = false
            UIView.animate(withDuration: 0.3) {
                self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
            break
        case .Footer:
            
            break
        default:
            break
        }
    }
    
    private var headerView: UIView? {
        get {
            return objc_getAssociatedObject(self, &header) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &header, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    private var footerView: UIView? {
        get {
            return objc_getAssociatedObject(self, &footer) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &footer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    private var isHeaderViewShouldStay: Bool? {
        get {
            return objc_getAssociatedObject(self, &isHeaderViewStay) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &isHeaderViewStay, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    private var delegate_: LennyPullRefreshProtocol? {
        get {
            return objc_getAssociatedObject(self, &delegateCus) as? LennyPullRefreshProtocol
        }
        set {
            objc_setAssociatedObject(self, &delegateCus, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private var delegateCus = "delegate"
private var isHeaderViewStay = "isHeaderViewShouldStay"
private var header = "header"
private var footer = "footer"

@objc protocol LennyPullRefreshProtocol: NSObjectProtocol {
    
    @objc optional func LennyPullRefreshDidPullDown() -> Void
    @objc optional func LennyPullRefreshDidPullUp() -> Void
}

