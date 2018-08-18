//
//  MainWebViewController.swift
//  LDC
//
//  Created by Lenny's Macbook Pro on 2018/7/30.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit
import WebKit



private let base_Url = "http://www.ldc8.com"

class MainWebViewController: LennyBasicViewController {

    private let mainWebView = WKWebView.init()
    private let mainProgress = UIProgressView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
    }

    override var hasNavigationBar: Bool {
        return false
    }
    
    private func setViews() {
    
        self.view.backgroundColor = UIColor.cc_191()
        contentView.addSubview(mainWebView)
        mainWebView.uiDelegate = self
        mainWebView.navigationDelegate = self
        mainWebView.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 0)
        contentView.addSubview(mainProgress)
        mainProgress.whc_Left(0).whc_Right(0).whc_Top(0).whc_Height(2)
        mainProgress.progressViewStyle = .bar
        mainProgress.progressTintColor = UIColor.orange
        mainWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainWebView.load(URLRequest.init(url: URL.init(string: "https://ldc8.com")!))
        print(contentView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            mainProgress.alpha = 1.0
            mainProgress.setProgress(Float(mainWebView.estimatedProgress), animated: true)
            if mainWebView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.mainProgress.alpha = 0
                }, completion: { (finish) in
                    self.mainProgress.setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    deinit {
        mainWebView.removeObserver(self, forKeyPath: "estimatedProgress")
        mainWebView.uiDelegate = nil
        mainWebView.navigationDelegate = nil
    }
}

extension MainWebViewController: WKUIDelegate {
    
}

extension MainWebViewController: WKNavigationDelegate {
    
}
