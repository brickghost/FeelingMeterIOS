import ReSwift
import XCTest
import RxSwift
import RxTest
import SocketIO

class AppStateSubscriptionsTests: XCTestCase {
    private var disposeBag: DisposeBag!
    private var testObject: AppStateSubscriptions!
    private var scheduler: TestScheduler!
    private var mockSocketService: MockSocketService!
    private var testStatusSubject: PublishSubject<SocketIOStatus>!
    private var testFeelingSubject: PublishSubject<Feeling>!
    private var state: AppState = AppState()
    private var mockStore: MockStore!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        testStatusSubject = PublishSubject<SocketIOStatus>()
        testFeelingSubject = PublishSubject<Feeling>()
        mockSocketService = MockSocketService()
        mockSocketService.stubbedStatus = testStatusSubject
        mockSocketService.stubbedFeeling = testFeelingSubject
        state.socketStatus = .notConnected
        state.feeling = .meh
        mockStore = MockStore(reducer: reducer, state: state)
    }

    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        testObject = nil
    }

    func testShouldSubscribeToSocketStatus() {
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        XCTAssertTrue(mockSocketService.invokedStatusGetter)
    }
    
    func testDisposeOfStatusSubscription() {
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        
        XCTAssertTrue(testStatusSubject.hasObservers)
        
        testObject = nil
        
        XCTAssertFalse(testStatusSubject.hasObservers)
    }
    
    func testShouldSubscribeToSocketFeeling() {
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        scheduler.start()
        XCTAssertTrue(mockSocketService.invokedFeelingGetter)
    }
    
    func testDisposeOfFeelingSubscription() {
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        
        XCTAssertTrue(testFeelingSubject.hasObservers)
        
        testObject = nil
        
        XCTAssertFalse(testFeelingSubject.hasObservers)
    }
    
    func testShouldSubscribeToStore() {
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        scheduler.start()
        XCTAssertTrue(mockStore.invokedSubscribe)
    }
    
    func testShouldUnsubscribeFromStore() {
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        
        XCTAssertFalse(mockStore.invokedUnsubscribe)
        
        testObject = nil
        
        XCTAssertTrue(mockStore.invokedUnsubscribe)
    }
    
    func testFeelingSubscription() {
        let testObserver = scheduler.createObserver(Feeling.self)
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        testObject
            .feelingObservable
            .subscribe(testObserver)
            .disposed(by: disposeBag)
        XCTAssertEqual(testObserver.events.count, 0)
        testObject.newState(state: state)
        XCTAssertEqual(testObserver.events.count, 1)
    }
    
    func testFeelingSubscriptionDistinctUntilChanged() {
        let testObserver = scheduler.createObserver(Feeling.self)
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        testObject
            .feelingObservable
            .subscribe(testObserver)
            .disposed(by: disposeBag)
        
        testObject.newState(state: state)
        testObject.newState(state: state)
        XCTAssertEqual(testObserver.events.count, 1)
        state.feeling = .great
        testObject.newState(state: state)
        XCTAssertEqual(testObserver.events.count, 2)
    }
    
    func testSocketStatusEventDispatchesToStore() {
        let statusObserver = scheduler.createObserver(SocketIOStatus.self)
        let status1 = SocketIOStatus.connecting
        let status2 = SocketIOStatus.connected
        let events = Recorded.events([Recorded.next(1, status1), Recorded.next(2, status2)])
        let testableStatusObservable = scheduler.createColdObservable(events)
        mockSocketService.stubbedStatus = testableStatusObservable.asObservable()
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        testObject
            .socketService
            .status
            .subscribe(statusObserver)
            .disposed(by: disposeBag)
        
        scheduler.advanceTo(1)
        var action: ChangeSocketStatusAction = mockStore.dispatchedActions[0] as! ChangeSocketStatusAction
        
        XCTAssertEqual(statusObserver.events[0], events[0])
        XCTAssertTrue(mockStore.dispatchWasCalled)
        XCTAssertEqual(mockStore.dispatchedActions.count, 1)
        XCTAssertEqual(action.socketStatus, .connecting)
        
        scheduler.advanceTo(2)
        action = mockStore.dispatchedActions[1] as! ChangeSocketStatusAction
        XCTAssertEqual(statusObserver.events[1], events[1])
        XCTAssertTrue(mockStore.dispatchWasCalled)
        XCTAssertEqual(mockStore.dispatchedActions.count, 2)
        XCTAssertEqual(action.socketStatus, .connected)
    }
    
    func testSocketFeelingEventDispatchesToStore() {
        let statusObserver = scheduler.createObserver(Feeling.self)
        let feeling1 = Feeling.notSoGood
        let feeling2 = Feeling.ok
        let events = Recorded.events([Recorded.next(1, feeling1), Recorded.next(2, feeling2)])
        let testableStatusObservable = scheduler.createColdObservable(events)
        mockSocketService.stubbedFeeling = testableStatusObservable.asObservable()
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        testObject
            .socketService
            .feeling
            .subscribe(statusObserver)
            .disposed(by: disposeBag)
        
        scheduler.advanceTo(1)
        var action: ChangeFeelingAction = mockStore.dispatchedActions[0] as! ChangeFeelingAction
        
        XCTAssertEqual(statusObserver.events[0], events[0])
        XCTAssertTrue(mockStore.dispatchWasCalled)
        XCTAssertEqual(mockStore.dispatchedActions.count, 1)
        XCTAssertEqual(action.feeling, feeling1)
        
        scheduler.advanceTo(2)
        action = mockStore.dispatchedActions[1] as! ChangeFeelingAction
        XCTAssertEqual(statusObserver.events[1], events[1])
        XCTAssertTrue(mockStore.dispatchWasCalled)
        XCTAssertEqual(mockStore.dispatchedActions.count, 2)
        XCTAssertEqual(action.feeling, feeling2)
    }
    
    func testUpdateFeeling() {
        let feeling: Feeling = .great
        testObject = AppStateSubscriptions(store: mockStore, socketService: mockSocketService)
        testObject.updateFeeling(feeling: feeling)
       
        XCTAssertTrue(mockStore.dispatchWasCalled)
        XCTAssertEqual(mockStore.dispatchedActions.count, 1)
        XCTAssertEqual((mockStore.dispatchedActions.first as? ChangeFeelingAction)?.feeling, feeling)
        
        XCTAssertTrue(mockSocketService.invokedEmitFeeling)
        XCTAssertEqual(mockSocketService.invokedEmitFeelingCount, 1)
        XCTAssertEqual((mockSocketService.invokedEmitFeelingParameters)?.feeling, feeling)
    }
}
