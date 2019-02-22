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
    
    //MARK: Properties
    var profile = FeelingView(frame: CGRect.zero)
    
    //MARK: Initialization
    override func loadView() {
        super.loadView()        
        self.view.addSubview(profile)
        profile.backgroundColor = UIColor.white
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        profile.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        profile.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        profile.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true        
    }
    
    //MARK: Private Methods
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
