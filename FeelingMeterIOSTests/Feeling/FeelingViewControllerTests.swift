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

class MockStore: Store<AppState> {
    var dispatchWasCalled = false
    var dispatchedActions: [Action] = []
    
    override func dispatch(_ action: Action) {
            print("TEST dispatchFunction called\(action)")
            dispatchWasCalled = true
            dispatchedActions.append(action)
    }
}

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
    
    func testVCShouldDispatchRatingToStoreWhenRatingControlIsTapped() {
        let mockstore = MockStore(reducer: reducer, state: state)
        testObject.appStore = mockstore
        let button: UIButton = testObject.profile.feelingRatingControlView.ratingButtons[1]
        button.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(mockstore.dispatchWasCalled)
        XCTAssertEqual(mockstore.dispatchedActions.count, 1)
        
        let action: ChangeFeelingAction = mockstore.dispatchedActions[0] as! ChangeFeelingAction
        XCTAssertEqual(action.feeling, .notSoGood)
    }
    
    func testVCShouldNotDspatchRatingToStoreWhenRatingControlIsTappedWithSameRatingAsCurrent() {
        
    }

}
