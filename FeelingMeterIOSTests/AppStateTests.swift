import ReSwift
import XCTest

struct EmptyAction: Action { }

class AppStateTests: XCTestCase {

    var  state = AppState()
    override func setUp() {
        state = reducer(action: EmptyAction(), state: nil)
    }
    
    func testReducerReturnsMainState() {
        XCTAssertEqual(state, AppState())
    }
    
    func testDefaultFeeling() {
        XCTAssertEqual(state.feeling, .meh)
    }
    
    func testDefaultSocketStatus() {
        XCTAssertEqual(state.socketStatus, .notConnected)
    }
    
    func testChangeFeeling() {
        state = reducer(action: ChangeFeelingAction(feeling: .great), state: nil)
        XCTAssertEqual(state.feeling, .great)
    }
    
    func testChangeSocketStatus() {
        state = reducer(action: ChangeSocketStatusAction(socketStatus: .connecting), state: nil)
        XCTAssertEqual(state.socketStatus, .connecting)
    }
}
