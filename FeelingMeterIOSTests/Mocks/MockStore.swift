import ReSwift
import RxSwift

class MockStore: AnyStoreType<AppState> {
    var invokedSubscribe = false
    var invokedSubscribeCount = 0
    var invokedSubscribeParameters: (subscriber: Any, Void)?
    var invokedSubscribeParametersList = [(subscriber: Any, Void)]()
    
    override func subscribe<S: StoreSubscriber>(_ subscriber: S)
        where S.StoreSubscriberStateType == State {
            invokedSubscribe = true
            invokedSubscribeCount += 1
    }
    
    var invokedUnsubscribe = false
    var invokedUnsubscribeCount = 0
    var invokedUnsubscribeParameters: (subscriber: AnyStoreSubscriber, Void)?
    var invokedUnsubscribeParametersList = [(subscriber: AnyStoreSubscriber, Void)]()
    override func unsubscribe(_ subscriber: AnyStoreSubscriber) {
        invokedUnsubscribe = true
        invokedUnsubscribeCount += 1
    }
    
    var dispatchWasCalled = false
    var dispatchedActions: [Action] = []
    override func dispatch(_ action: Action) {
        print("TEST dispatchFunction called\(action)")
        dispatchWasCalled = true
        dispatchedActions.append(action)
    }
}
