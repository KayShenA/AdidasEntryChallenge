//
//  NetworkClient.swift
//  WKCDA
//
//  Created by Kay Shen on 3/27/17.
//  Copyright © 2017 Salesforce. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class NetworkClient: NSObject{
    
    static let endpoint = "https://thebigachallenge.appspot.com/_ah/api/myApi/v1/goals"
    

    class func fetchGoals(succeed:@escaping Succeed, failed: @escaping Failure){
        NetworkManager.sharedInstance.Get(url: endpoint, parameter: nil, succeed: succeed, failed: failed)
    }
    
    
}



