//
//  LennyNetworkRequest.swift
//  gameplay
//
//  Created by Lenny's Macbook Air on 2018/5/22.
//  Copyright © 2018年 yibo. All rights reserved.
//

import UIKit
import Alamofire
import SexyJson

private let basic_Url = ""

/******
    汇率接口
 ********/
private let exchange_Key = "1ff63263f09ef8b5330d48d96e160198"
private let exchange_rate = "http://op.juhe.cn/onebox/exchange/query"
///股票数据
/*
 
 */
private let stock_AppKey = "42cb1979a2436b681d6eb7b25b64dea1"
private let path_Stock = "http://web.juhe.cn:8080/finance/stock/hs"
private let path_StockList = "http://web.juhe.cn:8080/finance/stock/shall"
typealias completionHandler = ((DataResponse<Any>)) -> Void
class LennyNetworkRequest: NSObject {

    static var requestManager: SessionManager = SessionManager.default
    static var currentDataRequest: DataRequest?
    private static func basic_Request(url: URL, method: HTTPMethod, parameter: Parameters?, encoding: URLEncoding, header: HTTPHeaders?, completionHandle: @escaping completionHandler) {
        
        currentDataRequest = request(url, method: method, parameters: parameter, encoding: encoding, headers: header).responseJSON { (dataResponse) in
            dataResponse.result.ifFailure {
                // 统一的 错误处理
            }
            dataResponse.result.ifSuccess {
                
            }
            completionHandle(dataResponse)
        }
    }
    
    ////常用汇率接口
    static func obtainNormallyExchangeRate(response: @escaping (_ model: NormalExchangeModel?) -> Void) {
        DispatchQueue.main.async {
            if let model = LennyModel.normalExchangeModel {
                response(model)
            }
        }
        
        let url = URL.init(string: exchange_rate)
        let parameter = ["key": exchange_Key]
        basic_Request(url: url!, method: .get, parameter: parameter, encoding: .default, header: nil) { (dataResponse) in
            dataResponse.result.ifSuccess {
                
                if let data = dataResponse.data {
                    print(dataResponse)
                    let model = NormalExchangeModel.sexy_json(data)
                    LennyModel.normalExchangeModel = model
                    response(model)
                }
            }
            dataResponse.result.ifFailure {
                response(nil)
            }
        }
    }
    ///上海股市列表
    static func obtainShanghaiStockList(page: Int, response: @escaping (_ model: StockListModel?) -> Void) {
        DispatchQueue.main.async {
            if let model = LennyModel.stockListModel {
                response(model)
            }
        }
        let url = URL.init(string: path_StockList)
        let parameter: Parameters = ["key": stock_AppKey, "page": page]
        basic_Request(url: url!, method: .get, parameter: parameter, encoding: .default, header: nil) { (dataResponse) in
            dataResponse.result.ifSuccess {
                
                if let data = dataResponse.data {
                    let model = StockListModel.sexy_json(data)
                    LennyModel.stockListModel = model
                    response(model)
                }
            }
            dataResponse.result.ifFailure {
                response(nil)
            }
        }
    }
}
