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
import RxCocoa

class MockSocketClient: SocketIOClient {
    private let emitRelay = PublishRelay<(event: String, items: SocketData)>()
    let emitObservable: Observable<(event: String, items: SocketData)>
    override init(manager: SocketManagerSpec, nsp: String) {
        emitObservable = emitRelay.asObservable()
        super.init(manager: manager, nsp: nsp)
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
    var invokedEmitWithAck = false
    var invokedEmitWithAckCount = 0
    var stubbedEmitWithAckResult: OnAckCallback!
    override func emitWithAck(_ event: String, _ items: SocketData...) -> OnAckCallback {
        invokedEmitWithAck = true
        invokedEmitWithAckCount += 1
        emitRelay.accept((event, items))
        return stubbedEmitWithAckResult
    }
}

class MockSocketManager: SocketManagerSpec {
    var invokedDefaultSocketGetter = false
    var invokedDefaultSocketGetterCount = 0
    var stubbedDefaultSocket: SocketIOClient!
    var defaultSocket: SocketIOClient {
        invokedDefaultSocketGetter = true
        invokedDefaultSocketGetterCount += 1
        return stubbedDefaultSocket
    }
    var invokedEngineSetter = false
    var invokedEngineSetterCount = 0
    var invokedEngine: SocketEngineSpec?
    var invokedEngineList = [SocketEngineSpec?]()
    var invokedEngineGetter = false
    var invokedEngineGetterCount = 0
    var stubbedEngine: SocketEngineSpec!
    var engine: SocketEngineSpec? {
        set {
            invokedEngineSetter = true
            invokedEngineSetterCount += 1
            invokedEngine = newValue
            invokedEngineList.append(newValue)
        }
        get {
            invokedEngineGetter = true
            invokedEngineGetterCount += 1
            return stubbedEngine
        }
    }
    var invokedForceNewSetter = false
    var invokedForceNewSetterCount = 0
    var invokedForceNew: Bool?
    var invokedForceNewList = [Bool]()
    var invokedForceNewGetter = false
    var invokedForceNewGetterCount = 0
    var stubbedForceNew: Bool! = false
    var forceNew: Bool {
        set {
            invokedForceNewSetter = true
            invokedForceNewSetterCount += 1
            invokedForceNew = newValue
            invokedForceNewList.append(newValue)
        }
        get {
            invokedForceNewGetter = true
            invokedForceNewGetterCount += 1
            return stubbedForceNew
        }
    }
    var invokedHandleQueueSetter = false
    var invokedHandleQueueSetterCount = 0
    var invokedHandleQueue: DispatchQueue?
    var invokedHandleQueueList = [DispatchQueue]()
    var invokedHandleQueueGetter = false
    var invokedHandleQueueGetterCount = 0
    var stubbedHandleQueue: DispatchQueue!
    var handleQueue: DispatchQueue {
        set {
            invokedHandleQueueSetter = true
            invokedHandleQueueSetterCount += 1
            invokedHandleQueue = newValue
            invokedHandleQueueList.append(newValue)
        }
        get {
            invokedHandleQueueGetter = true
            invokedHandleQueueGetterCount += 1
            return stubbedHandleQueue
        }
    }
    var invokedNspsSetter = false
    var invokedNspsSetterCount = 0
    var invokedNsps: [String: SocketIOClient]?
    var invokedNspsList = [[String: SocketIOClient]]()
    var invokedNspsGetter = false
    var invokedNspsGetterCount = 0
    var stubbedNsps: [String: SocketIOClient]! = [:]
    var nsps: [String: SocketIOClient] {
        set {
            invokedNspsSetter = true
            invokedNspsSetterCount += 1
            invokedNsps = newValue
            invokedNspsList.append(newValue)
        }
        get {
            invokedNspsGetter = true
            invokedNspsGetterCount += 1
            return stubbedNsps
        }
    }
    var invokedReconnectsSetter = false
    var invokedReconnectsSetterCount = 0
    var invokedReconnects: Bool?
    var invokedReconnectsList = [Bool]()
    var invokedReconnectsGetter = false
    var invokedReconnectsGetterCount = 0
    var stubbedReconnects: Bool! = false
    var reconnects: Bool {
        set {
            invokedReconnectsSetter = true
            invokedReconnectsSetterCount += 1
            invokedReconnects = newValue
            invokedReconnectsList.append(newValue)
        }
        get {
            invokedReconnectsGetter = true
            invokedReconnectsGetterCount += 1
            return stubbedReconnects
        }
    }
    var invokedReconnectWaitSetter = false
    var invokedReconnectWaitSetterCount = 0
    var invokedReconnectWait: Int?
    var invokedReconnectWaitList = [Int]()
    var invokedReconnectWaitGetter = false
    var invokedReconnectWaitGetterCount = 0
    var stubbedReconnectWait: Int! = 0
    var reconnectWait: Int {
        set {
            invokedReconnectWaitSetter = true
            invokedReconnectWaitSetterCount += 1
            invokedReconnectWait = newValue
            invokedReconnectWaitList.append(newValue)
        }
        get {
            invokedReconnectWaitGetter = true
            invokedReconnectWaitGetterCount += 1
            return stubbedReconnectWait
        }
    }
    var invokedReconnectWaitMaxSetter = false
    var invokedReconnectWaitMaxSetterCount = 0
    var invokedReconnectWaitMax: Int?
    var invokedReconnectWaitMaxList = [Int]()
    var invokedReconnectWaitMaxGetter = false
    var invokedReconnectWaitMaxGetterCount = 0
    var stubbedReconnectWaitMax: Int! = 0
    var reconnectWaitMax: Int {
        set {
            invokedReconnectWaitMaxSetter = true
            invokedReconnectWaitMaxSetterCount += 1
            invokedReconnectWaitMax = newValue
            invokedReconnectWaitMaxList.append(newValue)
        }
        get {
            invokedReconnectWaitMaxGetter = true
            invokedReconnectWaitMaxGetterCount += 1
            return stubbedReconnectWaitMax
        }
    }
    var invokedRandomizationFactorSetter = false
    var invokedRandomizationFactorSetterCount = 0
    var invokedRandomizationFactor: Double?
    var invokedRandomizationFactorList = [Double]()
    var invokedRandomizationFactorGetter = false
    var invokedRandomizationFactorGetterCount = 0
    var stubbedRandomizationFactor: Double! = 0
    var randomizationFactor: Double {
        set {
            invokedRandomizationFactorSetter = true
            invokedRandomizationFactorSetterCount += 1
            invokedRandomizationFactor = newValue
            invokedRandomizationFactorList.append(newValue)
        }
        get {
            invokedRandomizationFactorGetter = true
            invokedRandomizationFactorGetterCount += 1
            return stubbedRandomizationFactor
        }
    }
    var invokedSocketURLGetter = false
    var invokedSocketURLGetterCount = 0
    var stubbedSocketURL: URL!
    var socketURL: URL {
        invokedSocketURLGetter = true
        invokedSocketURLGetterCount += 1
        return stubbedSocketURL
    }
    var invokedStatusGetter = false
    var invokedStatusGetterCount = 0
    var stubbedStatus: SocketIOStatus!
    var status: SocketIOStatus {
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
    var invokedConnectSocket = false
    var invokedConnectSocketCount = 0
    var invokedConnectSocketParameters: (socket: SocketIOClient, Void)?
    var invokedConnectSocketParametersList = [(socket: SocketIOClient, Void)]()
    func connectSocket(_ socket: SocketIOClient) {
        invokedConnectSocket = true
        invokedConnectSocketCount += 1
        invokedConnectSocketParameters = (socket, ())
        invokedConnectSocketParametersList.append((socket, ()))
    }
    var invokedDidDisconnect = false
    var invokedDidDisconnectCount = 0
    var invokedDidDisconnectParameters: (reason: String, Void)?
    var invokedDidDisconnectParametersList = [(reason: String, Void)]()
    func didDisconnect(reason: String) {
        invokedDidDisconnect = true
        invokedDidDisconnectCount += 1
        invokedDidDisconnectParameters = (reason, ())
        invokedDidDisconnectParametersList.append((reason, ()))
    }
    var invokedDisconnect = false
    var invokedDisconnectCount = 0
    func disconnect() {
        invokedDisconnect = true
        invokedDisconnectCount += 1
    }
    var invokedDisconnectSocketSocketIOClient = false
    var invokedDisconnectSocketSocketIOClientCount = 0
    var invokedDisconnectSocketSocketIOClientParameters: (socket: SocketIOClient, Void)?
    var invokedDisconnectSocketSocketIOClientParametersList = [(socket: SocketIOClient, Void)]()
    func disconnectSocket(_ socket: SocketIOClient) {
        invokedDisconnectSocketSocketIOClient = true
        invokedDisconnectSocketSocketIOClientCount += 1
        invokedDisconnectSocketSocketIOClientParameters = (socket, ())
        invokedDisconnectSocketSocketIOClientParametersList.append((socket, ()))
    }
    var invokedDisconnectSocketForNamespace = false
    var invokedDisconnectSocketForNamespaceCount = 0
    var invokedDisconnectSocketForNamespaceParameters: (nsp: String, Void)?
    var invokedDisconnectSocketForNamespaceParametersList = [(nsp: String, Void)]()
    func disconnectSocket(forNamespace nsp: String) {
        invokedDisconnectSocketForNamespace = true
        invokedDisconnectSocketForNamespaceCount += 1
        invokedDisconnectSocketForNamespaceParameters = (nsp, ())
        invokedDisconnectSocketForNamespaceParametersList.append((nsp, ()))
    }
    var invokedEmitAll = false
    var invokedEmitAllCount = 0
    var invokedEmitAllParameters: (event: String, items: [Any])?
    var invokedEmitAllParametersList = [(event: String, items: [Any])]()
    func emitAll(_ event: String, withItems items: [Any]) {
        invokedEmitAll = true
        invokedEmitAllCount += 1
        invokedEmitAllParameters = (event, items)
        invokedEmitAllParametersList.append((event, items))
    }
    var invokedReconnect = false
    var invokedReconnectCount = 0
    func reconnect() {
        invokedReconnect = true
        invokedReconnectCount += 1
    }
    var invokedRemoveSocket = false
    var invokedRemoveSocketCount = 0
    var invokedRemoveSocketParameters: (socket: SocketIOClient, Void)?
    var invokedRemoveSocketParametersList = [(socket: SocketIOClient, Void)]()
    var stubbedRemoveSocketResult: SocketIOClient!
    func removeSocket(_ socket: SocketIOClient) -> SocketIOClient? {
        invokedRemoveSocket = true
        invokedRemoveSocketCount += 1
        invokedRemoveSocketParameters = (socket, ())
        invokedRemoveSocketParametersList.append((socket, ()))
        return stubbedRemoveSocketResult
    }
    var invokedSocket = false
    var invokedSocketCount = 0
    var invokedSocketParameters: (nsp: String, Void)?
    var invokedSocketParametersList = [(nsp: String, Void)]()
    var stubbedSocketResult: SocketIOClient!
    func socket(forNamespace nsp: String) -> SocketIOClient {
        invokedSocket = true
        invokedSocketCount += 1
        invokedSocketParameters = (nsp, ())
        invokedSocketParametersList.append((nsp, ()))
        return stubbedSocketResult
    }
    var invokedEngineDidError = false
    var invokedEngineDidErrorCount = 0
    var invokedEngineDidErrorParameters: (reason: String, Void)?
    var invokedEngineDidErrorParametersList = [(reason: String, Void)]()
    func engineDidError(reason: String) {
        invokedEngineDidError = true
        invokedEngineDidErrorCount += 1
        invokedEngineDidErrorParameters = (reason, ())
        invokedEngineDidErrorParametersList.append((reason, ()))
    }
    var invokedEngineDidClose = false
    var invokedEngineDidCloseCount = 0
    var invokedEngineDidCloseParameters: (reason: String, Void)?
    var invokedEngineDidCloseParametersList = [(reason: String, Void)]()
    func engineDidClose(reason: String) {
        invokedEngineDidClose = true
        invokedEngineDidCloseCount += 1
        invokedEngineDidCloseParameters = (reason, ())
        invokedEngineDidCloseParametersList.append((reason, ()))
    }
    var invokedEngineDidOpen = false
    var invokedEngineDidOpenCount = 0
    var invokedEngineDidOpenParameters: (reason: String, Void)?
    var invokedEngineDidOpenParametersList = [(reason: String, Void)]()
    func engineDidOpen(reason: String) {
        invokedEngineDidOpen = true
        invokedEngineDidOpenCount += 1
        invokedEngineDidOpenParameters = (reason, ())
        invokedEngineDidOpenParametersList.append((reason, ()))
    }
    var invokedEngineDidReceivePong = false
    var invokedEngineDidReceivePongCount = 0
    func engineDidReceivePong() {
        invokedEngineDidReceivePong = true
        invokedEngineDidReceivePongCount += 1
    }
    var invokedEngineDidSendPing = false
    var invokedEngineDidSendPingCount = 0
    func engineDidSendPing() {
        invokedEngineDidSendPing = true
        invokedEngineDidSendPingCount += 1
    }
    var invokedParseEngineMessage = false
    var invokedParseEngineMessageCount = 0
    var invokedParseEngineMessageParameters: (msg: String, Void)?
    var invokedParseEngineMessageParametersList = [(msg: String, Void)]()
    func parseEngineMessage(_ msg: String) {
        invokedParseEngineMessage = true
        invokedParseEngineMessageCount += 1
        invokedParseEngineMessageParameters = (msg, ())
        invokedParseEngineMessageParametersList.append((msg, ()))
    }
    var invokedParseEngineBinaryData = false
    var invokedParseEngineBinaryDataCount = 0
    var invokedParseEngineBinaryDataParameters: (data: Data, Void)?
    var invokedParseEngineBinaryDataParametersList = [(data: Data, Void)]()
    func parseEngineBinaryData(_ data: Data) {
        invokedParseEngineBinaryData = true
        invokedParseEngineBinaryDataCount += 1
        invokedParseEngineBinaryDataParameters = (data, ())
        invokedParseEngineBinaryDataParametersList.append((data, ()))
    }
    var invokedEngineDidWebsocketUpgrade = false
    var invokedEngineDidWebsocketUpgradeCount = 0
    var invokedEngineDidWebsocketUpgradeParameters: (headers: [String: String], Void)?
    var invokedEngineDidWebsocketUpgradeParametersList = [(headers: [String: String], Void)]()
    func engineDidWebsocketUpgrade(headers: [String: String]) {
        invokedEngineDidWebsocketUpgrade = true
        invokedEngineDidWebsocketUpgradeCount += 1
        invokedEngineDidWebsocketUpgradeParameters = (headers, ())
        invokedEngineDidWebsocketUpgradeParametersList.append((headers, ()))
    }
}

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
