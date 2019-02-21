//
//  FeelingViewController.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/12/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import UIKit
import ReSwift

class FeelingViewController: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    var profile = FeelingView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(profile)
        
        profile.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
    }
    
    func newState(state: FeelingViewController.StoreSubscriberStateType) {
        self.profile.feelingLabel.text = state.feeling.rawValue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        store.unsubscribe(self)
    }
}
