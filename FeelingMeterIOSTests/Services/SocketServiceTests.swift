//
//  SocketServiceTests.swift
//  FeelingMeterIOSTests
//
//  Created by Andrew Bricker on 3/5/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import SocketIO

class MockSocketService: SocketIOProtocol {
    var invokedStatusGetter = false
    var invokedStatusGetterCount = 0
    var stubbedStatus: Observable<SocketIOStatus>!
    var status: Observable<SocketIOStatus> {
        invokedStatusGetter = true
        invokedStatusGetterCount += 1
        return stubbedStatus
    }
    var invokedConnect = false
    var invokedConnectCount = 0
    func connect() {
        invokedConnect = true
        invokedConnectCount += 1
    }
    var invokedDisconnect = false
    var invokedDisconnectCount = 0
    func disconnect() {
        invokedDisconnect = true
        invokedDisconnectCount += 1
    }
}

class SocketServiceTests: XCTestCase {
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var testObject: SocketService!
    private var mockSocket: MockSocketService!
    private var testableStatusObservable: TestableObservable<SocketIOStatus>!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        scheduler = nil
        mockSocket = nil
        testObject = nil
        testableStatusObservable = nil
        super.tearDown()
    }
    
    func testSocketStatus() {
        let statusObserver = scheduler.createObserver(SocketIOStatus.self)
        let status1: SocketIOStatus = SocketIOStatus.connecting
        let status2: SocketIOStatus = SocketIOStatus.connected
        let events = Recorded.events([Recorded.next(1, status1), Recorded.next(2, status2)])
        createTestObject(statusEvents: events)
        
        testObject
            .status
            .subscribe(statusObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(statusObserver.events, events)
    }

    func testConnectToSocket() {
        createTestObject()
        testObject.connect()
        XCTAssertEqual(mockSocket.invokedConnectCount, 1)
        XCTAssertEqual(mockSocket.invokedDisconnectCount, 0)
    }
    
    func testDisconnectFromSocket() {
        createTestObject()
        testObject.disconnect()
        XCTAssertEqual(mockSocket.invokedConnectCount, 0)
        XCTAssertEqual(mockSocket.invokedDisconnectCount, 1)
    }
    
    private func createTestObject(statusEvents: [Recorded<Event<SocketIOStatus>>] = []) {
        testableStatusObservable = scheduler.createColdObservable(statusEvents)
        mockSocket = MockSocketService()
        mockSocket.stubbedStatus = testableStatusObservable.asObservable()
        testObject = SocketService(socket: mockSocket,
                                   scheduler: scheduler)
    }
}
