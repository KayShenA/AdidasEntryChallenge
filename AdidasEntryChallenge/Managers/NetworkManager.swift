//
//  NetworkManager.swift
//  WKCDA
//
//  Created by Kay Shen on 3/27/17.
//  Copyright © 2017 Salesforce. All rights reserved.
//

import Foundation
import Alamofire

typealias Succeed = (AnyObject?) -> Void
typealias Failure = (NSError?) -> Void

class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()
    
    func Get(url:String, parameter: [String: AnyObject]?, succeed:@escaping Succeed, failed: @escaping Failure){
        let getSuccess: Succeed = succeed
        let getFailed: Failure = failed

        Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                guard response.result.isSuccess else{
                    getFailed(response.result.error as NSError?)
                    return
                }
                getSuccess(response.result.value as AnyObject?)
                return
        }
    }
    
}
