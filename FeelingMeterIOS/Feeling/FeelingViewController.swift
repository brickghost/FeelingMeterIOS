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

class FeelingViewController: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    //MARK: Properties
    var profile = FeelingView(frame: CGRect.zero)
    var feelingRatingControlerView = FeelingRatingControlView()
    var disposeBag = DisposeBag()
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
    
    override func viewDidLoad() {
        self.feelingRatingControlerView = self.profile.feelingRatingControlView
        self.feelingRatingControlerView.ratingButtons.forEach { (button) in
            button.rx.tap.subscribe(onNext: {[ weak self ] in
                let newFeeling = self?.getFeelingIndex(index: button.tag - 1)
                store.dispatch(changeFeeling(feeling: newFeeling ?? .meh))
                print("button tapped \(button.tag)")
            }).disposed(by: disposeBag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        store.unsubscribe(self)
    }
    
    //MARK: Private Methods
    func newState(state: FeelingViewController.StoreSubscriberStateType) {
        updateFeelingLabel(feeling: state.feeling)
        updateFeelingRatingControl(feeling: state.feeling)
    }
    
    func updateFeelingLabel(feeling: Feeling) {
        self.profile.feelingLabel.text = feeling.rawValue
    }
    
    func updateFeelingRatingControl(feeling: Feeling) {
        let rating = calcRating(feeling: feeling)
        feelingRatingControlerView.setButtonImages(rating: rating + 1)
    }
    
    func calcRating(feeling: Feeling) -> Int {
        return Feeling.allCases.firstIndex(of: feeling) ?? 1
    }
    
    func getFeelingIndex(index: Int) -> Feeling {
        return Feeling.allCases[index]
    }
}
