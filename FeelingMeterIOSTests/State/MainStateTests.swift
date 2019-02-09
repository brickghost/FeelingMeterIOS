//
//  MainState.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/6/19.
//  Copyright © 2019 code FU Creative. All rights reserved.

import ReSwift
import XCTest

struct EmptyAction: Action { }

class MainStateTests: XCTestCase {

    var  state = MainState()
    override func setUp() {
        state = mainReducer(action: EmptyAction(), state: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReducerReturnsMainState() {
        XCTAssertEqual(state, MainState())
    }
    
    func testDefaultFeeling() {
        XCTAssertEqual(state.feeling, .terrible)
    }
    
    func testChangeFeeling() {
        state = mainReducer(action: changeFeeling(feeling: .great), state: nil)
        XCTAssertEqual(state.feeling, .great)
    }
}
