//
//  HalfTunesFakeTests.swift
//  HalfTunesFakeTests
//
//  Created by Mauro Worobiej on 29/03/2019.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
// https://www.raywenderlich.com/709-ios-unit-testing-and-ui-testing-tutorial


import XCTest
@testable import HalfTunes

class HalfTunesFakeTests: XCTestCase {
    
    var controllerUnderTest: SearchViewController!
    
    override func setUp() {
        super.setUp()
        controllerUnderTest = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! SearchViewController!
        
        /*
         Set up the fake data and response, and create the fake session object, in setup() after the statement that creates the SUT:
         */
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "abbaData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba&limit=3")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        
        /*
         Inject the fake session into the app as a property of the SUT:
         */
        controllerUnderTest.defaultSession = sessionMock
        _ = controllerUnderTest.view 

    }
    
    override func tearDown() {
        controllerUnderTest = nil
        super.tearDown()
    }
    
    /*
     In this test, you’ll check that the app’s updateSearchResults(_:) method correctly parses data downloaded by the session by checking that searchResults.count is correct. The SUT is the view controller, and you’ll fake the session with stubs and some pre-downloaded data.
     */
    
    
    /*
     You still have to write this as an asynchronous test because the stub is pretending to be an asynchronous method.
     
     The when assertion is that searchResults is empty before the data task runs — this should be true, because you created a completely new SUT in setup().
     
     The fake data contains the JSON for three Track objects, so the then assertion is that the view controller’s searchResults array contains three items.
     
     Run the test. It should succeed pretty quickly, because there isn’t any real network connection!
     

     */
    // Fake URLSession with DHURLSession protocol and stubs (method or function)
    func test_UpdateSearchResults_ParsesData() {
        // given
        let promise = expectation(description: "Status code: 200")
        
        // when (element to test, expected result, error msj)
        XCTAssertEqual(controllerUnderTest?.searchResults.count, 0, "searchResults should be empty before the data task runs")
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let dataTask = controllerUnderTest?.defaultSession.dataTask(with: url!) {
            data, response, error in
            // if HTTP request is successful, call updateSearchResults(_:) which parses the response data into Tracks
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    promise.fulfill()
                    self.controllerUnderTest?.updateSearchResults(data)
                }
            }
        }
        dataTask?.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertEqual(controllerUnderTest?.searchResults.count, 3, "Didn't parse 3 items from fake response")
    }

    // Performance
    /*
     performance test takes a block of code that you want to evaluate and runs it ten times, collecting the average execution time and the standard deviation for the runs. The averaging of these individual measurements form a value for the test run that can then be compared against a baseline to evaluate success or failure.
     
     It’s very simple to write a performance test: you just put the code you want to measure into the closure of the measure() method.
     */
    func test_StartDownload_Performance() {
        let track = Track(name: "Waterloo", artist: "ABBA",
                          previewUrl: "http://a821.phobos.apple.com/us/r30/Music/d7/ba/ce/mzm.vsyjlsff.aac.p.m4a")
        
        measure {
            self.controllerUnderTest?.startDownload(track)
        }
    }


}
