//
//  FeelingViewControllerTests.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/14/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import ReSwift
import ReSwift
import XCTest
import RxSwift
import SocketIO

@testable import FeelingMeterIOS

class MockAppStateSubscriptions: AppStateSubscriptionsProtocol {
    var invokedFeelingObservableGetter = false
    var invokedFeelingObservableGetterCount = 0
    var stubbedFeelingObservable: Observable<Feeling>!
    var feelingObservable: Observable<Feeling> {
        invokedFeelingObservableGetter = true
        invokedFeelingObservableGetterCount += 1
        return stubbedFeelingObservable
    }
    var invokedUpdateFeeling = false
    var invokedUpdateFeelingCount = 0
    var invokedUpdateFeelingParameters: (feeling: Feeling, Void)?
    var invokedUpdateFeelingParametersList = [(feeling: Feeling, Void)]()
    func updateFeeling(feeling: Feeling) {
        invokedUpdateFeeling = true
        invokedUpdateFeelingCount += 1
        invokedUpdateFeelingParameters = (feeling, ())
        invokedUpdateFeelingParametersList.append((feeling, ()))
    }
    var invokedDispatchFeelingToStore = false
    var invokedDispatchFeelingToStoreCount = 0
    var invokedDispatchFeelingToStoreParameters: (feeling: Feeling, Void)?
    var invokedDispatchFeelingToStoreParametersList = [(feeling: Feeling, Void)]()
    func dispatchFeelingToStore(feeling: Feeling) {
        invokedDispatchFeelingToStore = true
        invokedDispatchFeelingToStoreCount += 1
        invokedDispatchFeelingToStoreParameters = (feeling, ())
        invokedDispatchFeelingToStoreParametersList.append((feeling, ()))
    }
    var invokedEmitFeelingToSocket = false
    var invokedEmitFeelingToSocketCount = 0
    var invokedEmitFeelingToSocketParameters: (feeling: Feeling, Void)?
    var invokedEmitFeelingToSocketParametersList = [(feeling: Feeling, Void)]()
    func emitFeelingToSocket(feeling: Feeling) {
        invokedEmitFeelingToSocket = true
        invokedEmitFeelingToSocketCount += 1
        invokedEmitFeelingToSocketParameters = (feeling, ())
        invokedEmitFeelingToSocketParametersList.append((feeling, ()))
    }
}

class MockFeelingView: FeelingView {
    var setButtonImagesCalled = false
    
    override func setButtonImages(rating: Int) {
        setButtonImagesCalled = true
    }
}
                             
class FeelingViewControllerTests: XCTestCase {
    private var testObject: FeelingViewController!
    private var mockAppStateSubscriptions: MockAppStateSubscriptions!
    private var testFeelingSubject: PublishSubject<Feeling>!
    
    override func setUp() {
        testFeelingSubject = PublishSubject<Feeling>()
        mockAppStateSubscriptions = MockAppStateSubscriptions()
        mockAppStateSubscriptions.stubbedFeelingObservable = testFeelingSubject
    }
    
    func testShouldSubscribeToFeelingObservable() {
        testObject = FeelingViewController(stateSubscriptions: mockAppStateSubscriptions)
        XCTAssertTrue(mockAppStateSubscriptions.invokedFeelingObservableGetter)
    }
    
    func testDisposeOfFeelingSubscription() {
        testObject = FeelingViewController(stateSubscriptions: mockAppStateSubscriptions)
        XCTAssertTrue(testFeelingSubject.hasObservers)
        
        testObject = nil
        
        XCTAssertFalse(testFeelingSubject.hasObservers)
    }

    func testShouldPopulateFeelingLabelFromFeelingSubscription() {
        testObject = FeelingViewController(stateSubscriptions: mockAppStateSubscriptions)
        testFeelingSubject.onNext(.terrible)
        XCTAssertEqual("Existence is pain", testObject.profile.feelingLabel.text)
    }
    
    func testShouldCallSetButtonImagesMethodFeelingFromFeelingSubscription() {
        let mockFeelingView = MockFeelingView()
        testObject = FeelingViewController(stateSubscriptions: mockAppStateSubscriptions)
        testObject.profile = mockFeelingView
        testFeelingSubject.onNext(.terrible)
        XCTAssertTrue(mockFeelingView.setButtonImagesCalled)
    }
    
    func testButtonTapProtocalInvokesSubscriptionsEvent() {
        testObject = FeelingViewController(stateSubscriptions: mockAppStateSubscriptions)
        testObject.buttonTapped(index: 1)
        let invokedFeeling = mockAppStateSubscriptions.invokedUpdateFeelingParameters?.feeling

        XCTAssertTrue(mockAppStateSubscriptions.invokedUpdateFeeling)
        XCTAssertEqual(mockAppStateSubscriptions.invokedUpdateFeelingCount, 1)
        XCTAssertEqual(invokedFeeling, Feeling.notSoGood)
    }

    func testButtonTapProtocalDoesNotDispatchToStoreWhenRatingNotChanged() {
        testObject = FeelingViewController(stateSubscriptions: mockAppStateSubscriptions)
        testObject.feeling = Feeling.meh
        testObject.buttonTapped(index: 2)
        
        XCTAssertFalse(mockAppStateSubscriptions.invokedUpdateFeeling)
    }
}
