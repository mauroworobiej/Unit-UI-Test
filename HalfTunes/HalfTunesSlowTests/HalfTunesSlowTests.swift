//
//  HalfTunesSlowTests.swift
//  HalfTunesSlowTests
//
//  Created by Mauro Worobiej on 29/03/2019.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import HalfTunes

class HalfTunesSlowTests: XCTestCase {

    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    // Asynchronous test: success fast, failure slow
    /*
     This test checks to see that sending a valid query to iTunes returns a 200 status code. Most of the code is the same as what you’d write in the app, with these additional lines:
     
     expectation(_:) returns an XCTestExpectation object, which you store in promise. Other commonly used names for this object are expectation and future. The description parameter describes what you expect to happen.
     To match the description, you call promise.fulfill() in the success condition closure of the asynchronous method’s completion handler.
     waitForExpectations(_:handler:) keeps the test running until all expectations are fulfilled, or the timeout interval ends, whichever happens first.
     Run the test. If you’re connected to the internet, the test should take about a second to succeed after the app starts to load in the simulator.
     */
    
    func testValidCallToiTunesGetsHTTPStatusCode200() {
        // given
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Asynchronous test: faster fail
    
    /*
     The key thing here is that simply entering the completion handler fulfills the expectation, and this takes about a second to happen. If the request fails, the then assertions fail.
     
     Run the test: it should now take about a second to fail, and it fails because the request failed, not because the test run exceeded timeout.
     
     Fix the url, then run the test again to confirm that it now succeeds.
     */
    
    func testCallToiTunesCompletes() {
        // given (At the begining in the url itune was without "s" and the test crash for that rason, but faster than the previous test)
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        // 1
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            // 2
            promise.fulfill()
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
