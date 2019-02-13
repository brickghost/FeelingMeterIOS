//
//  FeelingViewController.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/12/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import UIKit

class FeelingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var profile: FeelingView
        
        profile = FeelingView(frame: CGRect.zero)
        self.view.addSubview(profile)
        
        profile.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
    }
}
