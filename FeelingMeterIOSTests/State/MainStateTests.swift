//
//  MainState.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/6/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import ReSwift
import XCTest

struct EmptyAction: Action { }

class MainStateTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReducerReturnsMainState() {
        let state = mainReducer(action: EmptyAction(), state: nil)
        XCTAssertEqual(state, MainState())
    }
    
    func testDefaultFeeling() {
        let state = mainReducer(action: EmptyAction(), state: nil)
        XCTAssertEqual(state.feeling, .terrible)
    }
}
