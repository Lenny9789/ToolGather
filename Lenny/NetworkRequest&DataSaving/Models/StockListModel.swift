//
//  ViewController.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/13.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import SexyJson
@objc (Data)
class StockData :NSObject, SexyJson, NSCoding, NSCopying {
    
    @objc required init(coder decoder: NSCoder) {
        super.init()
        self.sexy_decode(decoder)
    }
    
    @objc func encode(with aCoder: NSCoder) {
        self.sexy_encode(aCoder)
    }
    
    @objc func copy(with zone: NSZone? = nil) -> Any {
        return self.sexy_copy()
    }
    
    @objc required override init() {}
    
    @objc var trade: String?
    @objc var volume: String?
    @objc var high: String?
    @objc var amount: String?
    @objc var buy: String?
    @objc var symbol: String?
    @objc var code: String?
    @objc var open: String?
    @objc var low: String?
    @objc var pricechange: String?
    @objc var settlement: String?
    @objc var ticktime: String?
    @objc var changepercent: String?
    @objc var name: String?
    @objc var sell: String?
    
    @objc public func sexyMap(_ map: [String : Any]) {
        
        trade                <<<        map["trade"]
        volume               <<<        map["volume"]
        high                 <<<        map["high"]
        amount               <<<        map["amount"]
        buy                  <<<        map["buy"]
        symbol               <<<        map["symbol"]
        code                 <<<        map["code"]
        open                 <<<        map["open"]
        low                  <<<        map["low"]
        pricechange          <<<        map["pricechange"]
        settlement           <<<        map["settlement"]
        ticktime             <<<        map["ticktime"]
        changepercent        <<<        map["changepercent"]
        name                 <<<        map["name"]
        sell                 <<<        map["sell"]
    }
}

@objc (StockListResult)
class StockListResult :NSObject, SexyJson, NSCoding, NSCopying {
    
    @objc required init(coder decoder: NSCoder) {
        super.init()
        self.sexy_decode(decoder)
    }
    
    @objc func encode(with aCoder: NSCoder) {
        self.sexy_encode(aCoder)
    }
    
    @objc func copy(with zone: NSZone? = nil) -> Any {
        return self.sexy_copy()
    }
    
    @objc required override init() {}
    
    @objc var num: String?
    @objc var data: [StockData]?
    @objc var totalCount: String?
    @objc var page: String?
    
    @objc public func sexyMap(_ map: [String : Any]) {
        
        num               <<<        map["num"]
        data              <<<        map["data"]
        totalCount        <<<        map["totalCount"]
        page              <<<        map["page"]
    }
}

@objc (StockListModel)
class StockListModel :NSObject, SexyJson, NSCoding, NSCopying {
    
    @objc required init(coder decoder: NSCoder) {
        super.init()
        self.sexy_decode(decoder)
    }
    
    @objc func encode(with aCoder: NSCoder) {
        self.sexy_encode(aCoder)
    }
    
    @objc func copy(with zone: NSZone? = nil) -> Any {
        return self.sexy_copy()
    }
    
    @objc required override init() {}
    
    @objc var error_code: String?
    @objc var result: StockListResult?
    @objc var reason: String?
    
    @objc public func sexyMap(_ map: [String : Any]) {
        
        error_code        <<<        map["error_code"]
        result            <<<        map["result"]
        reason            <<<        map["reason"]
    }
}
