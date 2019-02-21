//
//  FeelingViewControllerTests.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/14/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import ReSwift
import XCTest
@testable import FeelingMeterIOS
                             
class FeelingViewControllerTests: XCTestCase {
    private var testObject: FeelingViewController!
    private var state: AppState = AppState()
    
    override func setUp() {
        testObject = FeelingViewController()
    }

    func testShouldDisplayFeelingFromTheStore() {
        state.feeling = .great
        testObject.newState(state: state)
        
        XCTAssertEqual("I can't feel my face", testObject.profile.feelingLabel.text)
    }
}
