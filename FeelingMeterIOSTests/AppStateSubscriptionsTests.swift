//
//  AppStateSubscriptionsTests.swift
//  FeelingMeterIOSTests
//
//  Created by Andrew Bricker on 3/25/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import ReSwift
import XCTest
import RxSwift
import RxTest
import SocketIO

class MockSocketService: SocketService {
    var invokedStatusGetter = false
    var invokedStatusGetterCount = 0
    var stubbedStatus: Observable<SocketIOStatus>!
    override var status: Observable<SocketIOStatus> {
        invokedStatusGetter = true
        invokedStatusGetterCount += 1
        return stubbedStatus
    }
    var invokedConnect = false
    var invokedConnectCount = 0
    override func connect() {
        invokedConnect = true
        invokedConnectCount += 1
    }
    var invokedDisconnect = false
    var invokedDisconnectCount = 0
    override func disconnect() {
        invokedDisconnect = true
        invokedDisconnectCount += 1
    }
}

class AppStateSubscriptionsTests: XCTestCase {
    private var disposeBag: DisposeBag!
    private var testObject: AppStateSubscriptions!
    private var scheduler: TestScheduler!
    private var mockSocketService: MockSocketService!
    private var testStatusSubject = PublishSubject<SocketIOStatus>()
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        mockSocketService = MockSocketService()
        mockSocketService.stubbedStatus = testStatusSubject
        testObject = AppStateSubscriptions(socketService: mockSocketService, scheduler: scheduler)
    }

    override func tearDown() {
        disposeBag = nil
    }

    func testShouldSubscribeToSocketStatus() {
        scheduler.start()
        XCTAssertTrue(mockSocketService.invokedStatusGetter)
    }
}
