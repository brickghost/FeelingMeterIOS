//
//  SocketService.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 3/5/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import Foundation
import RxSwift
import SocketIO

extension Reactive where Base: SocketIOClient {
    var status: Observable<SocketIOStatus> {
        return Observable.create { (observer) -> Disposable in
            let uuid = self.base.on(clientEvent: .statusChange) { (data, _) in
                if let status = data.first as? SocketIOStatus {
                    observer.onNext(status)
                }
            }
            return Disposables.create { self.base.off(id: uuid) }
        }
    }
    
    var feeling: Observable<Feeling> {
        return Observable.create { (observer) -> Disposable in
            let uuid = self.base.on("feeling") { (data, _) in
                if let feelingIndex = data.first as? Int {
                    let feeling = getFeelingByIndex(index: feelingIndex)
                    observer.onNext(feeling)
                }
            }
            return Disposables.create { self.base.off(id: uuid) }
        }
    }
}

protocol SocketServiceProtocol {
    var status: Observable<SocketIOStatus> { get }
    var feeling: Observable<Feeling> { get }
    func connect()
    func disconnect()
    func emitFeeling(feeling: Feeling)
}

class SocketService: SocketServiceProtocol {
    private let manager: SocketManagerSpec
    private let client: SocketIOClient
    private let disposeBag = DisposeBag()
    
    public convenience init() {
        let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress])
        self.init(manager: manager)
    }
    
    init(manager: SocketManagerSpec) {
        self.manager = manager
        self.client = manager.defaultSocket
    }
    
    public var status: Observable<SocketIOStatus> {
        return client.rx.status
    }
    
    public var feeling: Observable<Feeling> {
        return client.rx.feeling
    }
    
    func emitFeeling(feeling: Feeling) {
        client.emit("update", calcRating(feeling: feeling))
    }
    
    func connect() {
        client.connect()
        print("CONNECTING -> SOCKET STATUS \(client.status)")
    }
    
    func disconnect() {
        client.disconnect()
        print("DISCONNECTING -> SOCKET STATUS \(client.status)")
    }
}

func calcRating(feeling: Feeling) -> Int {
    return Feeling.allCases.firstIndex(of: feeling) ?? 1
}

func getFeelingByIndex(index: Int) -> Feeling {
    return Feeling.allCases[index]
}
