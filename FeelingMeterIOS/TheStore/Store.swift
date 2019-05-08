import ReSwift

let store = AnyStoreType(
    reducer: reducer,
    state: AppState())

private let socketService = SocketService()
let subscriptions = Subscriptions(socketService: socketService)

public enum Feeling: String, CaseIterable {
    case terrible = "Existence is pain"
    case notSoGood = "I can't adult today"
    case meh = "I just want my rug, man"
    case ok = "Living the Dream"
    case great = "I can't feel my face"
}
