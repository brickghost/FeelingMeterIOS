//
//  AppStateSubscriptions.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 3/25/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import Foundation
import ReSwift
import SocketIO
import RxSwift

class AppStateSubscriptions: StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    //MARK: Properties
    private var disposeBag: DisposeBag!
    weak var socketService: SocketService!
    var socketStatus: SocketIOStatus! = .notConnected
    var appStore: AnyStoreType<AppState>
    
    private var stateObservable = PublishSubject<AppState>()
    
    //MARK: Initialization
    init(store: AnyStoreType<AppState> = store,
         socketService: SocketService) {
        self.disposeBag = DisposeBag()
        self.socketService = socketService
        self.socketService.connect()
        self.appStore = store
        self.appStore.subscribe(self)
        self.socketService.status.subscribe { [weak self] event in
            if let status = event.element {
                self?.dispatchStatusToStore(socketStatus: status)
            }
            }.disposed(by: self.disposeBag)
        self.socketService.feeling.subscribe { [weak self] event in
            if let feeling = event.element {
                self?.dispatchFeelingToStore(feeling: feeling)
            }
            }.disposed(by: self.disposeBag)
    }
    
    deinit {
        self.disposeBag = nil
        appStore.unsubscribe(self)
    }
    
    //MARK: Public Methods
    func newState(state: AppStateSubscriptions.StoreSubscriberStateType) {
        stateObservable.onNext(state)
    }
    
    //MARK: Store Subscriptions
    var feelingObservable: Observable<Feeling> {
        return stateObservable.map { $0.feeling }.distinctUntilChanged()
    }
    
    //MARK: Store Dispatches
    func dispatchStatusToStore(socketStatus: SocketIOStatus) {
        self.appStore.dispatch(ChangeSocketStatusAction(socketStatus: socketStatus))
    }
    
    func dispatchFeelingToStore(feeling: Feeling) {
        self.appStore.dispatch(ChangeFeelingAction(feeling: feeling))
    }
}

//MARK: Because Fu**ing Type Erasure
class AnyStoreType<AppState: StateType>: MyStoreType {
    typealias State = AppState
    
    private var origin: Store<State>
    
    init(origin: Store<State>) {
        self.origin = origin
    }
    
    required init(reducer: @escaping (Action, AppState?) -> AppState, state: AppState?, middleware: [(@escaping DispatchFunction, @escaping () -> AppState?) -> (@escaping DispatchFunction) -> DispatchFunction] = []) {
        origin = Store<AppState>(reducer: reducer, state: state, middleware: middleware)
    }
    
    func toAnyStore() -> AnyStoreType<AppState> {
        return AnyStoreType(origin: origin)
    }
    
    var state: AppState!
    
    var dispatchFunction: DispatchFunction!
    
    func subscribe<S>(_ subscriber: S) where S : StoreSubscriber, AnyStoreType.State == S.StoreSubscriberStateType {
        origin.subscribe(subscriber)
    }
    
    func subscribe<SelectedState, S>(_ subscriber: S, transform: ((Subscription<AppState>) -> Subscription<SelectedState>)?) where SelectedState == S.StoreSubscriberStateType, S : StoreSubscriber {
        origin.subscribe(subscriber, transform: transform)
    }
    
    func unsubscribe(_ subscriber: AnyStoreSubscriber) {
        origin.unsubscribe(subscriber)
    }
    
    func dispatch(_ action: Action) {
        origin.dispatch(action)
    }
    
    func dispatch(_ asyncActionCreator: Action, callback: ((AppState) -> Void)?) {
    }
}

protocol MyStoreType: StoreType {
    associatedtype State
    func toAnyStore() -> AnyStoreType<State>
}
