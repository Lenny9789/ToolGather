//
//  LennyModelSaving.swift
//  gameplay
//
//  Created by Lenny's Macbook Air on 2018/5/22.
//  Copyright © 2018年 yibo. All rights reserved.
//

import UIKit
import WHC_ModelSqliteKit


class LennyModel: NSObject { }

extension LennyModel {
    
    static var allLotteryQueryModel: AllLotteryQueryModel? {
        get {
            if let model = WHC_ModelSqlite.query(AllLotteryQueryModel.self).first {
                return model as? AllLotteryQueryModel
            }else {
                return nil
            }
        }
        set {
            if let _ = WHC_ModelSqlite.query(AllLotteryQueryModel.self).first {
                WHC_ModelSqlite.update(newValue, where: "")
            }else {
                WHC_ModelSqlite.insert(newValue)
            }
        }
    }
    
    static var normalExchangeModel: NormalExchangeModel? {
        get {
            if let model = WHC_ModelSqlite.query(NormalExchangeModel.self).first {
                return model as? NormalExchangeModel
            }else {
                return nil
            }
        }
        set {
            if let _ = WHC_ModelSqlite.query(NormalExchangeModel.self).first {
                WHC_ModelSqlite.update(newValue, where: "")
            }else {
                WHC_ModelSqlite.insert(newValue)
            }
        }
    }
    static var stockListModel: StockListModel? {
        get {
            if let model = WHC_ModelSqlite.query(StockListModel.self).first {
                return model as? StockListModel
            }else {
                return nil
            }
        }
        set {
            if let _ = WHC_ModelSqlite.query(StockListModel.self).first {
                WHC_ModelSqlite.update(newValue, where: "")
            }else {
                WHC_ModelSqlite.insert(newValue)
            }
        }
    }
}
