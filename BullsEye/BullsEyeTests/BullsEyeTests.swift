//
//  BullsEyeTests.swift
//  BullsEyeTests
//
//  Created by Mauro Worobiej on 29/03/2019.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import BullsEye

class BullsEyeTests: XCTestCase {
    
    var gameUnderTest: BullsEyeGame!


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        gameUnderTest = BullsEyeGame()
        gameUnderTest.startNewGame()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        gameUnderTest = nil

    }

    // XCTAssert to test model
    func testScoreIsComputedWhenGuessLTTarget() {
        // 1. given
        let guess = gameUnderTest.targetValue - 5
        
        // 2. when
        _ = gameUnderTest.check(guess: guess)
        
        // 3. then
        XCTAssertEqual(gameUnderTest.scoreRound, 95, "Score computed from guess is wrong")
    }


    
}
