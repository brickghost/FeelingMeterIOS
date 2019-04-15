//
//  FeelingViewController.swift
//  FeelingMeterIOS
//
//  Created by Andrew Bricker on 2/12/19.
//  Copyright © 2019 code FU Creative. All rights reserved.
//

import UIKit
import ReSwift
import RxSwift
import RxCocoa

protocol ButtonTap: class {
    func buttonTapped(index: Int)
}

class FeelingViewController: UIViewController {
    
    //MARK: Properties
    var profile = FeelingView(frame: CGRect.zero)
    var disposeBag = DisposeBag()
    var stateSubscriptions: AppStateSubscriptions!
    var feeling: Feeling!
    
    //MARK: Initialization
    init(stateSubscriptions: AppStateSubscriptions = subscriptions) {
        self.stateSubscriptions = stateSubscriptions
        super.init(nibName: nil, bundle: nil)
        self.profile.delegate = self
        
        self.stateSubscriptions.feelingObservable
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
            if let feeling = event.element {
                self?.updateFeelingView(feeling: feeling)
            }
            }.disposed(by: self.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    func updateFeelingView(feeling: Feeling) {
        let rating = calcRating(feeling: feeling)
        self.feeling = feeling
        self.profile.setButtonImages(rating: rating + 1)
        self.profile.feelingLabel.text = feeling.rawValue
    }
    
    func calcRating(feeling: Feeling) -> Int {
        return Feeling.allCases.firstIndex(of: feeling) ?? 1
    }
    
    func getFeelingByIndex(index: Int) -> Feeling {
        return Feeling.allCases[index]
    }
}

extension FeelingViewController: ButtonTap {
    func buttonTapped(index: Int) {
        print("BUTTON TAP INVOKED")
        let clickedFeeling = getFeelingByIndex(index: index)
        if(clickedFeeling == feeling) {
            return
        }
        stateSubscriptions.dispatchFeelingToStore(feeling: clickedFeeling)
        
    }
}
