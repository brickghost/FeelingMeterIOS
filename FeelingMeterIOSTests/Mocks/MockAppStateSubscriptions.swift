import RxSwift
import SocketIO

class MockAppStateSubscriptions: SubscriptionsProtocol {
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
