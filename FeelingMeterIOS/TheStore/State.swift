import ReSwift
import SocketIO

public struct AppState: StateType, Equatable {
    var feeling: Feeling!
    var socketStatus: SocketIOStatus!
    
    init() {
        self.feeling = .meh
        self.socketStatus = .notConnected
    }
}
