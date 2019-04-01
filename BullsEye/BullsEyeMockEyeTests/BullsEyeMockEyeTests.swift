//
//  BullsEyeMockEyeTests.swift
//  BullsEyeMockEyeTests
//
//  Created by Mauro Worobiej on 29/03/2019.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import BullsEye

/*
 MockUserDefaults overrides the set(_:forKey:) method to increment the gameStyleChanged flag. Often you’ll see similar tests that set a Bool variable, but incrementing an Int gives you more flexibility — for example, your test could check that the method is called exactly once.
 */
class MockUserDefaults: UserDefaults {
    var gameStyleChanged = 0
    override func set(_ value: Int, forKey defaultName: String) {
        if defaultName == "gameStyle" {
            gameStyleChanged += 1
        }
    }
}


class BullsEyeMockEyeTests: XCTestCase {
    
    var controllerUnderTest: ViewController!
    var mockUserDefaults: MockUserDefaults!


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        controllerUnderTest = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController!
        mockUserDefaults = MockUserDefaults(suiteName: "testing")!
        // inject the mock object as a property of the SUT:
        controllerUnderTest.defaults = mockUserDefaults

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        controllerUnderTest = nil
        mockUserDefaults = nil

    }

    // Mock to test interaction with UserDefaults
    /*
     The when assertion is that the gameStyleChanged flag is 0 before the test method “taps” the segmented control. So if the then assertion is also true, it means set(_:forKey:) was called exactly once.
     */
    func testGameStyleCanBeChanged() {
        // given
        let segmentedControl = UISegmentedControl()
        
        // when
        XCTAssertEqual(mockUserDefaults.gameStyleChanged, 0, "gameStyleChanged should be 0 before sendActions")
        segmentedControl.addTarget(controllerUnderTest,
                                   action: #selector(ViewController.chooseGameStyle(_:)), for: .valueChanged)
        segmentedControl.sendActions(for: .valueChanged)
        
        // then
        XCTAssertEqual(mockUserDefaults.gameStyleChanged, 1, "gameStyle user default wasn't changed")
    }


}
