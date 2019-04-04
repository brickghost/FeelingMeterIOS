//
//  AppStateSubscriptions.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 3/25/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import Foundation
import SocketIO
import RxSwift

class AppStateSubscriptions {
    private var disposeBag: DisposeBag!
    private var socketService: SocketService!
    
    init(socketService: SocketService = SocketService(), scheduler: SchedulerType = MainScheduler.instance) {
        self.disposeBag = DisposeBag()
        self.socketService = socketService
        socketService.status.subscribe().disposed(by: self.disposeBag)
    }
}
