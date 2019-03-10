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

protocol SocketIOProtocol {
    var status: Observable<SocketIOStatus> { get }
    func connect()
    func disconnect()
}

//class SocketService: NSObject, SocketIOProtocol {
//    static let sharedInstance = SocketService()
class SocketService: SocketIOProtocol {

    private let socket: SocketIOProtocol
    private let disposeBag = DisposeBag()
    
    public convenience init() {
        let manager = SocketManager(socketURL: URL(string: "https://localhost:8080")!, config: [.log(true), .compress])
        let socket = manager.defaultSocket
        self.init(socket: socket as! SocketIOProtocol)
    }
    
    init(socket: SocketIOProtocol,
         scheduler: SchedulerType = MainScheduler.instance) {
        self.socket = socket
    }
    
    public var status: Observable<SocketIOStatus> {
        return socket.status
    }
    
    func connect() {
        socket.connect()
        print("CONNECTING -> SOCKET STATUS \(socket.status)")
    }
    
    func disconnect() {
        socket.disconnect()
        print("DISCONNECTING -> SOCKET STATUS \(socket.status)")
    }
}
