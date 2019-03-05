//
//  FeelingViewTests.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/14/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import XCTest

class MockDelegate: ButtonTap {
    var invokedButtonTapped = false
    var invokedButtonTappedCount: Int = 0
    var invokedButtonTappedParameter: Int = 0

    func buttonTapped(index: Int) {
        invokedButtonTapped = true
        invokedButtonTappedCount += 1
        invokedButtonTappedParameter = index
    }
}

class FeelingViewTests: XCTestCase {
    private var testObject: FeelingView!
    
    override func setUp() {
        testObject = FeelingView()
    }

    func testCallsDelegateCorrectly() {
        let mockDelegate = MockDelegate()
        testObject.delegate = mockDelegate
        
        let index = Int.random(in: 0...4)
        
        XCTAssertFalse(mockDelegate.invokedButtonTapped)
        let button = testObject.ratingButtons[index]
        
        button.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(mockDelegate.invokedButtonTapped)
        XCTAssertEqual(1, mockDelegate.invokedButtonTappedCount)
        XCTAssertEqual(index, mockDelegate.invokedButtonTappedParameter)
        
        button.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(2, mockDelegate.invokedButtonTappedCount)
    }

}
