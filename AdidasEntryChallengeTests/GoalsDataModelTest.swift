//
//  GoalsDataModelTest.swift
//  AdidasEntryChallengeTests
//
//  Created by Keyan  on 2019/3/11.
//  Copyright © 2019 Keyan . All rights reserved.
//

import XCTest

@testable import AdidasEntryChallenge
import Alamofire

class GoalsDataModelTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCheckThatTheNetworkResponseIsEqualToTheExpectedResult() {
        //out of time to do this..
        //expected result
        
        let expectations = expectation(description: "The Response result match the expected results")
        
        if let requestUrl = URL(string: "some url to fetch data from") {
            
            let request = Alamofire.request(requestUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            request.responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let result):
                    //out of time 8:30am Mar11th
                    //let expectedResult: [String:Any]

                    expectations.fulfill()
                case .failure(let error):
                    //this is failed case
                    XCTFail("Server response failed : \(error.localizedDescription)")
                    expectations.fulfill()
                }
            })
            
            //wait for some time for the expectation (you can wait here more than 30 sec, depending on the time for the response)
            waitForExpectations(timeout: 30, handler: { (error) in
                if let error = error {
                    print("Failed : \(error.localizedDescription)")
                }
                
            })
        }
        
    }
    func testGoalsDataModel() {

    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
