import ReSwift
import XCTest

class ActionsTests: XCTestCase {
    
    var  state = AppState()
    
    func testChangeFeeling() {
        state = reducer(action: ChangeFeelingAction(feeling: .great), state: nil)
        XCTAssertEqual(state.feeling, .great)
    }
    
    func testChangeSocketStatus() {
        state = reducer(action: ChangeSocketStatusAction(socketStatus: .connecting), state: nil)
        XCTAssertEqual(state.socketStatus, .connecting)
    }
}
