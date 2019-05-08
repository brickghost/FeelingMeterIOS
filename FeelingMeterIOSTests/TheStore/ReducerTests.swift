import ReSwift
import XCTest

fileprivate struct EmptyAction: Action { }

class ReducerTests: XCTestCase {
    
    var  state = AppState()
    override func setUp() {
        state = reducer(action: EmptyAction(), state: nil)
    }
    
    func testReducerReturnsMainState() {
        XCTAssertEqual(state, AppState())
    }
}
