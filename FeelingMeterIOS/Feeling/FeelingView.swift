//
//  FeelingView.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/12/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import UIKit
import PureLayout

class FeelingView: UIView {
    var shouldSetupConstraints = true
    
    let feelingLabel: UILabel = UILabel(frame: CGRect.zero)
    let screenSize = UIScreen.main.bounds
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        feelingLabel.text = "Feeling"
        self.backgroundColor = UIColor.white
        self.addSubview(feelingLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            feelingLabel.autoCenterInSuperview()
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
