//
//  ExchangeViewController.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/10.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit
import WHC_KeyboardManager
import SkeletonView

class ExchangeViewController: LennyBasicViewController {

    
    override var skeletonGradient: SkeletonGradient {
        return SkeletonGradient.init(baseColor: UIColor.cc_NavigationBarLightBlack(), secondaryColor: UIColor.cc_BackgroundLightBlack())
    }
    override func loadNetRequestWithViewSkeleton(animate: Bool) {
        super.loadNetRequestWithViewSkeleton(animate: animate)
        
        LennyNetworkRequest.obtainNormallyExchangeRate { (model) in
            self.hiddenSkeletonViewAnimation()
            if let model = model {
                
//                print(model)
//                print(model.error_code)
//                print(model.reason)
//                print(model.result)
//                print(model.result?.list)
                if self.cells.count > 0 { self.cells.removeAll()}
                for item in model.result!.list! {
                    let cell = ExchangeTableViewCell.init(style: .default, reuseIdentifier: "cell")
                    cell.data = item
                    self.cells.append(cell)
                }
            }
            self.mainTableView.reloadData()
        }
    }
    
    var cells: [UITableViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WHC_KeyboardManager.share.addMonitorViewController(self)
        setView()
        
        loadNetRequestWithViewSkeleton(animate: true)
    }
    
    private let mainTableView = UITableView.init()
    
    private func setView() {
        
        mainTableView.setLennyRefresh(style: .All, delegate: self)
        
        lenny_OpenGestureDismiss(panGestureFrom: .left) { (context) in
            
            let fromViewController = context.viewController(forKey: .from)
            let toViewController = context.viewController(forKey: .to)
            let containerView = context.containerView
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            
            let scaleX: CGFloat = (MainScreen.width - 100)/MainScreen.width
            let scaleY: CGFloat = (MainScreen.height - self.navigationBarHeight - 200)/MainScreen.height
            UIView.animate(withDuration: 0.3, animations: {
                fromViewController!.view.transform = CGAffineTransform.init(scaleX: scaleX, y: scaleY)
                fromViewController!.view.alpha = 0.2
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
                fromViewController?.view.transform = CGAffineTransform.identity
                fromViewController?.view.alpha = 1.0
            })
            
        }
        
        self.tabBarController?.navigationItem.title = "汇率"
        self.navigationController?.navigationBar.tintColor = UIColor.cc_NavigationBarLightBlack()
        self.contentView.backgroundColor = UIColor.cc_BackgroundLightBlack()
        contentView.backgroundColor = UIColor.cc_BackgroundLightBlack()
        contentView.addSubview(mainTableView)
        mainTableView.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 0)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.tableFooterView = UIView()
        mainTableView.estimatedRowHeight = 80
        mainTableView.rowHeight = UITableViewAutomaticDimension
        mainTableView.backgroundColor = UIColor.clear
        mainTableView.separatorStyle = .none
        mainTableView.allowsSelection = false
        mainTableView.isSkeletonable = true
        mainTableView.register(ExchangeTableViewCell.self, forCellReuseIdentifier: "CellIdentitifier")
        let rightBarButton = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.done, target: self, action: #selector(rightBarButtonAction))
        self.navigationItem.rightBarButtonItem = rightBarButton
        let leftBarButton = UIBarButtonItem.init(title: "返回", style: .done, target: self, action: #selector(leftBarButtonAction))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func rightBarButtonAction() {
        self.view.endEditing(true)
    }
    @objc private func leftBarButtonAction() {
        
        lenny_Dismiss { (context) in
            
            let fromViewController = context.viewController(forKey: .from)
            let toViewController = context.viewController(forKey: .to)
            let containerView = context.containerView
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            
            let scaleX: CGFloat = (MainScreen.width - 100)/MainScreen.width
            let scaleY: CGFloat = (MainScreen.height - self.navigationBarHeight - 200)/MainScreen.height
            UIView.animate(withDuration: 0.3, animations: {
                fromViewController!.view.transform = CGAffineTransform.init(scaleX: scaleX, y: scaleY)
                fromViewController!.view.alpha = 0.2
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
                fromViewController?.view.transform = CGAffineTransform.identity
                fromViewController?.view.alpha = 1.0
            })
        }
    }
}

private let cellss = ["CNY", "USD", "EUR", "GBP", "JPY", "HKD"]

extension ExchangeViewController: LennyPullRefreshProtocol {
    
    func LennyPullRefreshDidPullDown() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.mainTableView.didLennyRefreshCompeleted(style: .Header)
        }
    }
}

extension ExchangeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
extension ExchangeViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CellIdentitifier"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init()
        label.textColor = UIColor.cc_191()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.text = "当前货币（100）兑人民币"
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cells[indexPath.row]
    }
}
