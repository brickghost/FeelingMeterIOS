//
//  AppState.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/6/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import Foundation
import ReSwift

// MARK:- STATE
struct AppState: StateType, Equatable {
    var feeling: Feeling
    
    init() {
        self.feeling = .terrible
    }
}

// MARK:- REDUCERS
func reducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    case let feeling as ChangeFeelingAction:
        state.feeling = feeling.feeling
    default:
        return state
    }
    
    return state
}

// MARK:- ACTIONS
struct ChangeFeelingAction: Action {
    var feeling: Feeling
}

let store = Store(
    reducer: reducer,
    state: AppState())


// MARK: MODEL/OPTIONS
enum Feeling: String, CaseIterable {
    case terrible = "Existence is pain"
    case notSoGood = "I can't adult today"
    case meh = "I just want my rug, man"
    case ok = "Living the Dream"
    case great = "I can't feel my face"
}
