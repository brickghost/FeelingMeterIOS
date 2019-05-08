import ReSwift
import XCTest
import RxSwift
import SocketIO
                             
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
