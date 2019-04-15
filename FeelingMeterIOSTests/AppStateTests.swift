//
//  MainState.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/6/19.
//  Copyright © 2019 code FU Creative. All rights reserved.

import ReSwift
import XCTest

struct EmptyAction: Action { }

class AppStateTests: XCTestCase {

    var  state = AppState()
    override func setUp() {
        state = reducer(action: EmptyAction(), state: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReducerReturnsMainState() {
        XCTAssertEqual(state, AppState())
    }
    
    func testDefaultFeeling() {
        XCTAssertEqual(state.feeling, .meh)
    }
    
    func testDefaultSocketStatus() {
        XCTAssertEqual(state.socketStatus, .notConnected)
    }
    
    func testChangeFeeling() {
        state = reducer(action: ChangeFeelingAction(feeling: .great), state: nil)
        XCTAssertEqual(state.feeling, .great)
    }
    
    func testChangeSocketStatus() {
        state = reducer(action: ChangeSocketStatusAction(socketStatus: .connecting), state: nil)
        XCTAssertEqual(state.socketStatus, .connecting)
    }
}
