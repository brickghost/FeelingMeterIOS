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
}

protocol SocketServiceProtocol {
    var status: Observable<SocketIOStatus> { get }
    func connect()
    func disconnect()
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
    
    func connect() {
        client.connect()
        print("CONNECTING -> SOCKET STATUS \(client.status)")
    }
    
    func disconnect() {
        client.disconnect()
        print("DISCONNECTING -> SOCKET STATUS \(client.status)")
    }
}
