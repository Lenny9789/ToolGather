//
//  BaseModel.swift
//  ToolGather
//
//  Created by Lenny's Macbook Pro on 2018/8/12.
//  Copyright © 2018年 Lenny. All rights reserved.
//

import Foundation
import SexyJson

@objc (Result)
class Result :NSObject, SexyJson, NSCoding, NSCopying {
    
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
    
    @objc var update: String?
    @objc var list: [[String]]?
    
    @objc public func sexyMap(_ map: [String : Any]) {
        
        update        <<<        map["update"]
        list          <<<        map["list"]
        
    }
    
}

@objc (NormalExchangeModel)
class NormalExchangeModel :NSObject, SexyJson, NSCoding, NSCopying {
    
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
    @objc var result: Result?
    @objc var reason: String?
    
    @objc public func sexyMap(_ map: [String : Any]) {
        
        error_code        <<<        map["error_code"]
        result            <<<        map["result"]
        reason            <<<        map["reason"]
        
    }
    
}
