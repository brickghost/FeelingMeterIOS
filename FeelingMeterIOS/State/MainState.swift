//
//  MainState.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/6/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import Foundation
import ReSwift

// MARK:- STATE
struct MainState: StateType, Equatable {
    var feeling: Feeling
    
    init() {
        self.feeling = .terrible
    }
}

func mainReducer(action: Action, state: MainState?) -> MainState {
    var state = state ?? MainState()
    
    return state
}

// MARK: MODEL/OPTIONS
enum Feeling: String {
    case terrible = "Existence is pain"
    case notSoGood = "I can't adult today"
    case meh = "Whatever man"
    case ok = "Could be worse"
    case great = "I can't feel my face"
}
