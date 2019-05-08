import XCTest

class FeelingViewTests: XCTestCase {
    private var testObject: FeelingView!
    
    override func setUp() {
        testObject = FeelingView()
    }

    func testCallsDelegateCorrectly() {
        let mockDelegate = MockDelegateButtonTap()
        testObject.delegate = mockDelegate
        
        let index = Int.random(in: 0...4)
        
        XCTAssertFalse(mockDelegate.invokedButtonTapped)
        let button = testObject.ratingButtons[index]
        
        button.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(mockDelegate.invokedButtonTapped)
        XCTAssertEqual(1, mockDelegate.invokedButtonTappedCount)
        XCTAssertEqual(index, mockDelegate.invokedButtonTappedParameter)
        
        button.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(2, mockDelegate.invokedButtonTappedCount)
    }

}
