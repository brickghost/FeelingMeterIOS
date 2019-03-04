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
    weak var delegate: ButtonTap?
    
    var feelingViewStack = UIStackView()
    var ratingControlStack = UIStackView()
    var feelingLabel: UILabel = UILabel()
    var ratingButtons = [UIButton]()
    
    let starEmpty = UIImage(named: "StarEmpty")
    let starFull = UIImage(named: "StarFull")

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        feelingLabel.text = "Feeling"
        feelingLabel.textAlignment = .center
        
        feelingViewStack = UIStackView(frame: frame)
        ratingControlStack = UIStackView(frame: frame)
        
        addButtons()
        
        feelingViewStack.addArrangedSubview(ratingControlStack)
        feelingViewStack.addArrangedSubview(feelingLabel)
        self.addSubview(feelingViewStack)

        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addButtons() {
        for i in 1..<6 {
            let button = UIButton(type: .custom)
            
            button.tag = i - 1
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            ratingControlStack.addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
    }
    
    private func setupConstraints() {
        ratingControlStack.translatesAutoresizingMaskIntoConstraints = false
        ratingControlStack.topAnchor.constraint(equalTo: self.topAnchor)
        ratingControlStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ratingControlStack.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ratingControlStack.trailingAnchor.constraint(equalTo: self.leadingAnchor)
        ratingControlStack.axis = .horizontal
        ratingControlStack.distribution = .fillEqually
        ratingControlStack.spacing = 25
        
        
        feelingViewStack.translatesAutoresizingMaskIntoConstraints = false
        feelingViewStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        feelingViewStack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        feelingViewStack.axis = .vertical
        feelingViewStack.spacing = 50
        feelingViewStack.distribution = .fill
    }
    
    func setButtonImages(rating: Int) {
        for i in 0..<5 {
            let button = ratingButtons[i]
            let starImage = i <= rating - 1 ? starFull : starEmpty
            button.setImage(starImage, for: .normal)
        }
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        delegate?.buttonTapped(index: sender.tag)
    }
}
