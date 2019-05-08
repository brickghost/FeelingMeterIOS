import XCTest
import RxSwift
import RxTest
import SocketIO
import RxCocoa

class SocketServiceTests: XCTestCase {
    private var testObject: SocketService!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var testableStatusObservable: TestableObservable<SocketIOStatus>!
    private var mockSocketIOClient: MockSocketClient!
    
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        scheduler = nil
        testObject = nil
        testableStatusObservable = nil
        super.tearDown()
    }
    
    func testConnectToSocket() {
        createTestObject()
        testObject.connect()
        XCTAssertEqual(mockSocketIOClient.invokedConnectCount, 1)
        XCTAssertEqual(mockSocketIOClient.invokedDisconnectCount, 0)
    }
    
    func testDisconnectFromSocket() {
        createTestObject()
        testObject.disconnect()
        XCTAssertEqual(mockSocketIOClient.invokedConnectCount, 0)
        XCTAssertEqual(mockSocketIOClient.invokedDisconnectCount, 1)
    }
    
    func testClientStatusUpdatesAreObserved() {
        let status = SocketIOStatus.connecting
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testObserver = scheduler.createObserver(SocketIOStatus.self)
        let expectation = self.expectation(description: "statusChange")
        let url = URL(string: "http://localhost")!
        let manager = SocketManager(socketURL: url)
        let testObject = manager.defaultSocket
        
        testObject
            .rx
            .status
            .subscribe {event in
                testObserver.on(event)
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        
        testObject.handleClientEvent(.statusChange, data: [status])
        
        self.waitForExpectations(timeout: 1.0) { _ in
            let events = [next(0, status)]
            XCTAssertEqual(testObserver.events, events)
        }
    }
    
//    func testClientFeelingUpdatesAreObserved() {
//        let feeling = Feeling.ok
//        let disposeBag = DisposeBag()
//        let scheduler = TestScheduler(initialClock: 0)
//        let testObserver = scheduler.createObserver(Feeling.self)
//        let expectation = self.expectation(description: "feelingChange")
//        let url = URL(string: "http://localhost")!
//        let manager = SocketManager(socketURL: url)
//        let testObject = manager.defaultSocket
//
//        testObject
//            .rx
//            .feeling
//            .subscribe {event in
//                testObserver.on(event)
//                expectation.fulfill()
//            }
//            .disposed(by: disposeBag)
//
//        testObject.handleEvent("feeling", data: [feeling], isInternalMessage: true)
//
//        self.waitForExpectations(timeout: 1.0) { _ in
//            let events = [next(0, feeling)]
//            XCTAssertEqual(testObserver.events, events)
//        }
//    }
    
    private func createTestObject(statusEvents: [Recorded<Event<SocketIOStatus>>] = []) {
        let mockSocketManager = MockSocketManager()
        mockSocketIOClient = MockSocketClient(manager: mockSocketManager, nsp:"")
        mockSocketManager.stubbedDefaultSocket = mockSocketIOClient
        
        testObject = SocketService(manager: mockSocketManager)
    }
}
