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

class MockFeelingRatingControlView: FeelingRatingControlView {
    var setButtonImagesCalled = false
    
    override func setButtonImages(rating: Int) {
        setButtonImagesCalled = true
    }
}
                             
class FeelingViewControllerTests: XCTestCase {
    private var testObject: FeelingViewController!
    private var state: AppState = AppState()
    
    override func setUp() {
        testObject = FeelingViewController()
        state.feeling = .meh
        testObject.newState(state: state)
    }

    func testVCShouldPopulateFeelingLabelWithFeelingFromTheStore() {
        XCTAssertEqual("I just want my rug, man", testObject.profile.feelingLabel.text)
    }
    
    func testVCShouldCallSetButtonImagesMethodInFeelingRatingControlBasedOnFeelingFromTheStore() {
        let mockFeelingRatingControlView = MockFeelingRatingControlView()
        testObject.feelingRatingControlerView = mockFeelingRatingControlView
        state.feeling = .meh
        testObject.newState(state: state)
        XCTAssertTrue(mockFeelingRatingControlView.setButtonImagesCalled)
    }
}
