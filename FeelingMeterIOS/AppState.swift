//
//  AppState.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/6/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import Foundation
import ReSwift
import SocketIO

// MARK:- STATE
struct AppState: StateType, Equatable {
    var feeling: Feeling!
    var socketStatus: SocketIOStatus!
    
    init() {
        self.feeling = .meh
        self.socketStatus = .notConnected
    }
}

// MARK:- REDUCERS
func reducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    case let socketStatus as ChangeSocketStatusAction:
        state.socketStatus = socketStatus.socketStatus
    case let feeling as ChangeFeelingAction:
        state.feeling = feeling.feeling
    default:
        return state
    }
    
    return state
}

// MARK:- ACTIONS
struct ChangeSocketStatusAction: Action {
    var socketStatus: SocketIOStatus
}

struct ChangeFeelingAction: Action {
    var feeling: Feeling
}

let store = AnyStoreType(
    reducer: reducer,
    state: AppState())

private let socketService = SocketService()
let subscriptions = AppStateSubscriptions(socketService: socketService)

// MARK: MODEL/OPTIONS
enum Feeling: String, CaseIterable {
    case terrible = "Existence is pain"
    case notSoGood = "I can't adult today"
    case meh = "I just want my rug, man"
    case ok = "Living the Dream"
    case great = "I can't feel my face"
}
