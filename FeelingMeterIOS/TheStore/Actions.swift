import ReSwift
import SocketIO

struct ChangeSocketStatusAction: Action {
    var socketStatus: SocketIOStatus
}

struct ChangeFeelingAction: Action {
    var feeling: Feeling
}
