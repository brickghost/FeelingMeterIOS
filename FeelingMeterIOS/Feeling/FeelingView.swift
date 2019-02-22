//
//  FeelingView.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/12/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import UIKit

class FeelingView: UIView {
    
    //MARK: Properties
    var feelingRatingControlView = FeelingRatingControlView(frame: CGRect.zero)
    
    let feelingLabel: UILabel = UILabel(frame: CGRect.zero)
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        feelingLabel.text = "Feeling"
        feelingLabel.textAlignment = .center
        
        let stack = UIStackView(frame: frame)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 50
        stack.distribution = .fill
        stack.addArrangedSubview(feelingRatingControlView)
        stack.addArrangedSubview(feelingLabel)
        self.addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
