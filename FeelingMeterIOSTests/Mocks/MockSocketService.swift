import RxSwift
import SocketIO

class MockSocketService: SocketService {
    var invokedStatusGetter = false
    var invokedStatusGetterCount = 0
    var stubbedStatus: Observable<SocketIOStatus>!
    override var status: Observable<SocketIOStatus> {
        invokedStatusGetter = true
        invokedStatusGetterCount += 1
        return stubbedStatus
    }
    var invokedFeelingGetter = false
    var invokedFeelingGetterCount = 0
    var stubbedFeeling: Observable<Feeling>!
    override var feeling: Observable<Feeling> {
        invokedFeelingGetter = true
        invokedFeelingGetterCount += 1
        return stubbedFeeling
    }
    var invokedEmitFeeling = false
    var invokedEmitFeelingCount = 0
    var invokedEmitFeelingParameters: (feeling: Feeling, Void)?
    var invokedEmitFeelingParametersList = [(feeling: Feeling, Void)]()
    override func emitFeeling(feeling: Feeling) {
        invokedEmitFeeling = true
        invokedEmitFeelingCount += 1
        invokedEmitFeelingParameters = (feeling, ())
        invokedEmitFeelingParametersList.append((feeling, ()))
    }
    var invokedConnect = false
    var invokedConnectCount = 0
    override func connect() {
        invokedConnect = true
        invokedConnectCount += 1
    }
    var invokedDisconnect = false
    var invokedDisconnectCount = 0
    override func disconnect() {
        invokedDisconnect = true
        invokedDisconnectCount += 1
    }
}
