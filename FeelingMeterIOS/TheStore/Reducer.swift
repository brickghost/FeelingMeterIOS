import ReSwift

func reducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    case let socketStatus as ChangeSocketStatusAction:
        state.socketStatus = socketStatus.socketStatus
    case let feeling as ChangeFeelingAction:
        state.feeling = feeling.feeling
    default:
        return state
    }
    
    return state
}
