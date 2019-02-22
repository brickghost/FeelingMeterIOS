//
//  FeelingRatingControl.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/21/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import UIKit

class FeelingRatingControlView: UIView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 1

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButtons()
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        let stack = UIStackView(frame: frame)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        
        for _ in 0..<5 {
            let button = UIButton()
            
            button.backgroundColor = UIColor.yellow
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            
            stack.addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        
        self.addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true 
    }
}
