//
//  StockViewController.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/13.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import UIKit

class StockViewController: LennyTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
    }

    override var numberOfSection: Int {
        return 1
    }
    override var numberOfRowsInsection: [Int] {
        return [cells.count]
    }
    
    override var cells: [UITableViewCell] {
        var cells = [UITableViewCell]()
        let cell1 = StockTableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell1.textLabel?.text = "上海股市列表"
        cells.append(cell1)
        let cell2 = StockTableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell2.textLabel?.text = "深圳股市列表"
        cells.append(cell2)
        let cell3 = StockTableViewCell.init(style: .default, reuseIdentifier: "cell")
        cells.append(cell3)
        cell3.textLabel?.text = "香港股市列表"
        return cells
    }
    override func tableHeaderView() -> UIView {
        return UIView()
    }
    private func setViews() {
        
        self.tabBarController?.navigationItem.title = "股票"
        contentView.backgroundColor = UIColor.cc_BackgroundLightBlack()
        mainTableView.backgroundColor = UIColor.clear
        mainTableView.allowsSelection = true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(StockListViewController(), animated: true)
        }
    }
}

private class StockTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        textLabel?.textColor = UIColor.cc_Blue()
        textLabel?.font = UIFont.systemFont(ofSize: 20)
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
