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
    
}

func mainReducer(action: Action, state: MainState?) -> MainState {
    var state = state ?? MainState()
    
    return state
}

