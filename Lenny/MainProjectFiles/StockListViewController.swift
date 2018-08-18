//
//  StockListViewController.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/13.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit
import SkeletonView

class StockListViewController: LennyBasicViewController {

//    override var skeletonGradient: SkeletonGradient {
//        return SkeletonGradient.init(baseColor: UIColor.cc_71(), secondaryColor: UIColor.cc_BackgroundLightBlack())
//    }
    override func loadNetRequestWithViewSkeleton(animate: Bool) {
        super.loadNetRequestWithViewSkeleton(animate: animate)
        mainTableView.showAnimatedGradientSkeleton()
        LennyNetworkRequest.obtainShanghaiStockList(page: 1) { (model) in
            self.hiddenSkeletonViewAnimation()
            if let model = model {
                
                if self.cells.count > 0 { self.cells.removeAll() }
                for item in (model.result?.data)! {
                    let cell = StockListTableViewCell.init(style: .default, reuseIdentifier: "cell")
                    cell.setValue(value: item)
                    self.cells.append(cell)
                }
                self.mainTableView.reloadData()
            }
        }
    }
    
    private var currentPage:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
        loadNetRequestWithViewSkeleton(animate: true)
    }

    private let mainTableView = UITableView.init()
    
    private func setViews() {
        
        
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
        mainTableView.register(StockListTableViewCell.self, forCellReuseIdentifier: "CellIdentitifier")
    }
    private var cells: [StockListTableViewCell] = []
}

extension StockListViewController: UITableViewDelegate {
    
    
}
extension StockListViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CellIdentitifier"
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

private class StockListTableViewCell: UITableViewCell {
    
    private let labal_Name = UILabel()
    private let label_Trade = UILabel()
    private let label_PriceChange = UILabel()
    private let label_ChangePercent = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(labal_Name)
        labal_Name.isSkeletonable = true
        labal_Name.whc_Top(10).whc_Left(20).whc_WidthAuto().whc_Height(30)
        labal_Name.font = UIFont.systemFont(ofSize: 30)
        labal_Name.textColor = UIColor.white
        labal_Name.textAlignment = .left
        contentView.addSubview(label_Trade)
        label_Trade.isSkeletonable = true
        label_Trade.whc_LeftEqual(labal_Name).whc_Top(10, toView: labal_Name).whc_WidthAuto().whc_Height(15).whc_Bottom(5)
        label_Trade.font = UIFont.systemFont(ofSize: 18)
        label_Trade.textAlignment = .left
        contentView.addSubview(label_PriceChange)
        label_PriceChange.isSkeletonable = true
        label_PriceChange.whc_CenterX(0).whc_CenterYEqual(label_Trade).whc_HeightEqual(label_Trade).whc_WidthAuto()
        label_PriceChange.font = UIFont.systemFont(ofSize: 18)
        label_PriceChange.textAlignment = .center
        contentView.addSubview(label_ChangePercent)
        label_ChangePercent.isSkeletonable = true
        label_ChangePercent.whc_CenterYEqual(label_Trade).whc_Right(20).whc_WidthAuto().whc_HeightEqual(label_Trade)
        label_ChangePercent.font = UIFont.systemFont(ofSize: 18)
        label_ChangePercent.textAlignment = .right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init() {
        self.init(style: .default, reuseIdentifier: "")
    }
    func setValue(value: StockData) {
        
        labal_Name.text = value.name
        label_Trade.text = value.trade
        var color = UIColor.init()
        if Double(value.pricechange!)! < 0.0 {
            color = UIColor.green
        }else { color = UIColor.red }
        label_Trade.textColor = color
        label_PriceChange.textColor = color
        label_ChangePercent.textColor = color
        label_PriceChange.text = value.pricechange
        label_ChangePercent.text = value.changepercent! + "%"
    }
}

