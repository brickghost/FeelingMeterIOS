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
    
    let starEmpty = UIImage(named: "StarEmpty")
    let starFull = UIImage(named: "StarFull")
    
    var stack = UIStackView()

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
        stack = UIStackView(frame: frame)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        
        for i in 1..<6 {
            let button = UIButton(type: .custom)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.tag = i
            button.addTarget(nil, action: #selector(buttonAction), for: .touchUpInside)
            
            stack.addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        
        self.addSubview(stack)
        stack.topAnchor.constraint(equalTo: self.topAnchor)
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        stack.trailingAnchor.constraint(equalTo: self.leadingAnchor)
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    @objc func buttonAction(_ sender: UIButton){
        print("button tapped")
    }
    
    func setButtonImages(rating: Int) {
        for i in 0..<5 {
            let button = ratingButtons[i]
            let starImage = i <= rating - 1 ? starFull : starEmpty
            button.setImage(starImage, for: .normal)
        }
    }
}
