//
//  LennyNetworkRequest.swift
//  gameplay
//
//  Created by Lenny's Macbook Air on 2018/5/22.
//  Copyright © 2018年 yibo. All rights reserved.
//

import UIKit
import Alamofire

private let basic_Url = ""



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
    
}
